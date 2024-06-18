// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VHTContractBase.sol";
import "./VHTContractPermit.sol";
import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";
import "@thirdweb-dev/contracts/extension/Multicall.sol";
import "@thirdweb-dev/contracts/extension/Ownable.sol";
import "@thirdweb-dev/contracts/extension/interface/IMintableERC20.sol";
import "@thirdweb-dev/contracts/extension/interface/IBurnableERC20.sol";

/**
 * @title VHTContractImpl
 * @dev Implementation of a mintable and burnable ERC20 token with additional functionality.
 */
contract VHTContractImpl is ContractMetadata, Multicall, Ownable, VHTContractPermit, IMintableERC20, IBurnableERC20 {
    /**
     * @dev Initializes the contract setting the default admin and token details.
     * @param _defaultAdmin The address of the default admin.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     */
    function initialize(address _defaultAdmin, string memory _name, string memory _symbol) public initializer {
        VHTContractPermit.initialize(_name, _symbol);
        _setupOwner(_defaultAdmin);
    }

    /**
     * @dev Mints tokens to a specified address.
     * @param _to The address to mint the tokens to.
     * @param _amount The amount of tokens to mint.
     */
    function mintTo(address _to, uint256 _amount) public virtual {
        require(_canMint(), "Not authorized to mint.");
        require(_amount != 0, "Minting zero tokens.");
        _mint(_to, _amount);
    }

    /**
     * @dev Burns a specified amount of tokens from the caller's account.
     * @param _amount The amount of tokens to burn.
     */
    function burn(uint256 _amount) external virtual {
        require(balanceOf(msg.sender) >= _amount, "not enough balance");
        _burn(msg.sender, _amount);
    }

    /**
     * @dev Burns a specified amount of tokens from a specified account.
     * @param _account The address to burn the tokens from.
     * @param _amount The amount of tokens to burn.
     */
    function burnFrom(address _account, uint256 _amount) external virtual override {
        require(_canBurn(), "Not authorized to burn.");
        require(balanceOf(_account) >= _amount, "not enough balance");
        uint256 decreasedAllowance = allowance(_account, msg.sender) - _amount;
        _approve(_account, msg.sender, 0);
        _approve(_account, msg.sender, decreasedAllowance);
        _burn(_account, _amount);
    }

    /**
     * @dev Determines if the contract URI can be set.
     * @return A boolean value indicating whether the contract URI can be set.
     */
    function _canSetContractURI() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    /**
     * @dev Determines if the caller can mint tokens.
     * @return A boolean value indicating whether the caller can mint tokens.
     */
    function _canMint() internal view virtual returns (bool) {
        return msg.sender == owner();
    }

    /**
     * @dev Determines if the caller can burn tokens.
     * @return A boolean value indicating whether the caller can burn tokens.
     */
    function _canBurn() internal view virtual returns (bool) {
        return msg.sender == owner();
    }

    /**
     * @dev Determines if the owner can be set.
     * @return A boolean value indicating whether the owner can be set.
     */
    function _canSetOwner() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    /**
     * @dev Returns the message sender's address.
     * @return The address of the message sender.
     */
    function _msgSender() internal view override(Multicall, Context) returns (address) {
        return msg.sender;
    }

    /**
     * @dev Authorizes an upgrade.
     */
    function _authorizeUpgrade(address) internal view {
        require(msg.sender == owner(), "Unauthorized");
    }
}
