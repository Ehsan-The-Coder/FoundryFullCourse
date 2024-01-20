// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //get the price feed address based on the chainid
        HelperConfig helperConfig = new HelperConfig();
        AggregatorV3Interface ethToUsdPriceFeed = helperConfig
            .activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(AggregatorV3Interface(ethToUsdPriceFeed));
        vm.stopBroadcast();
        return fundMe;
    }
}
