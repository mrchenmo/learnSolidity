// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

//签名重放例子，在使用签名确定用户可以mint多少代币或者NFT时，容易发生
//没有校检签名是否已经使用，导致同一个签名多次使用
contract SigReplay is ERC20 {
    address public signer;
    mapping(address => bool) public minted; //记录此地址是否已经mint
    uint256 public nonce;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        signer = msg.sender;
    }

    //使用签名校检当前调用者是否符合mint的条件
    function badMint(
        address to,
        uint256 amount,
        bytes memory sig
    ) public {
        bytes32 _hash = createEthSigMess(createSing(to, amount));
        require(verifyFun(_hash, sig), "error---bad sig");
        require(!minted[msg.sender], "error---minted");
        minted[msg.sender] = true;
        _mint(to, amount);
        nonce++;
    }

    //这是一个坏的例子，在这里构造要签名信息时没有添加nonce和chainID，会导致这个签名信息可以无限使用，和跨链重放
    //就是个公开的消息
    //得到消息需要使用私钥创建消息的签名，将此签名广播出去，给其他人验证。
    //为了避免签名重放和跨链签名重放，构造消息时添加nonce和chainId
    function createSing(address to, uint256 amount)
        public
        view
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(to, amount, nonce, block.chainid));
    }

    //把得到的公开消息的哈希值加上特殊字段再次进行哈希，防止此消息被用于恶意目的。
    //\x19Ethereum Signed Message:\n32可以用来防止交易，加了此字段，签名不能用于交易
    //这一步是为了防止消息被用于执行恶意交易，EIP中规定用特殊字段再次进行哈希，又得到一种消息，此消息不能被用于执行交易

    //必须使用原始的消息，使用私钥对其创建签名，代码里使用这个方法是因为，当我们使用钱包进行签名时，钱包会自动调用此方法对原始
    //消息再次进行哈希。正常使用小狐狸钱包进行签名时，和我们在代码里执行的步骤一样，先生成原始消息的哈希，在对此哈希再次哈希，然后再使用私钥对其签名。
    // 我们在这里要对签名进行验证，所以，要保证代码里生成的消息签名和使用钱包签署的消息签名一样，所以在使用钱包签署是使用原始的消息哈希，钱包帮我们做了再次哈希。

    function createEthSigMess(bytes32 hash) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    //这个验证需要用私钥对获得的公开消息的哈希值进行签名，然后才能使用
    //_signature这个字段是使用账户的私钥对消息进行签名，才能表示这个是账户拥有者发送的这个消息，然后才能通过
    //ECDSA.recover方法通过公开的消息（_msgHash）和私钥创建的该消息的签名（_signature）还原出签名的公钥。
    function verifyFun(bytes32 _msgHash, bytes memory _signature)
        public
        view
        returns (bool)
    {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }
}
