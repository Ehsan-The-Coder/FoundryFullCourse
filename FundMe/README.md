# Foundry Project

This project is a funding application that allows users to fund a minimum amount to the owner. Only the owner can withdraw the funds. The project uses Chainlink Price Feeds to convert the funded amount to USD.

## Files

1. `FundMe.sol`: This is the main contract of the project. It includes the logic for funding and withdrawing funds.

2. `PriceConverter.sol`: This is a library that provides utility functions for converting Ether amounts to USD and vice versa.

3. `DeployFundMe.s.sol`: This script deploys the `FundMe` contract and sets up the necessary configurations.

4. `FundeMeTest.t.sol`: This is the test suite for the `FundMe` contract. It tests various functionalities of the contract.

## Usage

To deploy the contract, run the `DeployFundMe.s.sol` script. This will deploy the `FundMe` contract and return its instance along with the price feed and mock price converter.

To interact with the contract, you can call the `fund` function to fund the contract. The `withdraw` function can be called by the owner to withdraw all the funds.

To test the contract, run the `FundeMeTest.t.sol` script. This will execute all the tests defined in the script.

## License

This project is licensed under the MIT License.

# A Huge Thanks To Patrick Collins
