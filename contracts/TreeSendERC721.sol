// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC721";

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
        pure
        returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
    }
}
