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
    //返回的结果是1，因为在代理合约中没有设置这个参数x，在逻辑合约中这个x就是=0，而不是逻辑合约中的x=213
    //在代理合约中增加参数x=99，再次部署合约，再次就是在99的基础上+1，变成了100
    //如果代理合约中的参数不叫x换成xx，会发生什么
}
