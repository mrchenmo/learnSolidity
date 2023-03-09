// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @dev 验证Merkle树的合约.
 *
 * proof可以用JavaScript库生成：
 * https://github.com/miguelmota/merkletreejs[merkletreejs].
 * 注意: hash用keccak256，并且开启pair sorting （排序）.
 * javascript例子见 `https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/test/utils/cryptography/MerkleProof.test.js`.
 */
library MerkleProof {
    /**
     * @dev 当通过`proof`和`leaf`重建出的`root`与给定的`root`相等时，返回`true`，数据有效。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns 通过Merkle树用`leaf`和`proof`计算出`root`. 当重建出的`root`和给定的`root`相同时，`proof`才是有效的。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function processProof(bytes32[] memory proof, bytes32 leaf)
        internal
        pure
        returns (bytes32)
    {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    // Sorted Pair Hash
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return
            a < b
                ? keccak256(abi.encodePacked(a, b))
                : keccak256(abi.encodePacked(b, a));
    }
}

//利用默克尔树发NFT，节省gas
contract TreeSendERC721 is ERC721 {
    //默克尔树的根哈希
    bytes32 public immutable root;
    mapping(address => bool) public mintedAddress; //给定一个地址，返回是否已经mint过了

    //在构造函数中初始化变量
    constructor(
        string memory name,
        string memory symbol,
        bytes32 mRoot
    ) ERC721(name, symbol) {
        root = mRoot;
    }

    //mint 函数，判断调用该方法的地址是否在默克尔树内，判断该地址是否已经mint过了
    function mint(
        address acount,
        uint256 tokenId,
        bytes32[] calldata proof
    ) external {
        //地址在白名单的默克尔树里面
        require(_verify(_leaf(acount), proof), "error--------MerkleProof");
        //地址没有mint过
        require(!mintedAddress[acount], "error only one");

        _mint(acount, tokenId);
        mintedAddress[acount] = true;
    }

    //根据账户计算该账户的哈希值，用于验证该账户是否属于该默克尔树
    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leafHash, bytes32[] memory proof)
        internal
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, root, leafHash);
    }
}
