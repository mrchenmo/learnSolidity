// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./IERC20.sol";

contract MyERC20Con is IERC20 {
    //作用是要获取某个地址的余额，地址为key，根据key获取的结果为uint256
    mapping(address => uint256) public override balanceOf;

    //mapping的key只能是基础类型，value的类型可以是允许的类型，所以这里的value可以是另外一个mapping
    //这个mapping的意思就是一个allowance[address]取出来的结果还是个mapping
    //mapping a=allowance[address]; unit256 res=s[addressB];
    mapping(address => mapping(address => uint256)) public override allowance;

    string public name;
    string public symbol;
    uint256 public override totalSupply;
    uint8 public decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function transfer(address to, uint256 amount)
        external
        override
        returns (bool)
    {
        require(to != address(0), "000000000");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        //发送者授权amount个代币的权限用于转账
        allowance[from][msg.sender] -= amount;
        //将发送者的代币数量减少amount个
        balanceOf[from] -= amount;
        //接收者的代币数量增加amount个
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}
