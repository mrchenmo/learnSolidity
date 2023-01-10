// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";
//通过网址的方式引入
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
//通过 npm的形式引入
import "@openzeppelin/contracts/utils/Strings.sol";

error NotEnoughFunds(uint256 payMount, uint256 amount);

contract LearnError {
    address private chairperson;

    modifier _isOwner() {
        require(msg.sender == chairperson, "Caller is not owner");
        _;
    }

    constructor() {
        chairperson = msg.sender;
    }

    mapping(address => uint256) balances; //为何要使用mapping，以为要根据地址来获取余额，是两个不同的类型，需要使用mapping来转换

    // 默认为internal，表示为只能从合约内部访问，继承合约可以访问
    // 还有其他三种：
    //public 会自动生成getter函数，外部可以访问，部署到链上以后，会在ethscan上出现这个函数。
    //private 表示只能在合约内部使用，和internal的区别是继承合约也不可访问这个函数。
    //external 表示只能从合约外部访问，在本合约内可以通过this.f（）来访问。
    function pay(address reviceAdd, uint256 payAmount) public _isOwner {
        //获取当前地址的余额,msg.sender就是调用当前方法的地址
        uint256 balance = getBalance(msg.sender);
        console.log("current account:", chairperson.balance);
        console.log("current account:", balance < payAmount);
        console.log("current account:", payAmount);
        console.log("current account:", msg.sender.balance);
        if (chairperson.balance < payAmount)
            revert NotEnoughFunds(payAmount, balance);

        //校检成功则更新余额
        balances[msg.sender] -= payAmount;
        balances[reviceAdd] += payAmount;
    }

    //view 修饰只能读取，不能修改变量
    function getBalance(address add) public view returns (uint256) {
        return add.balance;
    }

    //针对这种不读取也不修改变量的方法，声明为pure比较好。之前学习过pure view 的区别
    function testArray() public pure returns (uint256[] memory, string memory) {
        uint256[] memory array = new uint256[](20);
        string memory array2 = new string(10);
        return (array, array2);
    }

    //命名式声明变量的写法
    function testArray2()
        public
        pure
        returns (uint256[] memory array1, string memory array2)
    {
        array1 = new uint256[](20);
        array2 = new string(10);
    }

    event LogInt(string, int256);

    function log(string memory s, int256 x) internal {
        emit LogInt(s, x);
    }

    bool public bo;
    string public str;
    int256 public i;
    uint256 public ui;
    address public adr;

    function getDefaultValue()
        public
        returns (
            bool,
            string memory,
            int256,
            uint256,
            address
        )
    {
        console.log("test default:", bo);
        console.log("test default:", str);
        emit LogInt("test default:", i);
        console.log("test default:", ui);
        console.log("test default:", adr);
        return (bo, str, i, ui, adr);
    }

    //冒泡排序算法
    function testIn(uint256[] memory num)
        public
        pure
        returns (uint256[] memory)
    {
        for (uint256 i = 0; i < num.length - 1; i++) {
            for (uint256 j = 0; j < num.length - 1 - i; j++) {
                if (num[j] > num[j + 1]) {
                    uint256 temp = num[j];
                    num[j] = num[j + 1];
                    num[j + 1] = temp;
                }
            }
        }
        return num;
    }

    //插入排序算法
    function testInsert(uint256[] memory array)
        public
        pure
        returns (uint256[] memory)
    {
        for (uint256 i = 1; i < array.length; i++) {
            //从后往前扫描，开始排序
            uint256 temp = array[i];
            uint256 j = i; //从i的下一个元素开始取和i进行比较,必须保证这里不能取到负数
            while (j >= 1 && array[j - 1] > temp) {
                array[j] = array[j - 1];
                j--;
            }
            array[j] = temp;
        }

        return array;
    }

    //使用库合约
    function testLibFuc(uint256 num) public pure returns (string memory) {
        return Strings.toHexString(num);
    }

    ///接收ETH的函数
    // 定义事件
    event Received(address Sender, uint256 Value);
    //event LogE(uint256 amount, unit gas);

    // 接收ETH时释放Received事件
    receive() external payable {
        emit Received(msg.sender, msg.value);
        //emit LogE(msg.value, gasLeft());
        console.log("received nun:", msg.value);
    }
}
