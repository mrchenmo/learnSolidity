// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//目标合约C，供给合约B通过delegatecall调用
//使用场景就是代理合约，存储合约和逻辑合约分开，存储合约B通过delegatecall调用逻辑合约C，升级时只要升级逻辑合约，将存储合约指向新的逻辑合约即可
contract TargetConC {
    uint256 public num;
    address public sender;

    function setParams(uint256 _x) public payable {
        num = _x;
        sender = msg.sender;
    }
}
