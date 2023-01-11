// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PairCon {
    address factor;
    address token0;
    address token1;

    constructor() payable {
        factor = msg.sender;
    }

    function init(address _token0, address _token1) external {
        require(msg.sender == factor, "error of msg.sender!=factor");
        token0 = _token0;
        token1 = _token1;
    }
}
