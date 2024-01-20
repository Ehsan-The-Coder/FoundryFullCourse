// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

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
            activeNetworkConfig = getMainNetEthConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getAnvilEthConfig();
        } else {
            revert HelperConfig__ChainIdNotAvailable(block.chainid);
        }
    }

    function getSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory networkConfig)
    {
        networkConfig = NetworkConfig({
            priceFeed: AggregatorV3Interface(
                0x694AA1769357215DE4FAC081bf1f309aDC325306
            )
        });
    }

    function getMainNetEthConfig()
        public
        pure
        returns (NetworkConfig memory networkConfig)
    {
        networkConfig = NetworkConfig({
            priceFeed: AggregatorV3Interface(
                0x694AA1769357215DE4FAC081bf1f309aDC325306
            )
        });
    }

    function getAnvilEthConfig()
        public
        pure
        returns (NetworkConfig memory networkConfig)
    {
        networkConfig = NetworkConfig({
            priceFeed: AggregatorV3Interface(
                0x694AA1769357215DE4FAC081bf1f309aDC325306
            )
        });
    }
}
