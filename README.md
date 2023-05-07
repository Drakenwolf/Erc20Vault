# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

# TestToken and Vault Smart Contracts Documentation

This document provides an overview of the TestToken and Vault smart contracts, their features, and their functions.

## TestToken

TestToken is an ERC20 token contract that uses OpenZeppelin's ERC20 and Ownable contracts to create a mintable token.

### Features

- Inherits from OpenZeppelin's ERC20 and Ownable contracts.
- The contract owner can mint new tokens.

### Functions

#### constructor

The constructor initializes the TestToken with a name, symbol, and initial supply.

```solidity
constructor() ERC20("test", "MTK") {
    _mint(msg.sender, 4000 * 10 ** decimals());
}
```

#### mint

The `mint` function allows the contract owner to mint new tokens and transfer them to a specified address.

```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

## Vault

The Vault contract is a simple token vault that allows users to deposit and withdraw an ERC20 token. The vault keeps track of each user's token balance.

### Features

- Stores and manages user balances for a specific ERC20 token.
- Allows users to deposit and withdraw tokens.
- Uses OpenZeppelin's IERC20 interface.

### Functions

#### constructor

The constructor sets the token address for the Vault contract.

```solidity
constructor(address _tokenAddress) {
    tokenAddress = _tokenAddress;
}
```

#### depositToken

The `depositToken` function allows users to deposit a specified amount of tokens into the vault. Before calling this function, users must approve the vault to transfer tokens on their behalf.

```solidity
function depositToken(uint256 amount) public {
    require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount, "Your token amount must be greater then you are trying to deposit");
    IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    userTokenBalance[msg.sender][tokenAddress] += amount;
    emit tokenDepositComplete(tokenAddress, amount);
}
```

#### withDrawAll

The `withDrawAll` function allows users to withdraw all their tokens from the vault.

```solidity
function withDrawAll() public {
    require(userTokenBalance[msg.sender][tokenAddress] > 0, "User doesnt has funds on this vault");
    uint256 amount = userTokenBalance[msg.sender][tokenAddress];
    IERC20(tokenAddress).transfer(msg.sender, amount);
    userTokenBalance[msg.sender][tokenAddress] = 0;
    emit tokenWithdrawalComplete(tokenAddress, amount);
}
```

#### withDrawAmount

The `withDrawAmount` function allows users to withdraw a specified amount of tokens from the vault.

```solidity
function withDrawAmount(uint256 amount) public {
    require(userTokenBalance[msg.sender][tokenAddress] >= amount);
    IERC20(tokenAddress).transfer(msg.sender, amount);
    userTokenBalance[msg.sender][tokenAddress] -= amount;
    emit tokenWithdrawalComplete(tokenAddress, amount);
}
```

### Events

- `tokenDepositComplete`: Emitted when a user deposits tokens into the vault.
- `tokenWithdrawalComplete`: Emitted when a user withdraws tokens from the vault.

Please note that this documentation provides an overview of the TestToken and Vault smart contracts, but a complete security audit should still be performed by a professional auditor before deploying these contracts to the mainnet.