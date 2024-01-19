pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "../src/PriceConverter.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    using PriceConverter for uint256;
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe();
    }

    function testMinimumValue() public {
        console.log(fundMe.i_owner());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testFund() public {
        // fundMe.fund{value: 1 ether}();
    }
}
