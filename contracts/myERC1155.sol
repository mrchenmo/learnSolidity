// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyERC1155 is ERC1155 {
    //最大供应量
    uint256 constant MAX_SUP = 10000;

    constructor() ERC1155("bayc1155", "bayc1155") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address _to, uint256 _id, uint256 _count) external {
        require(id < MAX_SUP, "error-----id need <10000");
        _mint(_to, _id, _count, "");
    }

    function mintBatch(
        address _to,
        uint256[] _ids,
        uint256[] _counts
    ) external {
        for (uint256 i = 0; i < ids.length; i++) {
            require(ids[i] < MAX_ID, "id overflow");
        }
        _mintBatch(to, ids, amounts, "");
    }
}
