// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "./Base64.sol"; //NEW
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

error YouAlreadyHaveAnNFT();
error ThisAccountDoesNotExist();
error ThisTokenIdDoesNotExist();

contract MetaCareSVGNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    //User Data structure (created during minting, values will be updated automatically)
    struct userData {
        address userAddress;
        address doctorAddress;
        uint256 tokenId;
        uint256 heartRate;
    }

    //create one structure of data for each user (we can find it using the NFT tokenID)
    mapping(address => userData) userDataList;

    constructor() ERC721("MetaCare Health", "MC") {}

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

    function buildImage(
        string memory heartRateLevel
    ) public pure returns (string memory) {
        return
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
                        '<rect height="500" width="500" fill="#0d93a8"/>',
                        '<text font-weight="bold" text-anchor="middle" font-size="35" y="40%" x="50%" fill="#ffffff">Heart rate Status :</text>',
                        '<text text-anchor="middle" font-size="35" y="50%" x="50%" fill="#ffffff">',
                        heartRateLevel,
                        "</text>",
                        "</svg>"
                    )
                )
            );
    }

    //NEW
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

        //Return the Heart rate level in function of the current heartRate
        string memory heartRateLevel;
        if (currentHeartRate > 100) {
            heartRateLevel = "High";
        } else if (currentHeartRate < 60) {
            heartRateLevel = "Low";
        } else {
            heartRateLevel = "Normal";
        }

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                heartRateLevel,
                                " Heart Rate",
                                '", "description": "The patient resting heart rate is ',
                                heartRateLevel,
                                ". This is not an official medical diagnosis and your heart rate should be monitored by a certified instrument. Please consult your doctor if you feel any chest pain.",
                                '", "attributes": [{ "trait-type": "Heart Rate","value": "',
                                heartRateLevel,
                                '"}], "image": "',
                                "data:image/svg+xml;base64,",
                                buildImage(heartRateLevel),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    //TO DELETE IN THE REAL CODE / Just for testing purposes
    function _changeCurrentHeartRate(
        uint256 _newHeartRate,
        address userAddress
    ) public {
        userDataList[userAddress].heartRate = _newHeartRate;
    }
}
