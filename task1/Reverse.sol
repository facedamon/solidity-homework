// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

contract Reverse {
    function reverse_string(string memory str) public pure returns (string memory) {
       bytes memory s = bytes(str);
       bytes memory r = new bytes(s.length);
    
       for (uint i = 0; i < s.length; i++) {
            r[i] = s[s.length - i - 1];
       }
       return string(r);
    }
}