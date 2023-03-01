// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/AmazingAng/WTFSolidity/blob/main/34_ERC721/ERC721.sol";

contract DucthAution is Ownable, ERC721 {
    uint256 public constant MAX_SUP = 100000;

    //拍卖开始的价格
    uint256 public constant AUCTION_START_PRICE = 0.1 ether;
    //开始结束的价格
    uint256 public constant AUCTION_END_PRICE = 0.015 ether;
    //拍卖持续时间
    uint256 public constant AUCTION_PRICE_CURVE_LENGTH = 34 minutes;
    //每隔多长时间价格下降一次
    uint256 public constant AUCTION_DROP_INTERVAL = 2 minutes;
    //每个时间间隔降价多少，每20分钟降价一次，降了17次=340分钟结束拍卖，价格降到0.15E
    uint256 public constant AUCTION_DROP_PER_STEP =
        (AUCTION_START_PRICE - AUCTION_END_PRICE) /
            (AUCTION_PRICE_CURVE_LENGTH / AUCTION_DROP_INTERVAL);

    uint256 public startActionTime; //拍卖开始的时间
    string private _baseTokenURI; // metadata URI
    uint256[] private _allTokens; // 记录所有存在的tokenId

    constructor() ERC721("WTF Dutch Auctoin", "WTF Dutch Auctoin") {
        startActionTime = block.timestamp;
    }

    function autionStartMint() {
        //使用local变量，减少gas使用,下面的判断都要使用到开始时间，如果从全局变量里面读取会浪费gas，转换成local变量，达成节省gas的作用
        uint256 _startAutionTime = uint256(startActionTime);
        require(
            _startAutionTime != 0 && block.timestamp >= _startAutionTime,
            "error------ not start"
        );
        require(totalSupply() + quantity <= MAX_SUP, "error------ overflow");
        //Azuki的合约限制了单个地址能mint的最大数量
        uint256 totalCoast = getAutionFee(_startAutionTime) * quantity; //获取当前的拍卖价格乘以数量得到总的花费
        require(msg.value >= totalCost, "Need to send more ETH."); // 检查用户是否支付足够ETH

        for (uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }
        // 多余ETH退款
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost); //注意一下这里是否有重入的风险
        }
    }

    //计算用户mint所花费的钱数，查看用户的ETH是否狗支付
    //安全起见要二次校检当前荷兰拍的价格，防止用户支付时正好是降价的时间
    //计算当前荷兰拍的价格
    function getAutionFee(uint256 _startSaleTime)
        public
        view
        returns (uint256)
    {
        //拍卖未开始，或者刚开始
        if (block.timestamp < _startSaleTime) {
            return AUCTION_START_PRICE;
        }
        //区块时间和当前付款时间之间的差额大于拍卖的总时间表示拍卖结束了
        if (block.timestamp - _startSaleTime > AUCTION_PRICE_CURVE_LENGTH) {
            return AUCTION_END_PRICE;
        } else {
            //计算当前mint时间(取的是区块时间)距离开拍时间已经过去了多长时间，除以时间间隔，得到过去了多少时间间隔
            uint256 step = (block.timestamp - _startSaleTime) /
                AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (step * AUCTION_DROP_PER_STEP); //初始价格减去已经下降的价格=当前拍卖的价格
        }
    }

    //继承自onlyOwner确保只能合约拥有者才能设置开始时间
    function setSaleStartTime(uint32 time) external onlyOwner {
        startActionTime = time;
    }

    //将资金从合约提取到合约拥有者的账户，通过call方法发送ETH
    //call方法，目标地址.call,就是将消息发送到目标地址上
    function withdrawMoney() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
