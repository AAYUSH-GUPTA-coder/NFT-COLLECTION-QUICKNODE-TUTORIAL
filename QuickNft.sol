// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error NFT_NOT_EXIST();
error YOU_ALREADY_MINTED_NFT();
error ALL_NFTS_ARE_MINTED();

contract QuickNft is ERC721Enumerable, Ownable {
    uint256[] public supplies = [500, 500, 500];
    uint256[] public minted = [0, 0, 0];
    string[] public cid = [
        "ipfs://Qmdr1zPumimEFKRkszo3nfFhGQ3UwofQXMbfDy1wd1gdLQ",
        "ipfs://QmTUZxtkAM5rMRHbmZKQLqGSYPG5SVyENk163x8Xb247vJ",
        "ipfs://QmeQp3LBdUj9nWrWiikmNwQ5NPjuuKxTHAsUrWZfKeRTF5"
    ];
    mapping(uint256 => mapping(address => bool)) public member;

    constructor() ERC721("QuickNft", "QNN") {}

    // to Put NFT to Opensea
    /**
     * @notice function to put NFT to Opensea
     * @param _tokenId 
     */
    function uri(uint256 _tokenId) public view returns (string memory) {
        // require(_tokenId <= supplies.length-1,"NFT does not exist");
        if (_tokenId >= supplies.length) revert NFT_NOT_EXIST();
        // return
        //     string(
        //         abi.encodePacked(
        //             "ipfs://QmSCFe5vvoPsSpyHZpGAW78GJ4bAuDcySCV9UnMm7B69iS/",
        //             Strings.toString(_tokenId),
        //             ".json"
        //         )
        //     );
        return string(abi.encodePacked(cid[_tokenId]));
    }

    function mint(uint256 _tokenId) public {
        // require(
        //     !member[_tokenId][msg.sender],
        //     "You have already claimed this NFT."
        // );
        if (member[_tokenId][msg.sender]) revert YOU_ALREADY_MINTED_NFT();
        // require(_tokenId <= supplies.length - 1, "NFT does not exist");
        if (_tokenId >= supplies.length) revert NFT_NOT_EXIST();
        uint256 index = _tokenId;

        // require(
        //     minted[index] + 1 <= supplies[index],
        //     "All the NFT have been minted"
        // );
        if (minted[index] + 1 > supplies[index]) revert ALL_NFTS_ARE_MINTED();
        _mint(msg.sender, _tokenId);
        minted[index] += 1;
        member[_tokenId][msg.sender] = true;
    }

    function totalNftMinted(uint256 _tokenId) public view returns (uint256) {
        return minted[_tokenId];
    }
}
