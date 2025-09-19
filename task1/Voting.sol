// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

contract Voting {
    //得票mapping
    mapping(address => uint256) private tickets;
    //候选人keys
    address[] private keys;
    //是否已加入
    mapping(address => bool) private inserted;

    function vote(address addr) public {
        tickets[addr]++;
        //第一次加入
        if (!inserted[addr]) {
            inserted[addr] = true;
            keys.push(addr);
        }
    }

    function getVotes(address addr) public view returns(uint256) {
        require(inserted[addr], "this address not ticket");
        return tickets[addr];
    }

    function resetVotes() public {
        for (uint256 i = 0; i < keys.length; i++) {
            address key = keys[i];
            tickets[key] = 0; 
        }
        keys = new address[](0);
    }
}