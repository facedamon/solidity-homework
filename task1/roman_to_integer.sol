// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

//罗马数字转正整数
contract RomanToInteger {
    mapping(bytes1 => uint16) private romanMap;

    constructor() {
        romanMap['I'] = 1;
        romanMap['V'] = 5;
        romanMap['X'] = 10;
        romanMap['L'] = 50;
        romanMap['C'] = 100;
        romanMap['D'] = 500;
        romanMap['M'] = 1000;
    }

    function romanToInt(string memory s) public view returns (uint r) {
        bytes memory bs = bytes(s);
        uint n = bs.length;
        if (n == 0) {
            return 0;
        }
        for (uint i = 0; i < n; i++) {
            uint v = romanMap[bs[i]];
            if (i < n-1 && v < romanMap[bs[i+1]]) {
                r -= v;
            } else {
                r += v;
            }
        }
        return r;
    }
}