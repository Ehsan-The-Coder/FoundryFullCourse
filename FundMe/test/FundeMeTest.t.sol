pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "../src/PriceConverter.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test, Script {
    using PriceConverter for uint256;
    FundMe fundMe;

    uint256 public constant AMOUNT_TO_FUND = 1 ether;
    uint256 public constant USERS_START_BALANCE = 1000 ether;
    uint8 public constant OWNER_INDEX = 0;
    address[10] public users = [
        address(1),
        address(2),
        address(3),
        address(4),
        address(5),
        address(6),
        address(7),
        address(8),
        address(9),
        address(10)
    ];

    //<---------------------------------------helper modifier------------------------------------------>
    modifier fund(uint256 userIndex) {
        address user = users[userIndex];
        vm.prank(user);
        fundMe.fund{value: AMOUNT_TO_FUND}();
        _;
    }

    //<---------------------------------------helper functions------------------------------------------>
    function setUp() public {
        //deploy fund me
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        //setup the owner at address 0
        address owner = fundMe.i_owner();
        users[OWNER_INDEX] = owner;
        fundUsersAccount();
    }

    function fundUsersAccount() public {
        uint256 userLength = users.length;
        for (uint8 userIndex = 0; userIndex < userLength; userIndex++) {
            address user = users[userIndex];
            vm.deal(user, USERS_START_BALANCE);
        }
    }

    function fundCallWithMultiple(bytes memory functionSignature) public {
        //what we can pass or test this function?
        //.call you can litterally call any function by passing his signature.
        //1.    fund function
        //2.    fallback function (when data not match to any function signature and raw ether sended )
        //3.    receive function (when have no data only raw ether sended )
        // Arrange
        uint256 contractBalanceBefore = address(fundMe).balance;
        uint256 totalAmountFunded = 0;
        uint256 userLength = users.length;
        for (uint8 funderIndex = 0; funderIndex < userLength; funderIndex++) {
            address funder = users[funderIndex];
            totalAmountFunded += AMOUNT_TO_FUND;
            vm.prank(funder);
            //Act
            (bool callSuccess, ) = address(fundMe).call{value: AMOUNT_TO_FUND}(
                functionSignature
            );
            //Assert
            assertEq(true, callSuccess);
            assertEq(fundMe.addressToAmountFunded(funder), AMOUNT_TO_FUND);
            assertEq(fundMe.funders(funderIndex), funder);
        }
        //Arrange
        uint256 contractBalanceAfter = address(fundMe).balance;
        //Assert
        assertEq(
            contractBalanceBefore + totalAmountFunded,
            contractBalanceAfter
        );
    }

    //<---------------------------------------test------------------------------------------>
    function testMinimumValue() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        address owner = users[OWNER_INDEX];
        assertEq(fundMe.i_owner(), owner);
    }

    function testFundExpectRevert() public {
        vm.expectRevert();
        //expect revert by passing 0 ether/value
        fundMe.fund();
    }

    function testFundWithSingle() public {
        // Arrange
        uint256 contractBalanceBefore = address(fundMe).balance;
        address funder = users[OWNER_INDEX]; //funder=owner
        vm.prank(funder);
        //Act
        fundMe.fund{value: AMOUNT_TO_FUND}();
        //Assert
        assertEq(fundMe.addressToAmountFunded(funder), AMOUNT_TO_FUND);
        assertEq(fundMe.funders(0), funder);
        //Arrange
        uint256 contractBalanceAfter = address(fundMe).balance;
        //Assert
        assertEq(contractBalanceBefore + AMOUNT_TO_FUND, contractBalanceAfter);
    }

    function testFundWithMultiple() public {
        //given the function signature so fund function is called and tested
        bytes memory dataCallInBytes = abi.encodePacked(
            bytes4(keccak256("fund()"))
        );
        fundCallWithMultiple(dataCallInBytes);
    }

    function testWithdrawExpectRevertNotOwner() public fund(OWNER_INDEX) {
        address user = users[OWNER_INDEX + 1]; //not owner
        vm.prank(user);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdraw() public fund(OWNER_INDEX) fund(OWNER_INDEX) {
        // Arrange
        address user = users[OWNER_INDEX];
        uint256 balanceUserBeforeWithdraw = address(user).balance;
        uint256 balanceContractBeforeWithdraw = address(fundMe).balance;
        //Act
        vm.prank(user);
        fundMe.withdraw();
        //Assert
        assertEq(
            address(user).balance,
            balanceUserBeforeWithdraw + balanceContractBeforeWithdraw
        );
        assertEq(address(fundMe).balance, 0);
    }

    function testFallback() public {
        //data is passed so fallback function is trigered
        string memory dataForCall = "fallaback is being called";
        bytes memory dataCallInBytes = bytes(dataForCall);
        fundCallWithMultiple(dataCallInBytes);
    }

    function testReceive() public {
        //no data is passed so receive function is trigered
        string memory dataForCall = "";
        bytes memory dataCallInBytes = bytes(dataForCall);
        fundCallWithMultiple(dataCallInBytes);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
