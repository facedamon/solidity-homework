// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

//正整数转罗马数字
contract IntegerToRoman {
    struct mm {
        uint16 value;
        string symbol;
    }

    mm[] private ms;

    constructor() {
       ms.push(mm(1000, "M"));
       ms.push(mm(900, "CM"));
       ms.push(mm(500, "D"));
       ms.push(mm(400, "CD"));
       ms.push(mm(100, "C"));
       ms.push(mm(90, "XC"));
       ms.push(mm(50, "L"));
       ms.push(mm(40, "XL"));
       ms.push(mm(10, "X"));
       ms.push(mm(9, "IX"));
       ms.push(mm(5, "V"));
       ms.push(mm(4, "IV"));
       ms.push(mm(1, "I"));
    }

    function intToRoman(uint num) public view returns(string memory) {
        require(num <= 3999 && num > 0, "number must be between 1 and 3999");
        //bytes memory romanBytes;
        string memory s;
        //遍历结构体数组
        for (uint i = 0; i < ms.length; i++) {
            while (num >= ms[i].value) {
                //转为字节数组
                //bytes memory symbolBytes = bytes(ms[i].symbol);
                //类似于go 的append
                //for (uint j = 0; j < symbolBytes.length; j++) {
                //    romanBytes = abi.encodePacked(romanBytes, symbolBytes[j]);
                //}
                s = string.concat(s, ms[i].symbol);
                num -= ms[i].value;
            }
            if (num == 0) {
                break;
            } 
        }
        //return string(romanBytes);
        return s;
    }
}