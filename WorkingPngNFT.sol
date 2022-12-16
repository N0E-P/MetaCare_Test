// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

error YouAlreadyHaveAnNFT();
error ThisAccountDoesNotExist();
error ThisTokenIdDoesNotExist();

contract MetaCareNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    //URIs storing the metadata for each different NFT states
    string baseURI =
        "https://ipfs.io/ipfs/QmeLnoF5nMcMQ7dU4epuyF1cmMK1biF9yuTJ618qwtVxWF/baseURI.json";
    string lowURI =
        "https://ipfs.io/ipfs/QmeLnoF5nMcMQ7dU4epuyF1cmMK1biF9yuTJ618qwtVxWF/lowURI.json";
    string highURI =
        "https://ipfs.io/ipfs/QmeLnoF5nMcMQ7dU4epuyF1cmMK1biF9yuTJ618qwtVxWF/highURI.json";

    //User Data structure (created during minting, values will be updated automatically)
    struct userData {
        address userAddress;
        address doctorAddress;
        uint256 tokenId;
        uint256 heartRate;
    }

    //create one structure of data for each user (we can find it using the NFT tokenID)
    mapping(address => userData) userDataList;

    //Prepare the smart contract when its creation
    constructor() ERC721("MetaCare", "MC") {}

    //add yourself to the user list by minting an NFT
    function mint(address _doctorAddress) public {
        if (balanceOf(msg.sender) > 0) {
            revert YouAlreadyHaveAnNFT();
        }

        //Add the user in the struct and create the NFT
        uint256 tokenId = totalSupply() + 1;
        userDataList[msg.sender] = userData(
            msg.sender,
            _doctorAddress,
            tokenId,
            80
        );
        _safeMint(msg.sender, tokenId);
    }

    //Get the Metadata for each NFTs
    function tokenURI(
        uint256 _tokenId
    ) public view virtual override returns (string memory) {
        if (_exists(_tokenId) == false) {
            revert ThisTokenIdDoesNotExist();
        }

        address userAddress = ownerOf(_tokenId);
        if (userDataList[userAddress].userAddress != userAddress) {
            revert ThisAccountDoesNotExist();
        }

        //Get the heartRate of the owner of the tokenID
        uint256 currentHeartRate = userDataList[userAddress].heartRate;

        //Return the URI in function of the current heartRate
        if (currentHeartRate > 100) {
            return highURI;
        } else if (currentHeartRate < 60) {
            return lowURI;
        } else {
            return _baseURI();
        }
    }

    function _changeCurrentHeartRate(
        uint256 _newHeartRate,
        address userAddress
    ) public {
        userDataList[userAddress].heartRate = _newHeartRate;
    }

    //Define the Base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
