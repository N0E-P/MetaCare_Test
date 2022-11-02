pragma solidity ^0.8.12;

//error list
error YouAlreadyHaveAnNFT();
error ThisTokenIdDoesNotExist();
error YouAreNotTheOwnerOfThisNFT();

contract MetaCareDynamicNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    //URIs storing the metadata for each different NFT states
    string baseURI;
    string lowURI;
    string highURI;

    //User Data structure (created during minting, values will be updated automatically)
    struct userData {
        uint256 heartRate;
        address doctorAddress;
        // We can store any other data we want in the userData struct :
        // userAddress, surname, name, age, weight, height and any other health data...
    }

    //create one structure of data for each user (we can find it using the NFT tokenID)
    mapping(uint256 => userData) public userDataList;

    //asign a name to the NFT collection
    constructor() ERC721("MetaCare", "MC") {}

    //add yourself to the user list by minting an NFT
    function mint(address _doctorAddress) public {
        if (balanceOf(_owner) > 0) {
            revert YouAlreadyHaveAnNFT();
        }

        //Get supply number / Add the user in the struct / Create the NFT
        uint256 supply = totalSupply();
        userDataList[supply + 1] = userData{80, _doctorAddress};
        _safeMint(msg.sender, supply + 1);
    }

    //Get the Metadata for each NFTs
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if(_exists(_tokenId) == false) {
            revert ThisTokenIdDoesNotExist();
        }

        //Return the URI in function of the current heartRate
        uint256 currentHeartRate = userDataList[_tokenId].heartRate;
        if(currentHeartRate > 100){
            return _highURI;
        } else if (currentHeartRate < 60){
            return _lowURI;
        } else {
            return _baseURI();
        }
    }

    //define the Base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }


    //give the possibility to change our doctor's address
    function changeMyDoctorAddress(uint256 _tokenId, address _newDoctorAddress) external {
        if (msg.sender != ownerOf(_tokenId)) {
            revert YouAreNotTheOwnerOfThisNFT();
        }

        //change the doctor address
        userDataList[_tokenId].doctorAddress = _newDoctorAddress;
    }


    //////////////////////////////////////////


    function getUserData(address _userAddress)  
        external
        view
        returns (userData memory)
    {
        //error if a database with this user address doesn't exist

        if (userDataList[_userAddress].userAddress != _userAddress) {
            //it might be possible to simplify this if statement by just asking if userDataList[msg.sender] exists
            revert MetaCare__ThisAccountDoesNotExist();
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
        revert MetaCare__YouAreNotAllowedToSeeThisData();
    }


    //function used by chainlink or the private data thing
    function changeUserHeartRateData(address _userAddress, uint256 _heartRate)
        external
    {
        //ADD AN IF STATEMENT HERE : Verify if the sender of this data is trusted

        //error if a database with this user address doesn't exist
        if (userDataList[_userAddress].userAddress != _userAddress) {
            //it might be possible to simplify this if statement by just asking if userDataList[msg.sender] exists
            revert MetaCare__ThisAccountDoesNotExist();
        }

        userDataList[_userAddress].heartRate = _heartRate;
    }
}
