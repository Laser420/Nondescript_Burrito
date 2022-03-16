//this cadillac is for executives
pragma solidity >=0.7.0 <0.9.0;


contract Caddy is Owner {
    //make sure this contract has all adminstrative functions being called by the compound govenor
    //we copy the Owner script but call it Govenor - it is initially the deployer of the contract
    //but then what we do is change the address to the CompoundGovenor address - so we can still track
    //the owner through the Owner.sol but we can also eventually hand over certain controls to the Govenor
    





 //AMONGST MANY MANY MANY MANY MANY OTHER FUNCTIONS: one function neccessary 
 //is a function to liquidate BurritoBoys v
}