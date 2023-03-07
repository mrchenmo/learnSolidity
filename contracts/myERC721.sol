// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyErc721Nft is ERC721 {
    uint256 public MAX_SUP = 1000;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function baseURI() internal pure returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function safeMint(address to, uint256 tokenId) external {
        require(tokenId > 0 && tokenId < MAX_SUP, "error---------eeeeee");
        _safeMint(to, tokenId);
    }
}
