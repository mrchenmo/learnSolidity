// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./pairCon.sol";

//相当于是存储合约
contract PairFactor {
    //mapping的写法还是不太熟悉
    mapping(address => mapping(address => address)) public getPair;
    address[] allPair;

    ///使用两个token的地址创建交易对，将交易对的地址返回,使用create创建合约
    function createPair(address _tokenA, address token_B)
        external
        returns (address pairAddr)
    {
        //创建新合约
        PairCon pair = new PairCon();
        //调用初始化方法
        pair.init(_tokenA, token_B);
        //更新地址map，此方法不是太懂
        pairAddr = address(pair);
        //将新生成的交易对地址存入数组中保存
        allPair.push(pairAddr);
        getPair[_tokenA][token_B] = pairAddr;
        getPair[_tokenA][token_B] = pairAddr;
    }

    //区别在于要比create多传一个参数
    function create2Pair(address tokenA, address tokenB)
        external
        returns (address pairAdd)
    {
        require(tokenA != tokenB, "error");

        
    }
}
