// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {DeployMockV3Aggregator} from "./mocks/DeployMockV3Aggregator.s.sol";

error HelperConfig__ChainIdNotAvailable(uint256 chainId);

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        AggregatorV3Interface priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getAnvilEthConfig();
        } else {
            revert HelperConfig__ChainIdNotAvailable(block.chainid);
        }
    }

    //ETH TO USD
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory networkConfig) {
        networkConfig = NetworkConfig({priceFeed: AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)});
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory networkConfig) {
        networkConfig = NetworkConfig({priceFeed: AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)});
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory networkConfig) {
        networkConfig = NetworkConfig({priceFeed: AggregatorV3Interface(deployMock())});
    }

    function deployMock() private returns (address priceFeed) {
        DeployMockV3Aggregator deployMockV3Aggregator = new DeployMockV3Aggregator();
        priceFeed = deployMockV3Aggregator.run();
    }

    function test() external {
        //created only to ignore the forge coverage
    }
}
