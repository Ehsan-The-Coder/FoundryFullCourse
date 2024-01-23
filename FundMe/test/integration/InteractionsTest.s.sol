pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {MockPriceConverter} from "../../src/mocks/MockPriceConverter.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/deploy/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/deploy/HelperConfig.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test, Script {
    FundMe fundMe;
    AggregatorV3Interface priceFeed;
    MockPriceConverter mockPriceConverter;

    uint256 public constant AMOUNT_TO_FUND = 0.1 ether;
    uint256 public constant USERS_START_BALANCE = 10 ether;
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

    //<---------------------------------------helper functions------------------------------------------>
    function setUp() public {
        //deploy fund me
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundMe, priceFeed, mockPriceConverter) = deployFundMe.run();
        //setup the owner at address 0
        address owner = fundMe.getOwner();
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

    //<---------------------------------------test------------------------------------------>

    function testFundAndWithdraw() external {
        FundFundMe fundFundMe = new FundFundMe();
        for (uint256 i = 0; i < 6; i++) {
            fundFundMe.fundFundMe(address(fundMe));
        }

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
    }
}
