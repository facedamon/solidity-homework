// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "hardhat/console.sol";

contract BinarySearch {
    
    //二分查找返回target的下标
    function binarySearch(int[] memory nums, int target) public pure returns (int) {
        require(nums.length >0, "nums must have elements");
        uint left = 0;
        uint right = nums.length - 1;
        //不用<=
        while (left < right) {
            uint mid = (left+right)/2;
            console.log("left", left);
            console.log("right", right);
            console.log("mid", mid);
            if (nums[mid] == target) {
                return int(mid);
            } else if (nums[mid] < target) {
                left = mid + 1;
            } else {
                //uint这个地方可能出现负数
                //牺牲right增加查询次数
                //right = mid - 1;
                right = mid;
            }
        }
        //结束后，检查left所指的元素是否是target
        if (nums[left] == target) {
            return int(left);
        }

        return -1;
    }
}