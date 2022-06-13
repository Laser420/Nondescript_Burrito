// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0;


contract BalancerBriber {
    address tribeCouncil;
    address governor; 
    bytes32 proposal;

    address balancerBribeAdd;

    IBalancerBriber BalancerBribeVault;
    IERC20 feiInterface;
    
    constructor() {

        //Proposal value found in this transaction hash: https://etherscan.io/tx/0x31df193a1a3b677025cb0fd5312306ed7bc2b3341626c7d8bc7b327597aa5190
        //Transaction executed by never#7298 - thank you brother. I am broke. - Fishy's unpaid intern
        //Added '0x-' prefix to properly compile.
        proposal = 0x12886ee1cc4ab69429f4989a2721786216267613abdefa3edfdaff4b446904ab;
        governor = 0x0000000000000000000000000000000000000000; // Trusted individual able to execute the bribe - set by the Tribe Council. 
        tribeCouncil = 0x2EC598d8e3DF35E5D6F13AE2f05a7bB2704e92Ea; //set this address to the tribe council multi-cig address
        BalancerBribeVault = IBalancerBriber(0x7Cdf753b45AB0729bcFe33DC12401E55d28308A9); //BalancerBribeVault address
        balancerBribeAdd = 0x7Cdf753b45AB0729bcFe33DC12401E55d28308A9;
        feiInterface = IERC20(0x956F47F50A910163D8BF957Cf5846D573E7f87CA); //Interface to the FEI token address
    }

    modifier isTribeCouncil() {
        require(msg.sender == tribeCouncil, "You aren't the tribe council...");
        _;
    }

    modifier isGovernor() {
        require(msg.sender == governor, "You aren't the governor...");
        _;
    }

    //Withdraw any FEI in this contract directly to the Tribe Council Address - nowhere else
    function withdrawFEI() public isTribeCouncil {
        uint256 bal = feiInterface.balanceOf(address(this));
        feiInterface.approve(address(this), bal);
        feiInterface.transferFrom(address(this), tribeCouncil, bal);
    }


    //MAKE SURE YOU ADD THE CORRECT AMOUNT OF ZEROES TO THE TRANSACTION QUANTITY
    function executeBribeGovernor(uint256 amt) external isGovernor {
        
        //Approve this transaction with FEI
         feiInterface.approve(address(this), amt);

         //Approve this transaction with the balancerBribeAddress
         feiInterface.approve(balancerBribeAdd, amt);

        //Run the transaction for the proposal address, using the FEI token, in the 
        BalancerBribeVault.depositBribeERC20(proposal, 0x956F47F50A910163D8BF957Cf5846D573E7f87CA, amt);

    }

    //MAKE SURE YOU ADD THE CORRECT AMOUNT OF ZEROES TO THE TRANSACTION QUANTITY
   function executeBribeCouncil(uint256 amt) external isTribeCouncil {

         //Approve this transaction with FEI
         feiInterface.approve(address(this), amt);
         
         //Approve this transaction with the balancerBribeAddress
         feiInterface.approve(balancerBribeAdd, amt);

        //Run the transaction for the proposal address, using the FEI token, in the 
        BalancerBribeVault.depositBribeERC20(proposal, 0x956F47F50A910163D8BF957Cf5846D573E7f87CA, amt);
   }
}


interface IBalancerBriber {

     function depositBribeERC20(
        bytes32 proposal,
        address token,
        uint256 amount
    ) external;
}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

   
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// Address Glossary:
// Hidden Hand balancer briber address: https://etherscan.io/address/0x7Cdf753b45AB0729bcFe33DC12401E55d28308A9
// Hidden Hand bribe vault: https://etherscan.io/address/0x9ddb2da7dd76612e0df237b89af2cf4413733212
// B-30FEI-70WETH-gauge address: https://etherscan.io/address/0x4f9463405f5bc7b4c1304222c1df76efbd81a407
// FEI address: https://etherscan.io/address/0x956F47F50A910163D8BF957Cf5846D573E7f87CA
