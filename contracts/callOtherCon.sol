// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./feidian.sol";

contract CallOtherCon {
    //feidianAddr表示被调用合约部署的地址
    function callSetX(address payable feidianAddr, uint256 num) external {
        Feidian(feidianAddr).setX(num);
    }

    function callGetX(Feidian _addr) external view returns (uint256 x) {
        x = _addr.getX();
    }

    function setXTranETH(address payable feidianAddr, uint256 amount) external payable {
        Feidian(feidianAddr).setX{value: msg.value}(amount);
    }
}
