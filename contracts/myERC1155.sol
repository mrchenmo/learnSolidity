// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyERC1155 is ERC1155 {
    using Strings for uint256; // 使用String库
    //最大供应量
    uint256 constant MAX_SUP = 10000;

    constructor()
        ERC1155("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/")
    {}

    function mint(
        address _to,
        uint256 _id,
        uint256 _count
    ) external {
        require(_id < MAX_SUP, "error-----id need <10000");
        _setURI(generateUri(_id));
        _mint(_to, _id, _count, "");
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _counts
    ) external {
        for (uint256 i = 0; i < _ids.length; i++) {
            require(_ids[i] < MAX_SUP, "id overflow");
              _setURI(generateUri(i));
        }
        _mintBatch(_to, _ids, _counts, "");
    }

    function generateUri(uint256 id)
        public
        view
        virtual
        returns (string memory)
    {
        string
            memory baseURI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, id.toString()))
                : "";
    }
}
