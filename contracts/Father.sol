// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./Yeye.sol"; //要继承父合约需要将父合约import进来

contract Father is Yeye {
    //子合约使用override修饰，被重写的父合约的方法。
    function jump() public override {
        emit log("father jump");
    }

    function runF() public {
        emit log("father run");
    }

    function logNameF() public {
        emit log("father name jobs");
    }
}
