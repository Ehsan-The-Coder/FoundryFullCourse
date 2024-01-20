// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        );
        vm.stopBroadcast();
        return fundMe;
    }
}
