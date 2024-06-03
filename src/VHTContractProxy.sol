// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/extension/ProxyForUpgradeable.sol";

contract VHTContractProxy is ProxyForUpgradeable {
    constructor(address _logic, bytes memory _data) ProxyForUpgradeable(_logic, _data) {}
}