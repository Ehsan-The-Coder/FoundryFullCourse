// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DeployFundMe} from "./deploy/DeployFundMe.s.sol";
import {HelperConfig} from "./deploy/HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    FundMe private fundMe;
    AggregatorV3Interface private priceFeed;
    uint256 constant FUND_AMOUNT = 0.01 ether;

    function fundFundMe(address recentContractAddress) public {
        vm.startBroadcast();
        FundMe(payable(recentContractAddress)).fund{value: FUND_AMOUNT}();
        vm.stopBroadcast();
        uint256 balance = recentContractAddress.balance;
        console.log("You have successfully funded %s", FUND_AMOUNT);
        console.log("New balance of contract is  %s", balance);
    }

    function run() external {
        address recentContractAddress = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(recentContractAddress);
    }
}

contract WithdrawFundMe is Script {
    // FundMe private fundMe;
    // AggregatorV3Interface private priceFeed;
    // function withdrawFundMe(address recentContractAddress) public {
    //     vm.startBroadcast();
    //     uint256 balance = recentContractAddress.balance;
    //     FundMe(payable(recentContractAddress)).withdraw();
    //     vm.stopBroadcast();
    //     console.log("You have successfully %s", balance);
    // }
    // function run() external {
    //     DeployFundMe deployFundMe = new DeployFundMe();
    //     (fundMe, priceFeed) = deployFundMe.run();
    //     withdrawFundMe(address(fundMe));
    // }
}
