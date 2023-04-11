// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BadRandom is ERC721 {
    uint256 public totalSup;

    constructor() ERC721("", "") {}

    function badMint(uint256 inputNum) external {
        uint256 luckNum = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        ) % 100;

        require(inputNum == luckNum, "error-must equal");

        _mint(msg.sender, totalSup);
        totalSup++;
    }
}
