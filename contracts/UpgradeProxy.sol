// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract UpgradeProxy {
    address public implementation; //逻辑合约的地址
    address public admin; //拥有者地址
    string public words;

    constructor(address implementation_) {
        admin = msg.sender;
        implementation = implementation_;
    }

    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(
            msg.data
        );
    }

    //升级逻辑合约的地址
    function Upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }
}
