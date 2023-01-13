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

    //区别在于要比create多传一个参数，预先计算好将要部署的地址，不论以后区块链怎么变，合约都会部署在计算好的合约上
    function create2Pair(address tokenA, address tokenB)
        external
        returns (address pairAdd)
    {
        require(tokenA != tokenB, "error");
        (address t0, address t1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        //create2 就是加了盐
        bytes32 salt = keccak256(abi.encodePacked(t0, t1));
        //使用create2的方式创建合约
        PairCon pair2 = new PairCon{salt: salt}();
        pair2.init(tokenA, tokenB);
        // 更新地址map,不更新地址，就返回的是0x000000这个地址
        pairAdd = address(pair2);
        allPair.push(pairAdd);
        getPair[tokenA][tokenB] = pairAdd;
        getPair[tokenB][tokenA] = pairAdd;
    }

    // 提前计算pair合约地址,用于验证使用create2创建的合约和此地址是否一样
    function calculateAddr(address tokenA, address tokenB)
        public
        view
        returns (address predictedAddress)
    {
        require(tokenA != tokenB, "IDENTICAL_ADDRESSES"); //避免tokenA和tokenB相同产生的冲突
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // 计算合约地址方法 hash()
        predictedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(type(PairCon).creationCode)
                        )
                    )
                )
            )
        );
    }
}
