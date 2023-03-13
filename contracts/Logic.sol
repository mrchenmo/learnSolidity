// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Logic {
    address public implementation; //要与逻辑合约保持一致
    uint256 public x = 213;
    event CallSuccess();

    function addNum() external returns (uint256) {
        emit CallSuccess();
        return x + 1;
    }

    function addNumHashSign() external pure returns (bytes4 sign) {
        return bytes4(keccak256("addNum()"));
    }
}
