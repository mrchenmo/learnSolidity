// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// ECDSA库
library ECDSA {
    /**
     * @dev 通过ECDSA，验证签名地址是否正确，如果正确则返回true
     * _msgHash为消息的hash
     * _signature为签名
     * _signer为签名地址
     */
    function verify(
        bytes32 _msgHash,
        bytes memory _signature,
        address _signer
    ) internal pure returns (bool) {
        return recoverSigner(_msgHash, _signature) == _signer;
    }

    // @dev 从_msgHash和签名_signature中恢复signer地址
    function recoverSigner(bytes32 _msgHash, bytes memory _signature)
        internal
        pure
        returns (address)
    {
        // 检查签名长度，65是标准r,s,v签名的长度
        require(_signature.length == 65, "invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        // 目前只能用assembly (内联汇编)来从签名中获得r,s,v的值
        assembly {
            /*
            前32 bytes存储签名的长度 (动态数组存储规则)
            add(sig, 32) = sig的指针 + 32
            等效为略过signature的前32 bytes
            mload(p) 载入从内存地址p起始的接下来32 bytes数据
            */
            // 读取长度数据后的32 bytes
            r := mload(add(_signature, 0x20))
            // 读取之后的32 bytes
            s := mload(add(_signature, 0x40))
            // 读取最后一个byte
            v := byte(0, mload(add(_signature, 0x60)))
        }
        // 使用ecrecover(全局函数)：利用 msgHash 和 r,s,v 恢复 signer 地址
        return ecrecover(_msgHash, v, r, s);
    }

    /**
     * @dev 返回 以太坊签名消息
     * `hash`：消息哈希
     * 遵从以太坊签名标准：https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * 以及`EIP191`:https://eips.ethereum.org/EIPS/eip-191`
     * 添加"\x19Ethereum Signed Message:\n32"字段，防止签名的是可执行交易。
     */
    function toEthSignedMessageHash(bytes32 hash)
        public
        pure
        returns (bytes32)
    {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }
}

contract SinSendNFT is ERC721 {
    address public immutable singer;
    //记录已经mint过的地址
    mapping(address => bool) mintedAddr;

    constructor(
        string memory name,
        string memory symbol,
        address sinnn
    ) ERC721(name, symbol) {
        singer = sinnn;
    }

    function mint(
        address to,
        uint256 tokenId,
        bytes memory sinHash
    ) external {
        bytes32 messageHash = getMessageHash(to, tokenId);
        //使用ECDSA库来计算以太坊签名消息
        bytes32 ecdsaHash = ECDSA.toEthSignedMessageHash(messageHash);
        require(verify(ecdsaHash, sinHash), "error-----verify");
        require(!mintedAddr[to], "error----------minted");
        _mint(to, tokenId);
        mintedAddr[to] = true;
    }

    //将地址和tokenid包装成消息
    function getMessageHash(address addr, uint256 tokenId)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(addr, tokenId));
    }

    // ECDSA验证，调用ECDSA库的verify()函数
    function verify(bytes32 ecdsaHash, bytes memory _signature)
        public
        view
        returns (bool)
    {
        return ECDSA.verify(ecdsaHash, _signature, singer);
    }
}
