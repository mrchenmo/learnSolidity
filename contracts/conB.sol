// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//合约B可以理解为上例的存储合约，调用目标合约C
//需要注意，合约B和合约C的变量类型和位置顺序要一样
contract ConB {
    uint256 public num;
    address public sender;

    //会修改C合约中参数的值
    function callTargetSet(address _addr, uint256 _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setParams(uint256)", _num)
        );
    }

    //C合约的值不会被修改，还是调用者合约的传进来的值，但是B合约的值被修改了
    function delegateCallTargetFun(address _addr, uint256 x) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setParams(uint256)", x)
        );
    }
}
