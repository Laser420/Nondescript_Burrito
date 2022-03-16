// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Owner
 * @dev Set & change owner
 */
contract governor {

    address private governor;
    
    // event for EVM logging
    event GovernorSet(address indexed oldGov, address indexed newGov);
    
    // modifier to check if caller is owner
    modifier isGov() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == governor, "Caller is not governor");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        governor = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit GovSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeGov(address newGovernor) public isGov {
        emit GovSet(governor, newGov);
        governor = newGovernor;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getGov() external view returns (address) {
        return governor;
    }
}