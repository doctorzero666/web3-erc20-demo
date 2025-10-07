// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;   // Solidity 版本

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";       // ERC20 标准实现
import "@openzeppelin/contracts/access/Ownable.sol";         // 只有 owner 能调用的控制

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") Ownable(msg.sender) {
        // 初始供应量直接 mint 给部署者
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    // 允许合约 owner 额外增发代币
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }
}