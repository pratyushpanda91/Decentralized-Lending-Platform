// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './SafeMath.sol';
import './IERC20.sol'; // ERC20 Interface for token handling

contract CryptoCollateralizedLending {
    using SafeMath for uint;

    // Enum to represent the state of the loan
    enum LoanState { Requested, Funded, Repaid, Defaulted }

    // Struct to represent the loan details
    struct Loan {
        address borrower;
        uint requestedAmount;
        uint repayAmount;
        uint interestRate; // in percentage
        LoanState state;
        uint requestedDate;
        address collateralToken; // Token used as collateral
        uint collateralAmount;  // Amount of collateral provided
    }

    // Mapping to store loans by borrower address
    mapping(address => Loan) public loans;

    // Variable to store the available balance in the contract (in native currency)
    uint public availableBalance;

    // Function to add funds to the contract
    function addFunds() public payable {
        availableBalance = availableBalance.add(msg.value);
    }

    // Function to request a loan with collateral
    function requestLoanWithCollateral(
        uint amount, 
        address collateralToken, 
        uint collateralAmount
    ) public {
        require(amount > 0, "Loan amount must be greater than 0");
        require(collateralAmount > amount, "Collateral must be greater than the loan amount");

        // Check if the borrower already has an active loan
        Loan storage existingLoan = loans[msg.sender];
        require(
            existingLoan.state == LoanState.Repaid || 
            existingLoan.state == LoanState.Defaulted || 
            existingLoan.state == LoanState(0),
            "You must repay your existing loan before requesting a new one"
        );

        // Transfer collateral to the contract
        IERC20 collateralTokenInstance = IERC20(collateralToken);
        require(
            collateralTokenInstance.transferFrom(msg.sender, address(this), collateralAmount),
            "Collateral transfer failed"
        );

        // Calculate repay amount based on the loan details
        uint repayAmount = calculateRepayAmount(amount);

        // Create a new loan
        loans[msg.sender] = Loan({
            borrower: msg.sender,
            requestedAmount: amount,
            repayAmount: repayAmount,
            interestRate: 2,
            state: LoanState.Requested,
            requestedDate: block.timestamp,
            collateralToken: collateralToken,
            collateralAmount: collateralAmount
        });
    }

    // Function to fund a loan
    function fundLoan(address borrower) public {
        Loan storage loan = loans[borrower];

        require(loan.state == LoanState.Requested, "Loan is not in the requested state");
        require(availableBalance >= loan.requestedAmount, "Insufficient funds to fund the loan");

        // Transfer loan amount to the borrower
        payable(loan.borrower).transfer(loan.requestedAmount);

        // Update loan state to funded
        loan.state = LoanState.Funded;

        // Deduct funded amount from available balance
        availableBalance = availableBalance.sub(loan.requestedAmount);
    }

    // Function to repay a loan
    function repayLoan() public payable {
        Loan storage loan = loans[msg.sender];

        require(loan.state == LoanState.Funded, "Loan is not in the funded state");
        require(msg.value == loan.repayAmount, "Incorrect repayment amount");

        // Add repayment to available balance
        availableBalance = availableBalance.add(msg.value);

        // Return collateral to borrower
        IERC20 collateralTokenInstance = IERC20(loan.collateralToken);
        require(
            collateralTokenInstance.transfer(msg.sender, loan.collateralAmount),
            "Collateral return failed"
        );

        // Update loan state to repaid
        loan.state = LoanState.Repaid;
    }

    // Function to calculate repay amount
    function calculateRepayAmount(uint amount) internal pure returns (uint) {
        uint interest = amount.mul(2).div(100);
        return amount.add(interest);
    }

    // Function to liquidate collateral in case of default
    function liquidateCollateral(address borrower) public {
        Loan storage loan = loans[borrower];
        require(loan.state == LoanState.Funded, "Loan is not in a defaultable state");
        require(block.timestamp > loan.requestedDate + 1 minutes, "Loan is not overdue");

        // Mark loan as defaulted
        loan.state = LoanState.Defaulted;

        // Transfer collateral to the contract owner (or sell via marketplace)
        IERC20 collateralTokenInstance = IERC20(loan.collateralToken);
        require(
            collateralTokenInstance.transfer(msg.sender, loan.collateralAmount),
            "Collateral liquidation failed"
        );
    }
}
