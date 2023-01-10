// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

error SendFailed(); // 用send发送ETH失败error
error CallFailed(); // 用call发送ETH失败error

contract SendETH {
    // 构造函数，payable使得部署的时候可以转eth进去
    constructor() payable {}

    // receive方法，接收eth时被触发
    receive() external payable {}

    //transfer方法中的地址参数是接收方的参数
    function transferETH(address payable toAddr, uint256 amount)
        external
        payable
    {
        toAddr.transfer(amount);
    }

    //第二种发送ETH的方法
    function sendETH(address payable toAddr, uint256 amount) external payable {
        bool success = toAddr.send(amount);
        if (!success) {
            revert SendFailed();
        }
    }

    //第三种方法，前两种方法gas都有限制，超出gas会报错，这种方法没有gas限制,最常用的是这种方式
    function callETH(address payable toAddr, uint256 amount) external payable {
        (bool success, ) = toAddr.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}
