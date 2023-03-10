// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenLinerUnlock {
    //受益人提币
    event ERC20Withdraw(address indexed to, uint256 amount);

    address public immutable beneficiaryAddr;
    uint256 public immutable unlockStartTime;
    uint256 public immutable duration;
    mapping(address => uint256) public erc20Released; //记录已经归属的地址和数量

    constructor(
        address beneficiary, //受益人地址
        uint256 durationSec //归属期
    ) {
        require(beneficiary != address(0), "error----not 0x00");
        beneficiaryAddr = beneficiary;
        duration = durationSec;
        unlockStartTime = block.timestamp; //开始归属的时间以合约部署的区块时间，可以是任何时间，可能有的需求，需要设置一个时间
    }

    //合约部署完成以后需要供别人调用使用public修饰
    function unlock(address tokenAddr) public {
        uint256 unlockNum = needUnlockNum(tokenAddr, uint256(block.timestamp)) -
            erc20Released[tokenAddr];
        erc20Released[tokenAddr] += unlockNum;

        emit ERC20Withdraw(tokenAddr, unlockNum);
        IERC20(tokenAddr).transfer(beneficiaryAddr, unlockNum);
    }

    //查询某个地址中某个ERC20的数量，需要使用ERC20或者IERC20将代币地址包装成可以使用的ERC20类
    function needUnlockNum(
        address token,
        uint256 time
    ) public view returns (uint256) {
        //计算合约中代币的余额+已归属的代币数量
        uint256 allTokenInCon = IERC20(token).balanceOf(address(this)) +
            erc20Released[token];
        //归属还没开始
        if (time < unlockStartTime) {
            return 0;
        } else if (time > unlockStartTime + duration) {
            return allTokenInCon;
        } else {
            return allTokenInCon * ((time - unlockStartTime) / duration);
        }
    }
}
