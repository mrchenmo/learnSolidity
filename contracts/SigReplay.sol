// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

//签名重放例子，在使用签名确定用户可以mint多少代币或者NFT时，容易发生
//没有校检签名是否已经使用，导致同一个签名多次使用
contract SigReplay is ERC20 {
    address public signer;

    constructor(string _name, string _symbol) ERC20(_name, _symbol) {
        signer = msg.sender;
    }

    //使用签名校检当前调用者是否符合mint的条件
    function badMint(address to, uint256 amount, bytes32 memory sig) public {
        bytes32 _hash = createEthSigMess(createSing(to, amount));
        require(verifyFun(_hash, sig), "error---bad sig");
        _mint(to, amount);
    }

    //这是一个坏的例子，在这里构造要签名信息时没有添加nonce和chainID，会导致这个签名信息可以无限使用，和跨链重放
    //就是个公开的消息
    function createSing(
        address to,
        uint256 amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(to, amount));
    }

    //把得到的公开消息的哈希值用以太坊标准的签名格式签名，得到标准的个人签名
    //\x19Ethereum Signed Message:\n32可以用来防止交易，加了此字段，签名不能用于交易

    function createEthSigMess(
        bytes32 memory hash
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    function verifyFun(
        bytes32 _msgHash,
        bytes memory _signature
    ) public view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }
}
