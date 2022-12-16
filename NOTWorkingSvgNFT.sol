// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol"; //NEW
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

error YouAlreadyHaveAnNFT();
error ThisAccountDoesNotExist();
error ThisTokenIdDoesNotExist();

contract MetaCareNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    // NEW
    string svgFirstPart =
        '<svg xmlns="SVG namespace" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-10.081 6.032-6.85 3.934-10.081 6.032c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616c-.384-.665-.594-1.418-.608-2.187v-9.31c-.013-.775.185-1.538.572-2.208a4.25 4.25 0 0 1 1.625-1.595l7.884-4.59c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v6.032l6.85-4.065v-6.032c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595L41.456 24.59c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595c-.387.67-.585 1.434-.572 2.208v17.441c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l10.081-5.901 6.85-4.065 10.081-5.901c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v9.311c.013.775-.185 1.538-.572 2.208a4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616c-.385-.665-.594-1.418-.608-2.187v-6.032l-6.85 4.065v6.032c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l14.864-8.655c.657-.394 1.204-.95 1.589-1.616s.594-1.418.609-2.187V55.538c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgLastPart = "</text></svg>";

    //User Data structure (created during minting, values will be updated automatically)
    struct userData {
        address userAddress;
        address doctorAddress;
        uint256 tokenId;
        uint256 heartRate;
    }

    //create one structure of data for each user (we can find it using the NFT tokenID)
    mapping(address => userData) userDataList;

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
            heartRateLevel = "Normal";
        } else {
            heartRateLevel = "High";
        }

        string memory finalSvg = string(
            abi.encodePacked(svgFirstPart, heartRateLevel, svgLastPart)
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": ',
                                heartRateLevel,
                                ' Heart Rate","description": "The patient resting heart rate is',
                                heartRateLevel,
                                '. This is not an official medical diagnosis and your heart rate should be monitored by a certified instrument. Please consult your doctor if you feel any chest pain.","attributes": [{ "trait-type": "Heart Rate","value": "',
                                heartRateLevel,
                                '"}], "image":"data:image/svg+xml;base64,',
                                Base64.encode(bytes(finalSvg)),
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

    /*//Define the Base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    */
}
