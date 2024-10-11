// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/VHTContractImpl.sol";

contract VHTContractImplTest is Test {
    VHTContractImpl token;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0xBEEF);
        user2 = address(0xCAFE);
        token = new VHTContractImpl();
        token.initialize(owner, "Vault Hill Token", "$VHT");
    }

    function testMint() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        assertEq(token.balanceOf(user1), amount);
    }

    function testBurn() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        token.burn(amount);
        assertEq(token.balanceOf(user1), 0);
    }

    function testBurnFrom() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        token.approve(owner, amount);
        token.burnFrom(user1, amount);
        assertEq(token.balanceOf(user1), 0);
    }

    function testTransfer() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        token.transfer(user2, amount);
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.balanceOf(user2), amount);
    }

    function testFailMintUnauthorized() public {
        vm.prank(user1);
        token.mintTo(user1, 1000);
    }

    function testFailBurnUnauthorized() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        vm.prank(user1);
        token.burn(amount);
    }

    function testFailBurnFromUnauthorized() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        vm.prank(user2);
        token.burnFrom(user1, amount);
    }

    function testFailTransferInsufficientBalance() public {
        vm.expectRevert("not enough balance");
        token.transfer(user2, 1000);
    }
}
