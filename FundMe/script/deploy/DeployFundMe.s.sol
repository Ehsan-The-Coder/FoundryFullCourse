// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Script} from "forge-std/Script.sol";
import {DeployMockPriceConverter} from "./mocks/DeployMockPriceConverter.s.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {MockPriceConverter} from "../../src/mocks/MockPriceConverter.sol";

contract DeployFundMe is Script {
    function run()
        external
        returns (FundMe, AggregatorV3Interface, MockPriceConverter)
    {
        //get the price feed address based on the chainid
        HelperConfig helperConfig = new HelperConfig();
        AggregatorV3Interface priceFeed = helperConfig.activeNetworkConfig();
        //get MockPriceConverter address
        DeployMockPriceConverter deployMockPriceConverter = new DeployMockPriceConverter();
        MockPriceConverter mockPriceConverter = deployMockPriceConverter.run();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(AggregatorV3Interface(priceFeed));
        vm.stopBroadcast();
        return (fundMe, priceFeed, mockPriceConverter);
    }

    function test() external {
        //created only to ignore the forge coverage
    }
}
