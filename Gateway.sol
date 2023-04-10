// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenExchange {
    address public owner;
    address public tokenAddress;
    uint256 public ethPrice;
    
    constructor(address _tokenAddress, uint256 _ethPrice) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        ethPrice = _ethPrice;
    }
    
    function exchange() public payable {
        require(msg.value > 0, "Invalid amount of ETH sent");
        
        uint256 tokenAmount = msg.value * ethPrice;
        
        require(IERC20(tokenAddress).balanceOf(address(this)) >= tokenAmount, "Insufficient token balance in contract");
        
        require(IERC20(tokenAddress).transfer(msg.sender, tokenAmount), "Token transfer failed");
    }
    
    function setEthPrice(uint256 _ethPrice) public {
        require(msg.sender == owner, "Only contract owner can set ETH price");
        ethPrice = _ethPrice;
    }
    
    function withdrawETH() public {
        require(msg.sender == owner, "Only contract owner can withdraw ETH");
        payable(owner).transfer(address(this).balance);
    }
    
    function withdrawTokens() public {
        require(msg.sender == owner, "Only contract owner can withdraw tokens");
        require(IERC20(tokenAddress).transfer(owner, IERC20(tokenAddress).balanceOf(address(this))), "Token transfer failed");
    }
}
