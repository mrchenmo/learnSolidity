// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Test {
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

    function hashText(
        string memory word,
        uint256 num,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(word, num, _addr));
    }

    bytes32 public _msg = keccak256(abi.encodePacked("0xaa"));

    // 弱抗碰撞性
    function weak(string memory string1) public view returns (bool) {
        return keccak256(abi.encodePacked(string1)) == _msg;
    }

    event Log(bytes data);

    ///0x6a6278420000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78
    function mint(address to) external {
        emit Log(msg.data);
    }

    function checkMethodId() public pure returns (bytes4) {
        return bytes4(keccak256("mint(address)"));
    }

    function callwithSignature() external returns (bool, bytes memory) {
        (bool success, bytes memory data) = address(this).call(
            abi.encodeWithSelector(
                0x6a627842,
                0x2c44b726ADF1963cA47Af88B284C06f30380fC78
            )
        );
        return (success, data);
    }
}
