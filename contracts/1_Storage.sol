// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {
    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }

    string tips;

    function storeStr(string memory value) public {
        tips = value;
    }

    //view 修饰就是纯净的get方法只能用来读取某个值并返回，不能修改变量的值。
    //returns 表示这个函数要返回 string memory类型的值，可以返回多个类型的值
    //return 就是返回具体的值，和其他语言一样。
    function showStoreStr() public view returns (string memory) {
        return tips;
    }
}
