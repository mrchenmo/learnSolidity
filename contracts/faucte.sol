// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;
import "./IERC20.sol";

contract Faucte {
    //indexed方便过滤日志
    event SendToken(address indexed to, uint256 indexed amount);
    //记录已经领取过的地址
    mapping(address => bool) private alreadyRequest;
    //每次能领取的数量
    uint256 private allowAmount = 100;
    //发代币的合约，由外部传进来，水龙头合约肯定是独立于代币合约的，在构造方法中传入
    address tokenCon;

    constructor(address _tokenAddress) {
        tokenCon = _tokenAddress;
    }

    function requestToken() external {
        require(alreadyRequest[msg.sender] == false, "errrrrrrrr one");
        IERC20 token = IERC20(tokenCon);
        require(token.balanceOf(address(this)) >= allowAmount, "error empty");
        token.transfer(msg.sender, allowAmount);
        alreadyRequest[msg.sender] = true;
        emit SendToken(msg.sender, allowAmount);
    }
}
