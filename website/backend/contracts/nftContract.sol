pragma solidity 0.5.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/docs-org/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-org/contracts/token/ERC721/ERC721Full.sol";

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/tree/docs-org/contracts/token/ERC721/ERC721.sol";

//contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
//    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
//        // solhint-disable-previous-line no-empty-blocks
//    }
//}

contract nftContract is ERC721Full {
    struct nftData {
        uint256 clothType; //--> 1 --> head, 2 --> middle, 3 --> bottom
        string name;
        string cid;
        string rarity;
        bool isOnSale;
        uint256 sellPrice;
        bool isBiddable;
        uint256 maxBid;
    }

    struct userData {
        //uint is reference to tokenId from openzeppelin-contracts
        uint256 head; //also the photo if do you have a head assigned
        //uint is reference to tokenId from openzeppelin-contracts
        uint256 middle;
        //uint is reference to tokenId from openzeppelin-contracts
        uint256 bottom;
        string username;

        //string photo; --> will be decided later
    }

    event nftTransaction(
        uint256 indexed id,
        string transactionType,
        address fromAddress,
        address toAddress,
        uint256 value

        //address txn
    );

    mapping(address => userData) public users;

    mapping(string => bool) isExist;

    nftData[] public nfts;

    //mapping(uint => nftData) public nfts; //uint is reference to tokenId from openzeppelin-contracts

    constructor() public ERC721Full("nftContract", "NFTC") {}

    function setUsername(string memory _username) public {
        users[msg.sender].username = _username;
    }

    function wearItems(
        uint256 _headTokenId,
        uint256 _middleTokenId,
        uint256 _bottomTokenId
    ) public {
        require(
            _headTokenId == 0 ||
                (this.ownerOf(_headTokenId) == msg.sender &&
                    nfts[_headTokenId - 1].clothType == 1)
        );
        require(
            _middleTokenId == 0 ||
                (this.ownerOf(_middleTokenId) == msg.sender &&
                    nfts[_middleTokenId - 1].clothType == 2)
        );
        require(
            _bottomTokenId == 0 ||
                (this.ownerOf(_bottomTokenId) == msg.sender &&
                    nfts[_bottomTokenId - 1].clothType == 3)
        );

        users[msg.sender].head = _headTokenId;
        users[msg.sender].middle = _middleTokenId;
        users[msg.sender].bottom = _bottomTokenId;
    }

    function wearItem(uint256 _tokenId) public {
        require(this.ownerOf(_tokenId) == msg.sender);

        if (nfts[_tokenId - 1].clothType == 1) {
            users[msg.sender].head = _tokenId;
        } else if (nfts[_tokenId - 1].clothType == 2) {
            users[msg.sender].middle = _tokenId;
        } else if (nfts[_tokenId - 1].clothType == 3) {
            users[msg.sender].bottom = _tokenId;
        }
    }

    function unWearItem(uint256 _clothType) public {
        require(_clothType == 1 || _clothType == 2 || _clothType == 3);

        if (_clothType == 1) {
            users[msg.sender].head = 0;
        } else if (_clothType == 2) {
            users[msg.sender].middle = 0;
        } else if (_clothType == 3) {
            users[msg.sender].bottom = 0;
        }
    }

    function tokensOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return _tokensOfOwner(_owner);
    }

    function mint(
        uint256 _clothType,
        string memory _name,
        string memory _cid,
        string memory _rarity
    ) public {
        require(isExist[_cid] == false);
        uint256 _id =
            nfts.push(
                nftData(_clothType, _name, _cid, _rarity, false, 0, false, 0)
            );
        _mint(msg.sender, _id);
        isExist[_cid] = true;

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
    }

    function bulkmint() public {
        uint256 _id =
            nfts.push(
                nftData(
                    1,
                    "head 1",
                    "https://dummyimage.com/600x400/f5c011/fff&text=h 1",
                    "rare",
                    true,
                    20,
                    false,
                    0
                )
            );
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);

        emit nftTransaction(
            _id,
            "claimed",
            address(0x0),
            address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2),
            0
        );

        _id = nfts.push(
            nftData(
                1,
                "head 2",
                "https://dummyimage.com/600x400/1e00ff/fff&text=h 2",
                "common",
                false,
                0,
                true,
                5
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                1,
                "head 3",
                "https://dummyimage.com/600x400/f5c011/fff&text=h 3",
                "rare",
                true,
                50,
                true,
                10
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                1,
                "head 4",
                "https://dummyimage.com/600x400/1e00ff/fff&text=h 4",
                "common",
                false,
                0,
                false,
                0
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                1,
                "head 5",
                "https://dummyimage.com/600x400/00ff84/000&text=h 5",
                "legendary",
                false,
                0,
                false,
                0
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        /*
            _id = nfts.push(nftData(1, "head 6", "https://dummyimage.com/600x400/c400ff/fff&text=h 6", "epic", true, 505, false, 0));
        _mint(msg.sender, _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        
            _id = nfts.push(nftData(1, "head 7", "https://dummyimage.com/600x400/f5c011/fff&text=h 7", "rare", false, 0, false, 0));
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), 0);
        
            _id = nfts.push(nftData(1, "head 8", "https://dummyimage.com/600x400/1e00ff/fff&text=h 8", "common", false, 0, false, 0));
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), 0);
        
        _id = nfts.push(nftData(1, "head 9", "https://dummyimage.com/600x400/c400ff/fff&text=h 9", "epic", false, 0, false, 0));
        _mint(msg.sender, _id);
        
        */

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                2,
                "middle 1",
                "https://dummyimage.com/600x400/1e00ff/fff&text=m 1",
                "common",
                false,
                0,
                false,
                0
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                2,
                "middle 2",
                "https://dummyimage.com/600x400/f5c011/fff&text=m 2",
                "rare",
                true,
                40,
                false,
                0
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                2,
                "middle 3",
                "https://dummyimage.com/600x400/1e00ff/fff&text=m 3",
                "common",
                false,
                0,
                true,
                50
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        /*
        _id = nfts.push(nftData(2, "middle 4", "https://dummyimage.com/600x400/c400ff/fff&text=m 4", "epic", false, 0, false, 0));
        _mint(msg.sender, _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        
        _id = nfts.push(nftData(2, "middle 5", "https://dummyimage.com/600x400/f5c011/fff&text=m 5", "rare", false, 0, false, 0));
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), 0);
        
        _id = nfts.push(nftData(2, "middle 6", "https://dummyimage.com/600x400/1e00ff/fff&text=m 6", "common", true, 30, true, 20));
        _mint(msg.sender, _id);
        */

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                3,
                "bottom 1",
                "https://dummyimage.com/600x400/1e00ff/fff&text=b 1",
                "common",
                false,
                0,
                false,
                0
            )
        );
        _mint(msg.sender, _id);

        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);

        _id = nfts.push(
            nftData(
                3,
                "bottom 2",
                "https://dummyimage.com/600x400/f5c011/fff&text=b 2",
                "rare",
                true,
                70,
                false,
                0
            )
        );
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);

        emit nftTransaction(
            _id,
            "claimed",
            address(0x0),
            address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2),
            0
        );
        /*
        _id = nfts.push(nftData(3, "bottom 3", "https://dummyimage.com/600x400/f5c011/fff&text=b 3", "rare", false, 0, false, 0));
        _mint(msg.sender, _id);
        
       
        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        
        _id = nfts.push(nftData(3, "bottom 4", "https://dummyimage.com/600x400/f5c011/fff&text=b 4", "epic", false, 0, false, 0));
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), 0);
        
        _id = nfts.push(nftData(3, "bottom 5", "https://dummyimage.com/600x400/00ff84/000&text=b 5", "legendary", true, 999, false, 0));
        _mint(msg.sender, _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        
        _id = nfts.push(nftData(3, "bottom 6", "https://dummyimage.com/600x400/1e00ff/fff&text=b 6", "common", false, 0, true, 2));
        _mint(msg.sender, _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), msg.sender, 0);
        
        _id = nfts.push(nftData(3, "bottom 7", "https://dummyimage.com/600x400/f5c011/fff&text=b 7", "rare", false, 0, false, 0));
        _mint(address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), _id);
        
        
        emit nftTransaction(_id, "claimed", address(0x0), address(0x7556820cE8b55436AE61CffB7FA93ae8DC8C99f2), 0);
        */
    }
}
