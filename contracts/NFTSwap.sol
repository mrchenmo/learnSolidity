// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./myERC721.sol";

//实现IERC721Receiver才能实现将NFT发送到合约的功能
contract NFTSwap is IERC721Receiver {
    //列出NFT
    event List(
        address indexed seller,
        address indexed nftaddr,
        uint256 indexed tokenId,
        uint256 price
    );

    //购买
    event buy(
        address indexed buyer,
        address indexed nftaddr,
        uint256 indexed tokenid,
        uint256 price
    );

    event removeList(
        address indexed seller,
        address indexed nftaddr,
        uint256 tokenid
    );

    event update(
        address indexed seller,
        address indexed nftaddr,
        uint256 indexed tokenId,
        uint256 newPrice
    );
    //订单类，记录该nft拥有者的地址和列出的价格
    struct Order {
        address owner;
        uint256 price;
    }

    //这里需要两层映射，因为拥有者持有的是众多NFT中的一个系列，又是该系列中的某一个或者某几个tokenId;
    //所以要先找到拥有的NFT系列的地址，然后找到拥有的是这个系列的NFT中的具体的哪一个，挂单也是挂的具体的某一个
    //owner可能拥有这个系列的多个NFT，那么挂单多个NFT就会形成一个列表，根据tokenId找到该tokenId的挂单信息
    mapping(address => mapping(uint256 => Order)) public ownerNftList;

    //若要使用ETH支付，需要实现payable函数
    fallback() external payable {}

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    //需要该NFT的持有人授权将此NFT转移到合约地址，由NFTSwap合约控制，就像opensea一样
    //还需要检查frome和to都不能是0地址
    function listNft(address nftaddr, uint256 tokenId, uint256 price) public {
        IERC721 _nft = IERC721(nftaddr);
        //检查owner持有的此NFT是否批准权限给swap合约地址
        require(
            _nft.getApproved(tokenId) == address(this),
            "error----need approve"
        );
        require(price > 0, "error----need >0");

        Order storage _order = ownerNftList[nftaddr][tokenId];
        _order.owner = msg.sender;
        _order.price = price;
        //调用IERC721的方法将授权的nft转到合约，用于匹配交易
        _nft.safeTransferFrom(msg.sender, address(this), tokenId);
        emit List(msg.sender, nftaddr, tokenId, price);
    }

    function purchase(address _nftAddr, uint256 _tokenId) public payable {
        //映射的作用来了，购买的时候需要知道卖家列出上架信息，交易成功之后合约需要知道把钱打给谁
        //在order里面的owner的地址，我购买的时候需要付多少钱
        Order storage order = ownerNftList[_nftAddr][_tokenId];
        require(order.price > 0, "error----need >0");
        require(msg.value > order.price, "amount need > price"); //购买者的钱包余额需要>出价
        //开始互转，合约将NFT转给买家，将ETH转给卖家
        IERC721 _nft = IERC721(nftaddr);
        require(
            _nft.ownerOf(_tokenId) == address(this),
            "error---Invalid Order"
        ); //swap合约是否拥有此tokenId的NFT
        //转移给买家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);

        //收款，owner地址收款
        payable(_order.owner).transfer(order.price);
        //多余的退款
        payable(msg.sender).transfer(msg.value - order.price);

        delete ownerNftList[_nftAddr][_tokenId];

        emit buy(msg.sender, _nftAddr, _tokenId, msg.value);
    }

    function revokeList(address _nftAddr, uint256 _removeId) public {
        //根据id获取要取消的nft的Order
        Order storage cancelOrder = ownerNftList[_nftAddr][_removeId];
        //检查发起取消上架的钱包地址是不是这个nft的拥有者
        require(cancelOrder.owner == msg.sender, "error----must owner");
        //开始取消，也就是将合约控制的该NFT转回到owner的地址
        IERC721 _revokeNFT = IERC721(_nftAddr);
        require(
            _revokeNFT.ownerOf(_tokenId) == address(this),
            "error---swap not own this nft"
        );

        _revokeNFT.safeTransferFrom(address(this), msg.sender, _removeId);
        delete ownerNftList[_nftAddr][_removeId];
        emit removeList(msg.sender, _nftAddr, _removeId);
    }

    function updateListPrice(
        address _nftAddr,
        uint256 updateId,
        uint256 newPrice
    ) public {
        require(newPrice > 0, "must >0");
        Order storage updateOrder = ownerNftList[_nftAddr][updateId];
        require(updateOrder.owner == msg.sender, "error---must owner");
        IERC721 _updateNFT = IERC721(_nftAddr);
        require(
            _updateNFT.ownerOf(updateId) == address(this),
            "error---swap not own this nft"
        );
        updateOrder.price = newPrice;
        emit update(msg.sender, _nftAddr, updateId, newPrice);
    }
}
