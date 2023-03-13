// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Caller {
    address public proxyAddr;

    constructor(address proxyAddr_) {
        proxyAddr = proxyAddr_;
    }

//通过call方法
    function call() external returns (uint256) {
        (, bytes memory data) = proxyAddr.call(
            abi.encodeWithSignature("addNum()")
        );
        return abi.decode(data, (uint256));
    }
}
