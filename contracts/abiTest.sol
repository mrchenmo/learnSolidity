// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AbiTest {

    unit x=1312;
    address add=0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name="cwpp";
    unit[2] array=[6,9];

    fuction encode() public view returns (bytes memroy result){
        result =abi.encode(x,add,name,array);
    }
}