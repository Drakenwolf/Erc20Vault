// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    address _owner;
    address tokenAddress;

    constructor(address _tokenAddress) {
        _owner = msg.sender;
        tokenAddress = _tokenAddress;
    }
    

    modifier isOwner {
        require(msg.sender == _owner);
        _;
    }

    event successfullyChangedOwner(address from, address to);

    function transferOwnerShip(address addr) public isOwner {
        _owner = addr;
        emit successfullyChangedOwner(msg.sender, addr);
    }
    
    // modifier checkAddress(address addr) {
    //     require(addr != address(0), "Token address must not be zero");
    //     require(isContract(addr), "Address must be of contract");
    //     _;        
    // }   

    function isContract(address addr) private view returns(bool) {
        uint codeLength;
        assembly {
            codeLength := extcodesize(addr)
        }
        return codeLength == 0 ? false : true;
    }

    // userAddress => tokenAddress => token amount
    mapping (address => mapping (address => uint256)) userTokenBalance;

    event tokenDepositComplete(address tokenAddress, uint256 amount);

    function depositToken( uint256 amount) public  {
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount, "Your token amount must be greater then you are trying to deposit");
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount));
        userTokenBalance[msg.sender][tokenAddress] += amount;
        emit tokenDepositComplete(tokenAddress, amount);
    }

    event tokenWithdrawalComplete(address tokenAddress, uint256 amount);

    function withDrawAll() public {
        require(userTokenBalance[msg.sender][tokenAddress] >= 0);
        uint256 amount = userTokenBalance[msg.sender][tokenAddress];
        IERC20(tokenAddress).transfer(msg.sender, amount);
        userTokenBalance[msg.sender][tokenAddress] = 0;
        emit tokenWithdrawalComplete(tokenAddress, amount);
    }

    function withDrawAmount(uint256 amount) public {
        require(userTokenBalance[msg.sender][tokenAddress] >= amount);
        IERC20(tokenAddress).transfer(msg.sender, amount);
        userTokenBalance[msg.sender][tokenAddress] -= amount;
        emit tokenWithdrawalComplete(tokenAddress, amount);
    }




    receive() external payable {}
}