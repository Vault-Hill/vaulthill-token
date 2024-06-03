// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VHTContractBase.sol";
import "./VHTContractPermit.sol";
import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";
import "@thirdweb-dev/contracts/extension/Multicall.sol";
import "@thirdweb-dev/contracts/extension/Ownable.sol";
import "@thirdweb-dev/contracts/extension/interface/IMintableERC20.sol";
import "@thirdweb-dev/contracts/extension/interface/IBurnableERC20.sol";


contract VHTContractImpl is ContractMetadata, Multicall, Ownable, VHTContractPermit, IMintableERC20, IBurnableERC20  {
    function initialize(address _defaultAdmin, string memory _name, string memory _symbol) public initializer  {
        VHTContractPermit.initialize(_name, _symbol);
        _setupOwner(_defaultAdmin);
    }

    function mintTo(address _to, uint256 _amount) public virtual {
        require(_canMint(), "Not authorized to mint.");
        require(_amount != 0, "Minting zero tokens.");
        _mint(_to, _amount);
    }

    function burn(uint256 _amount) external virtual {
        require(balanceOf(msg.sender) >= _amount, "not enough balance");
        _burn(msg.sender, _amount);
    }

    function burnFrom(address _account, uint256 _amount) external virtual override {
        require(_canBurn(), "Not authorized to burn.");
        require(balanceOf(_account) >= _amount, "not enough balance");
        uint256 decreasedAllowance = allowance(_account, msg.sender) - _amount;
        _approve(_account, msg.sender, 0);
        _approve(_account, msg.sender, decreasedAllowance);
        _burn(_account, _amount);
    }

    function _canSetContractURI() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    function _canMint() internal view virtual returns (bool) {
        return msg.sender == owner();
    }

    function _canBurn() internal view virtual returns (bool) {
        return msg.sender == owner();
    }

    function _canSetOwner() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    function _msgSender() internal view override(Multicall, Context) returns (address) {
        return msg.sender;
    }

    function _authorizeUpgrade(address) internal view {
        require(msg.sender == owner(), "Unauthorized");
    }
}
