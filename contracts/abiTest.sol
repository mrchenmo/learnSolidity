// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AbiTest {
    uint256 x = 123;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "cwpp";
    uint256[2] array = [6, 9];

    function encode() public view returns (bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }

    function encode2() public view returns (bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }

    function encode3() public view returns (bytes memory result) {
        result = abi.encodeWithSignature(
            "foo(unit256,address,string,unit256[])",
            x,
            addr,
            name,
            array
        );
    }

    function encode4() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(
            bytes4(keccak256("foo(unit256,address,string,unit256[])")),
            x,
            addr,
            name,
            array
        );
    }

    function decode1(bytes memory data)
        public
        pure
        returns (
            uint256 dx,
            address daddr,
            string memory dname,
            uint256[2] memory darray
        )
    {
        (dx, daddr, dname, darray) = abi.decode(
            data,
            (uint256, address, string, uint256[2])
        );
    }
}
