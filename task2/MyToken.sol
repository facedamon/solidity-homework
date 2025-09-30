// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyToken is IERC20 {

    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    //名字符号
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _mint(msg.sender, 1_000_000_000);
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
   
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

   
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

   
    function transfer(address to, uint256 value) external returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert();
            }
            _balances[from] = fromBalance - value;
        }
        
        if (to == address(0)) {
            _totalSupply -= value;
        } else {
            _balances[to] += value;
        }

        emit Transfer(from, to, value);
    }

   
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    // 建立一种委托关联
    function approve(address spender, uint256 value) external returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value) internal {
        if (owner == address(0)) {
            revert();
        }
        if (spender == address(0)) {
            revert();
        }
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    // 执行这个方法之前必须先执行approve建立委托关联数据加入_allowed中
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _spendAllowance(address owner, address spender, uint256 value) private {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < value) {
            revert();
        } 
        _approve(owner, spender, currentAllowance - value);
    }

    function _mint(address account, uint256 value) internal {
        _update(address(0), account, value);
    }
}