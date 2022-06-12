// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0;


contract BalancerBriber {
    address tribeCouncil;
    address governor; 
    bytes32 proposal;

    uint256 lastCall; 

    IBalancerBriber BalancerBribeVault;
    IERC20 feiInterface;
    
    constructor() {
        proposal = 0x12886ee1cc4ab69429f4989a2721786216267613abdefa3edfdaff4b446904ab;
        governor = 0x72b7448f470D07222Dbf038407cD69CC380683F3; // Someone who can vetoe any transactions during the timelock
        tribeCouncil = 0x2EC598d8e3DF35E5D6F13AE2f05a7bB2704e92Ea; //set this address to the tribe council multi-cig address
        BalancerBribeVault = IBalancerBriber(0x7Cdf753b45AB0729bcFe33DC12401E55d28308A9); // an StETH address I found on rinkeby - speedread the code and its pretty much golden
        feiInterface = IERC20(0x956F47F50A910163D8BF957Cf5846D573E7f87CA);
        

        lastCall = block.timestamp;
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



    function executeBribeGovernor(uint256 amt) external isGovernor {
        
        //Approve this transaction with FEI
         feiInterface.approve(address(this), amt);

        //
        BalancerBribeVault.depositBribeERC20(proposal, 0x956F47F50A910163D8BF957Cf5846D573E7f87CA, amt);

    }

   function executeBribeCouncil() external isTribeCouncil {
       //run functionality 
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
