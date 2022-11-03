// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* This is just an example contract to have an idea of how it could work.

TO IMPROVE:
-Compile

-Test

-Create basic NFT samples

-Send data from chainlink

-The data isn't private, but we can do it without storing data onchain too. 
By only storing a private link to access the data offchain (Like Ocean Protocol for example)

-Don't allow anybody to call the changeUserHeartRate function.

-Make an Array of Doctors, do not store only one

-We can add other health data in the userData struct
(surname, name, age, weight, height...)
*/

error YouAlreadyHaveAnNFT();
error ThisAccountDoesNotExist();
error YouAreNotTheOwnerOfThisNFT();
error YouAreNotAllowedToSeeThisData();
error TheOwnerOfThisNftIsNotHisCreator();
error CreateYourNftBeforeCallingThisFunction();

contract MetaCareDynamicNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    //URIs storing the metadata for each different NFT states
    string baseURI;
    string lowURI;
    string highURI;

    //User Data structure (created during minting, values will be updated automatically)
    struct userData {
        address userAddress;
        address doctorAddress;
        uint256 tokenId;
        uint256 heartRate;
    }

    //create one structure of data for each user (we can find it using the NFT tokenID)
    mapping(address => userData) userDataList;

    //asign a name to the NFT collection
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

    //Give the possibility to change your doctor's address
    function changeMyDoctorAddress(address _newDoctorAddress) external {
        if (userDataList[msg.sender].userAddress != msg.sender) {
            revert CreateYourNftBeforeCallingThisFunction();
        }

        if (msg.sender != ownerOf(userDataList[msg.sender].tokenId)) {
            revert TheOwnerOfThisNftIsNotHisCreator();
        }

        //change the doctor address
        userDataList[msg.sender].doctorAddress = _newDoctorAddress;
    }

    //Enter your ETH address or the address of your patient
    function getUserData(address _userAddress)
        external
        view
        returns (userData memory)
    {
        if (userDataList[_userAddress].userAddress != _userAddress) {
            revert ThisAccountDoesNotExist();
        }

        if (_userAddress != ownerOf(userDataList[_userAddress].tokenId)) {
            revert TheOwnerOfThisNftIsNotHisCreator();
        }

        //check if the user want to see his own data
        if (msg.sender == _userAddress) {
            return userDataList[_userAddress];
        }

        //check if it's a doctor that want to get access to a patient data
        if (msg.sender == userDataList[_userAddress].doctorAddress) {
            return userDataList[_userAddress];
        }

        //if the person calling the function isn't the data owner or a doctor, send him an error
        revert YouAreNotAllowedToSeeThisData();
    }

    //function used by chainlink to change the current heart Rate Data
    function changeUserHeartRateData(address _userAddress, uint256 _heartRate)
        external
    {
        if (userDataList[_userAddress].userAddress != _userAddress) {
            revert ThisAccountDoesNotExist();
        }

        if (_userAddress != ownerOf(userDataList[_userAddress].tokenId)) {
            revert TheOwnerOfThisNftIsNotHisCreator();
        }

        //Change the heartRate data
        userDataList[_userAddress].heartRate = _heartRate;
    }

    //Get the Metadata for each NFTs
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (_exists(_tokenId) == false) {
            revert ThisAccountDoesNotExist();
        }

        //Get the heartRate of the owner of the tokenID
        address userAddress = ownerOf(_tokenId);
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

    //Define the Base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
