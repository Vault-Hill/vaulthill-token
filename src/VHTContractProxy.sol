// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/extension/ProxyForUpgradeable.sol";

/**
 * @title VHTContractProxy
 * @dev A proxy contract for an upgradeable VHT contract. Inherits from ProxyForUpgradeable.
 */
contract VHTContractProxy is ProxyForUpgradeable {
    /**
     * @dev Initializes the proxy with the address of the logic contract and initialization data.
     * @param _logic The address of the logic contract.
     * @param _data The initialization data.
     */
    constructor(address _logic, bytes memory _data) ProxyForUpgradeable(_logic, _data) {}
}
