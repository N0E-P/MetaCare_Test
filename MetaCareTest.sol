// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

/* NOTES TO READ:
Of course, all the data isn't private.
And for now, anybody can call the changeUserHeartRate function.
But it's an example contract to have an idea of how it could work.

SignUp with your name / surname / doctor address (it can be any ETH address)
Then, call any function, to see your data or to change it
*/

error MetaCare__YouAlreadyHaveCreatedAnAccount();
error MetaCare__ThisAccountDoesNotExist();
error MetaCare__YouAreNotAllowedToSeeThisData();

contract MetaCareTest {
    //User Data structure (created during sign in, and values will be updated automatically)
    struct userData {
        address userAddress;
        string surname;
        string name;
        address doctorAddress; //it's just an unique address for now, but we can replace it later by an array
        uint256 heartRate;
        //We can add: age, weight, height and other health data later...
    }

    //create one structure of data for each user (we can find it using the user ETHaddress)
    mapping(address => userData) userDataList;

    //add yourself in the smart contract data
    function signUp(
        string memory _surname,
        string memory _name,
        address _doctorAddress
    ) external {
        if (userDataList[msg.sender].userAddress == msg.sender) {
            //it might be possible to simplify this if statement by just asking if userDataList[msg.sender] exists
            revert MetaCare__YouAlreadyHaveCreatedAnAccount();
        }

        //add the user data in the mapping using the struct object
        userDataList[msg.sender] = userData(
            msg.sender,
            _surname,
            _name,
            _doctorAddress,
            0
        );
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

    //The user can modify his doctor list at anytime
    function changeMyDoctorList(address _doctorAddress) external {
        //error if a database with this user address doesn't exist
        if (userDataList[msg.sender].userAddress != msg.sender) {
            //it might be possible to simplify this if statement by just asking if userDataList[msg.sender] exists
            revert MetaCare__ThisAccountDoesNotExist();
        }
        userDataList[msg.sender].doctorAddress = _doctorAddress;
    }

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
}
