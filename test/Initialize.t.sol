// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/VHTContractImpl.sol";

contract InitializeTest is Test {
    function setUp() public {}

    function testInitializeData() public {
        emit log_bytes(
            abi.encodeCall(
                VHTContractImpl.initialize,
                (address(0xbAe7d9DD0b1818073e9eF0724E2e43B719677fEE),"Vault Hill Token","$VHT")
            )
        );
    }
}
