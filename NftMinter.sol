// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract NftProcess  {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    address private _owner;

    struct Nft {
        string name;
        uint data;
    }

    Nft[] public nfts;

    mapping (uint => address) public nftToOwner;
    mapping (address => uint) ownerNftCount;
    mapping (address => uint) amount;

    constructor()  {
        _owner = msg.sender;
    }

    function _createData(string memory _name, uint256 _data) private {
        nfts.push(Nft(_name, _data)) ;
        nftToOwner[nfts.length-1] = msg.sender;
    }

    function _generateRandomData(string memory _str) private view returns (uint) {
        uint256 rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;

        /*uint randNonce = 0;
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 100;
        randNonce++;
        uint random2 = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 100; */
    }

    function upload(string memory _name) public {
        uint256 data = _generateRandomData(_name);
        _createData(_name, data);
    }

    function mint(uint _userId) external payable onlyOwner(msg.sender, _userId){
        require(msg.value > 0);
    }
    
    modifier onlyOwner(address  _address, uint _userId)   {
        // nftnin owner =? mint ownera
        require(nftToOwner[_userId] == _address);
        _;
    }


    function balanceOf(address  _owner) external view returns (uint256) {
        return ownerNftCount[_owner];
    } 

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return nftToOwner[_tokenId];
    }

}

