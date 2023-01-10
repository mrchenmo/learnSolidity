pragma solidity >=0.7.0 <0.9.0;

contract MapTest {
    mapping(address => uint256) id;
    mapping(uint256 => string) accountName;

    uint256 public sum = 0;

    function regis(string memory name) public {
        address account=msg.sender;
        sum++;
        id[account]=sum;
        accountName[sum]=name;
    }

    function getIdByAccountAddress(address add)view public returns (uint){
        return id[add];
    }

    function getNameById(uint id)view public returns(string memory){
        return accountName[id];
    }
}
