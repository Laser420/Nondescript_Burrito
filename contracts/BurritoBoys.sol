pragma solidity >=0.7.0 <0.9.0;


contract BurritoBoys is Owner {

  struct BurritoBoy {
    uint entityData;
    bool isEntity;
  }

  mapping(address => BurritoBoy) public BurritoBoys;
  address[] public BBList;

  function isExistent(address BBAddress) public constant returns(bool isExistent) {
      return BurritoBoys[BBAddress].isEntity;
  }
  
  function getEntityCount() public constant returns(uint numOfBurritoBoys) {
    return BBList.length;
  }

  function newBurritoBoy(address BBAddress, uint entityData) public returns(uint rowNumber) {
    if(isExistent(BBAddress)) revert();
    BurritoBoys[entityAddress].entityData = entityData;
    BurritoBoys[entityAddress].isEntity = true;
    return BBList.push(entityAddress) - 1;
  }

  function updateEntity(address BBAddress, uint entityData) public returns(bool success) {
    if(!isExistent(BBAddress)) revert();
    BurritoBoys[entityAddress].entityData    = entityData;
    return true;
  }
}