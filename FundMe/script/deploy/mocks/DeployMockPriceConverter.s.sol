// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockPriceConverter} from "../../../src/mocks/MockPriceConverter.sol";

contract DeployMockPriceConverter is Script {
    function run() external returns (MockPriceConverter mockPriceConverter) {
        vm.startBroadcast();
        mockPriceConverter = new MockPriceConverter();
        vm.stopBroadcast();
    }

    function test() external {
        //created only to ignore the forge coverage
    }
}
