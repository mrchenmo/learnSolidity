// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Feidian {
    uint256 private _x = 0;
    event LogInEvent(uint256 amount, uint256 gas);

    //这里就是恶意函数，导致发送到此合约的交易全部失败
    fallback() external payable {
        revert("hacker");
    }

    //获取当前地址的余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit LogInEvent(msg.value, gasleft());
        }
    }

    //被其他合约调用的合约
    function getX() external view returns (uint256 x) {
        x = _x;
    }
}
