// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;
import "./IERC20.sol";

contract Airdrop is IERC20 {
    function sendERC20Airdrop(
        //需要空投的代币地址
        address _dropTokenAdd,
        //接收空投的地址
        address[] calldata _toAdd,
        //每个地址接收的代币数量
        uint256[] calldata _toAmount
    ) external {
        require(_toAdd.length == _toAmount.length, "error--------------");
        IERC20 token = IERC20(_dropTokenAdd);
        //计算一共要空投的代币总量，为了向代币合约索要授权，代币合约一共需要授权airdrop合约使用的代币数量
        uint256 amount = getSum(_toAmount);
        require(
            token.allowance(msg.sender, address(this)) >= amount,
            "error----amount"
        );
        //这里使用msg.sender作为from是因为token和owner和这个空投合约的owner是同一个
        //owner将空投的代币授权给了空投合约，空投合约向其他地址发送空投
        //首先也是要授权，这里代码没有体现，在部署erc20时可以手动approve，具体实现要看要求，记住原理
        for (uint8 i = 0; i < _toAdd.length; i++) {
            token.transferFrom(msg.sender, _toAdd[i], _toAmount[i]);
        }
    }

    function getSum(uint256[] calldata _arr) public pure returns (uint256 sum) {
        for (uint256 i = 0; i < _arr.length; i++) {
            sum = sum + _arr[i];
        }
    }
}
