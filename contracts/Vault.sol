
pragma solidity >=0.8.13;

import "./zeppelin/token/ERC20/SafeERC20.sol";
import "./zeppelin/token/ERC20/IERC20.sol";
import "./zeppelin/math/SafeMath.sol";
import "./ownership/Ownable.sol";

// https://forum.openzeppelin.com/t/making-sure-i-understand-how-safeerc20-works/2940/2

/**
* The Vault contract has an owner who is able to set the manager. The manager is
* able to perform withdrawals. 
*/

//this contract initially derived from the OpenZepplin Ownable contract - but for simplicities sake
//I have it deriving from the Owner contract inside this library
//The safemath stuff is fine
contract Vault is Owner {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public manager;

    event ManagerTransferred(
        address indexed previousManager,
        address indexed newManager
    );

    event Withdrawal(
        address indexed token,
        uint256 indexed amount,
        address indexed to
    );

    constructor() public {
        // Initialize manager as _msgSender()
        manager = _msgSender();
        emit ManagerTransferred(address(0), manager);
    }

    /// Modifies a function to run only when called by `manager`.
    modifier onlyManager() {
        require(_msgSender() == manager, "must be manager");
        _;
    }

    /// Changes `manager` account. 
    function changeManager(address newManager) external onlyOwner {
        require(newManager != address(0), "cannot be 0 address");
        emit ManagerTransferred(manager, newManager);
        manager = newManager;
    }

    /// Withdraw `amount` of `token` to address `to`. Only callable by `manager`.
    function withdrawTo(address token, uint256 amount, address to) external onlyManager {
        IERC20(token).safeTransfer(to, amount);
        emit Withdrawal(token, amount, to);
    }
}