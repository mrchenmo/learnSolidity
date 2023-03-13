// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NewWETH is ERC20 {
    // 事件：存款和取款
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    constructor() ERC20("Wrapped Ether", "WETH") {}

    //用户存入ETH会触发存款方法
    fallback() external payable {
        deposit();
    }

    // 回调函数，当用户往WETH合约转ETH时，会触发deposit()函数
    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
        //把提取的ETH数量发送到msg.sender的地址中
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }
}
