pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/VHTContractImpl.sol";
import "src/VHTContractProxy.sol";

contract VHTContractUpgradeTest is Test {
    VHTContractImpl upgradeable;
    VHTContractImpl upgraded;
    VHTContractProxy proxy;
    address owner;
    address user1;

    function setUp() public {
        owner = address(this);
        user1 = address(0xBEEF);

        // Deploy the initial implementation
        upgradeable = new VHTContractImpl();
        upgradeable.initialize(owner, "Vault Hill Token", "$VHT");

        // Deploy the proxy pointing to the initial implementation
        proxy = new VHTContractProxy(address(upgradeable), "");

        // Mint tokens through the proxy
        VHTContractImpl(address(proxy)).mintTo(user1, 1000);
    }

    function testUpgrade() public {
        // Deploy the upgraded implementation
        upgraded = new VHTContractImpl();
        upgraded.initialize(owner, "Vault Hill Token", "$VHT");

        // Upgrade the proxy to point to the new implementation
        upgradeable.upgradeTo(address(upgraded));

        // Verify that the state is intact after the upgrade
        assertEq(VHTContractImpl(address(upgradeable)).balanceOf(user1), 1000);
    }

    function testFailUpgradeUnauthorized() public {
        // Attempt to upgrade the proxy from an unauthorized address
        address unauthorized = address(0xCAFE);
        vm.prank(unauthorized);
        upgraded = new VHTContractImpl();
        upgraded.initialize(owner, "Vault Hill Token", "$VHT");

        vm.expectRevert("Not authorized to upgrade");
        upgradeable.upgradeTo(address(upgraded));
    }
}
