// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error NFT_NOT_EXIST();
error YOU_ALREADY_MINTED_NFT();
error ALL_NFTS_ARE_MINTED();

contract QuickNft is ERC721Enumerable, Ownable {
    uint256 public supplies = 500;
    uint256 public minted;
    string[] public cid = [
        "ipfs://QmQQEjRjhUQPgJ51U2PKkwyRLgktzGWmX95vgUzWfBj5gb",
        "ipfs://Qmch5VaqXCc5ZbwKuL2awac1vrBXBBPiB5h7WxtYKDZ7DS",
        "ipfs://QmQg5wf1KHLDA1pEg51wK44UqPa6wJztTxppgb92VyPEbR"
    ];

    constructor() ERC721("QuickNft", "QNN") {}

    /**
     * @notice function to put NFT to Opensea
     * @param _cidId ID of the metadata of NFT we want to mint
     * @dev tokenURI overrides the Openzeppelin's ERC721 implementation for tokenURI function
     * This function returns the URI from where we can extract the metadata for a given tokenId
     */
    function tokenURI(
        uint256 _cidId
    ) public view virtual override returns (string memory) {
        // require(_cidId <= supplies.length-1,"NFT does not exist");
        if (_cidId >= cid.length) revert NFT_NOT_EXIST();
        // return
        //     string(
        //         abi.encodePacked(
        //             "ipfs://QmSCFe5vvoPsSpyHZpGAW78GJ4bAuDcySCV9UnMm7B69iS/",
        //             Strings.toString(_cidId),
        //             ".json"
        //         )
        //     );
        return string(abi.encodePacked(cid[_cidId]));
    }

    /**
     * @notice function to mint the NFT
     * @param _cidId CID ID to select the metadata of your choice
     */
    function mint(uint256 _cidId) public {
        if (_cidId >= cid.length) revert NFT_NOT_EXIST();
        if (minted + 1 > supplies) revert ALL_NFTS_ARE_MINTED();
        _safeMint(msg.sender, minted);
        unchecked {
            ++minted;
        }
    }

    /**
     * @notice function to get total number of NFTs minted
     */
    function totalNftMinted() public view returns (uint256) {
        return minted;
    }
}
