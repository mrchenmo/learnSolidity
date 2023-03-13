// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//由openzeplin的代理合约简化的代理合约
contract Proxy {
    address public implementation; //存储逻辑合约的地址，当部署了新的逻辑合约时可以使用set方法存储新的逻辑合约地址;
    uint256 public xx = 99;

    constructor(address _imple) {
        implementation = _imple;
    }

    function _delegate(address implementation_) internal {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(
                gas(),
                implementation_,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    fallback() external payable {
        _delegate(implementation);
    }

    receive() external payable {
        _delegate(implementation);
    }
}
