# Crypto Collateralized Lending

This repository contains the `Solidity` code for a **decentralized lending platform** that allows users to request and fund loans using cryptocurrency with collateral. 

This version focuses solely on testing the smart contracts in `Remix with test Ether` and **does not require any external wallet or environment setup**.

---

## Files in the Repository

- `CryptoCollateralizedLending.sol`: The main smart contract for the lending platform.
- `IERC20.sol`: Interface for ERC20 tokens used as collateral.
- `SafeMath.sol`: Library for secure arithmetic operations.

---

## Prerequisites

1. **Remix IDE**:
   - Access [Remix](https://remix.ethereum.org/) to compile, deploy, and interact with the contracts.
2. **Test Ether**:
   - Use the test Ether provided in the Remix JavaScript VM for all interactions.
3. **Environment**:
   - Ensure you are using the Remix JavaScript VM (Berlin) for testing.

---

## Steps to Test the Contract

### 1. Clone the Repository
```bash
git clone https://github.com/pratyushpanda91/Decentralized-Lending-Platform.git
```

### 2. Open Remix IDE
- Go to [Remix](https://remix.ethereum.org/).
- In the **File Explorer**, create a new folder and upload the following files:
  - `CryptoCollateralizedLending.sol`
  - `IERC20.sol`
  - `SafeMath.sol`

---

### 3. Compile the Contracts
1. Navigate to the **Solidity Compiler** tab in Remix.
2. Select `0.8.19` as the Solidity compiler version to match the pragma directive.
3. Compile the main contract: `CryptoCollateralizedLending.sol`.

---

### 4. Deploy the Contract
1. Switch to the **Deploy & Run Transactions** tab.
2. Use the `JavaScript VM (Berlin)` environment for testing.
3. Deploy the `CryptoCollateralizedLending` contract.
4. Once deployed, the contract will appear under the **Deployed Contracts** section.

---

### 5. Test the Contract

#### Add Funds to the Lending Platform
1. In the **Deployed Contracts** section, locate the `addFunds()` function.
2. Enter an amount of test Ether to deposit (e.g., `5 Ether`).
3. Click the **Transact** button and confirm the transaction.

#### Approve collateral From Test Token
1. Use the `IERC20.sol` function.
2. Approve:
   - Sender ~ Address
   - value ~ >Loan amonut(e.g. `5` ethers in wei)
#### Request a Loan with collateral
1. Use the `requestLoanWithCollateral()` function.
2. Parameters:
   - Loan amount in Ether (e.g., `2 Ether`).
   - Address of the collateral token (e.g., the address of an ERC20 token contract if available).
   - Collateral amount (e.g., `5` ethers of the collateral token).
3. Submit the transaction and verify the loan creation using the `loans` mapping.

#### Fund a Loan
1. Call the `fundLoan()` function with the borrower’s address.
2. Confirm the transaction.
3. Verify the loan is funded by checking its state.

#### Repay a Loan
1. Use the `repayLoan()` function to repay the loan.
2. Verify the loan state changes to `Repaid` and the collateral is returned.

#### Liquidate Defaulted Loan
1. After the loan becomes overdue, use the `liquidateCollateral()` function with the borrower's address.
2. Verify the loan state changes to `Defaulted`.

---

## Additional Notes

- **Interest Rate**: Fixed at 2%.
- **Overdue Period**: 1 minute (for testing purposes).
- **Testing Tokens**: Use dummy values or deploy a test ERC20 token if needed for collateral testing.

---
## Tips for Testing
- Use `different accounts` for lender, borrower and liquidator.
- Monitor `balances` and `states` using the contract's view functions.
- **Add edge cases like:**
   -Requesting loans without sufficient collateral.
   -Trying to fund loans with insufficient contract balance.
   -Repaying with incorrect amounts.

---
## Test Cases
### Scenario 1: Successful Loan
1. Add `5 ETH` to the contract.
2. Request a loan for `2 ETH` using `5 ETH` as `collateral`.
3. Fund the loan using the `fundLoan` function.
4. Repay the loan by sending `2.04 ETH`.
5. Collateral is returned to the borrower.
   
### Scenario 2: Loan Default
1. Request a loan and let the due date pass(`1 min` here to test).
2. Call `liquidateCollateral`.
3. Collateral is liquidated and the loan is marked `Defaulted`.

---
## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Author

- **Name**: `Pratyush Panda`
- **GitHub**: [ Profile](https://github.com/pratyushpanda91)
- **X**: [Twitter Profile](https://x.com/pandapratyush91)
- **LinkedIn**: [Profile](https://www.linkedin.com/in/pratyushpanda91/)

---

## Contributions

Contributions are welcome! Please open a pull request or create an issue for any suggestions or improvements.
```

This version focuses solely on testing the smart contracts in Remix with test Ether and does not require any external wallet or environment setup.
