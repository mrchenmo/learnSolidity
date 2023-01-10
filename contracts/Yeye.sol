// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Yeye {
    event log(string msg);

//使用virtual 修饰，来保证可以被子合约重写
    function jump() public virtual{
        emit log("yeye jump");
    }

    function run() public {
        emit log("yeye run");
    }

    function logName() public {
        emit log("yeye name macbook pro");
    }
}
