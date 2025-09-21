// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

//合并俩个有序数组
contract MergeSortedArr{
   
    function merge(int[] memory first, int[] memory second) public pure returns (int[] memory) {
        require(first.length>0, "first array must have elements");
        require(second.length>0, "second array must have elements");
        uint i = 0;
        uint j = 0;
        uint k = 0;
        //memory中的数组必须指定长度，且不能用push
        int[] memory res = new int[](first.length + second.length);
        console.log("first.length", first.length);
        console.log("second.length", second.length);
        console.log("i < first.length", i < first.length);
        while(i < first.length && j < second.length) {
            if (first[i] < second[j]) {
               res[k++] = first[i++];
            } else {
                res[k++] = second[j++];
            }
        }
        //剩下的
        while (i < first.length) {
            res[k++] = first[i++];
        }
        while (j < second.length) {
            res[k++] = second[j++];
        }
        return res;
    }
}