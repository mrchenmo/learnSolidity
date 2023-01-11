// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//使用call方法调用其他合约，在不知道被调用合约的源代码，abi时适用，一般不推荐使用
contract CallCon {
    event Response(bool success, bytes data);

    //addr:当前合约的地址调用目标合约的方法
    function callTargetFun(address payable addr, uint256 amount)
        public
        payable
    {
        (bool success, bytes memory data) = addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", amount)
        );
    }

    function callTargetFun2(address addr) external returns (uint256) {
        (bool success, bytes memory data) = addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

    //调用目标合约不存在的函数时call函数也能成功，只是会调用目标合约的fallback函数
    function callTargetNotExitFun(address _addr) external {
        // call getX()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data); //释放事件
    }
}
