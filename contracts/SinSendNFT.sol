// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SinSendNFT is ERC721 {
    address public immutable singer;
    //记录已经mint过的地址
    mapping(address => bool) mintedAddr;

    constructor(
        string memory name,
        string memory symbol,
        bytes32 sin
    ) ERC721(name, symbol) {
        singer = sin;
    }

    function mint(
        address to,
        uint256 tokenId,
        bytes sinHash
    ) external {
        bytes32 messageHash = getMessageHash(to, tokenId);
        //使用ECDSA库来计算以太坊签名消息
        bytes32 ecdsaHash = ECDSA.toEthSignedMessageHash(_msgHash);
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
        return ECDSA.verify(ecdsaHash, _signature, signer);
    }
}
