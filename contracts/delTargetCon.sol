// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DelTargetCon {
    uint256 public value = 10;

    constructor() payable {}

    receive() external payable {}

    //向合约转账
    function transderToContract() public payable {
        payable(address(this)).transfer(msg.value);
    }

    //合约自毁，将ETH发送给调用者
    function delCon() external {
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns (uint256 v) {
        v = address(this).balance;
    }
}
