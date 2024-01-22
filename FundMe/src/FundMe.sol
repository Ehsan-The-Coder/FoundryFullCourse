// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//<----------------------------import statements---------------------------->
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

/**
 * @title FundMe
 * @author Muhammad Ehsan inspired from Patrick Collins
 * contact https://github.com/MuhammadEhsanJutt
 * @dev This project is a funding application that
 * enables users to fund amount more MINIMUM_USD to owner and only owner can withdraw it
 */
contract FundMe {
    using PriceConverter for uint256;

    //<----------------------------state variable---------------------------->
    //store the list of the address and how much they fundus
    mapping(address => uint256) private s_addressToAmountFunded;
    //store only funder addresses
    address[] private s_funders;
    address private immutable i_owner;
    AggregatorV3Interface private immutable i_priceFeed;
    uint256 private constant MINIMUM_USD = 5e18;

    //<----------------------------custom errors---------------------------->
    error FundMe__NotOwner();
    error FundMe__WithdrawFails();
    error FundMe__FundingAmountIsTooLow();

    //<----------------------------modifiers---------------------------->
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }
    //check if the sended ether amount is greater than the MINIMUM_USD

    modifier isGreaterThanMinimumAmount() {
        uint256 valueInUSD = msg.value.getConversionRate(i_priceFeed);

        if (valueInUSD < MINIMUM_USD) {
            revert FundMe__FundingAmountIsTooLow();
        }
        _;
    }

    //<----------------------------functions---------------------------->
    //<----------------------------special functions---------------------------->
    constructor(AggregatorV3Interface priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = priceFeed;
    }

    //
    fallback() external payable {
        fund();
    }

    //
    receive() external payable {
        fund();
    }

    //<----------------------------public functions---------------------------->
    function fund() public payable isGreaterThanMinimumAmount {
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        address[] memory funders = s_funders;
        //fLength==fundersLength
        uint256 fLength = funders.length;
        //fIndex==funderIndex
        for (uint256 fIndex = 0; fIndex < fLength; fIndex++) {
            s_addressToAmountFunded[funders[fIndex]] = 0;
        }
        s_funders = new address[](0);

        (bool isSuccess, ) = payable(i_owner).call{
            value: address(this).balance
        }("");
        if (isSuccess == false) {
            //means calls fails
            revert FundMe__WithdrawFails();
        }
    }

    //<----------------------------external/public view/pure functions---------------------------->

    function getConversionRate(
        uint256 amountToConvert
    ) external view returns (uint256) {
        return amountToConvert.getConversionRate(i_priceFeed);
    }

    function getPrice() external view returns (uint256) {
        return PriceConverter.getPrice(i_priceFeed);
    }

    function getVersion() external view returns (uint256) {
        return i_priceFeed.version();
    }

    function getAddressAmountFunded(
        address account
    ) external view returns (uint256) {
        return s_addressToAmountFunded[account];
    }

    function getFunder(uint256 funderIndex) external view returns (address) {
        return s_funders[funderIndex];
    }

    function getFundersLength() external view returns (uint256) {
        return s_funders.length;
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPriceFeed() external view returns (address) {
        return address(i_priceFeed);
    }

    function getMinimumUSD() external pure returns (uint256) {
        return MINIMUM_USD;
    }
}
