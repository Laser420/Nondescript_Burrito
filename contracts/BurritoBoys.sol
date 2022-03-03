pragma solidity >=0.7.0 <0.9.0;


contract BurritoBoys is Owner {

  //ADD AN ENUM FOR VARIOUS STATUS CODES OF THE BURRITOBOYS


  struct BurritoBoy {
    uint entityData;
    bool isEntity;
  }

  mapping(address => BurritoBoy) public BurritoBoys;
  address[] public BBList;

  function isExistent(address BBAddress) public constant returns(bool isExistent) {
      return BurritoBoys[BBAddress].isEntity;
  }
  
  function getNumberOfBurritoBoys() public constant returns(uint numOfBurritoBoys) {
    return BBList.length;
  }

  function newBurritoBoy(address BBAddress, uint entityData) public returns(uint rowNumber) {
    if(isExistent(BBAddress)) revert();
    BurritoBoys[entityAddress].entityData = entityData;
    BurritoBoys[entityAddress].isEntity = true;
    return BBList.push(entityAddress) - 1;
  }

  function updateABurritoBoy(address BBAddress, uint entityData) public returns(bool success) {
    if(!isExistent(BBAddress)) revert();
    BurritoBoys[entityAddress].entityData    = entityData;
    return true;
  }


  //make a function to iterate through the burritoboys and calculate things like LTV 
  //then ultimately - somehow (unsure exactly maybe through multiple iterations via changing enums n shit)
  //get a list of BurritoBoys that can be liquidated

  
  
}