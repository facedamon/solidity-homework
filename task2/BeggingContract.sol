// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable {

    //捐赠
    mapping(address account => uint256) private _donates;
    //记录转账失败事件
    event FallbackTriggered(address sender, uint256 amount, bytes data);
    //msg.sender自动为所有者
    constructor() Ownable(msg.sender) {

    }

    receive() external payable { 
        _donates[_msgSender()] += msg.value;
    }

    fallback() external payable {
        emit FallbackTriggered(_msgSender(), msg.value, msg.data);
    }

    function donate() external payable  {
        require(msg.value > 0, "donate value must gt zero");
        _donates[_msgSender()] += msg.value;
    }

    function withdraw() external onlyOwner {
        //(bool success, ) = _msgSender.call{value: address(this).balance}("");
        //return success;
        payable(_msgSender()).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getDonation(address account) external view returns(uint256) {
        return _donates[account];
    }

}