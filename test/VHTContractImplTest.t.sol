// SPDX-License-Identifier: MIT
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
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
    }

    function testMint() public {
        uint256 amount = 1000;
        token.mintTo(user1, amount);
        assertEq(token.balanceOf(user1), amount);
    }

    function testBurn() public {
        uint256 amount = 1000;
        // Mint tokens to user1
        token.mintTo(user1, amount);
        // Simulate a transaction from user1 to burn tokens
        vm.prank(user1);
        token.burn(amount);
        // Verify that the balance of user1 is 0 after burning the tokens
        assertEq(token.balanceOf(user1), 0);
    }

    function testBurnFrom() public {
        uint256 amount = 1000;
        // Mint tokens to user1
        token.mintTo(user1, amount);
        // Verify that user1's balance is equal to the minted amount
        assertEq(token.balanceOf(user1), amount);
        // Approve owner to burn tokens from user1
        vm.prank(user1); // Simulate a transaction from user1
        token.approve(owner, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, owner), amount);
        // Burn tokens from user1 by owner
        vm.prank(owner); // Simulate a transaction from the owner
        token.burnFrom(user1, amount);
        // Verify that user1's balance is 0 after burning the tokens
        assertEq(token.balanceOf(user1), 0);
    }

    function testTransfer() public {
        uint256 amount = 1000;
        // Mint tokens to user1
        token.mintTo(user1, amount);
        // Verify that user1's balance is equal to the minted amount
        assertEq(token.balanceOf(user1), amount);
        // Transfer tokens from user1 to user2
        vm.prank(user1); // Simulate a transaction from user1
        token.transfer(user2, amount);
        // Verify that user1's balance is 0 after the transfer
        assertEq(token.balanceOf(user1), 0);
        // Verify that user2's balance is equal to the transferred amount
        assertEq(token.balanceOf(user2), amount);
    }

    function testTransferFrom() public {
        uint256 amount = 1000;
        // Mint tokens to user1
        token.mintTo(user1, amount);
        // Verify that user1's balance is equal to the minted amount
        assertEq(token.balanceOf(user1), amount);
        // Approve user2 to transfer tokens from user1
        vm.prank(user1); // Simulate a transaction from user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
        // Transfer tokens from user1 to user2 by user2
        vm.prank(user2); // Simulate a transaction from user2
        token.transferFrom(user1, user2, amount);
        // Verify that user1's balance is 0 after the transfer
        assertEq(token.balanceOf(user1), 0);
        // Verify that user2's balance is equal to the transferred amount
        assertEq(token.balanceOf(user2), amount);
    }

    function testSetContractURI() public {
        string memory uri = "https://vault-hill.com/token";
        // Simulate a transaction from the owner
        vm.prank(owner);
        // Set the contract URI
        token.setContractURI(uri);
        // Verify that the contract URI is set correctly
        assertEq(token.contractURI(), uri);
    }

    function testFailMintUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to mint tokens to user1
        // This should fail because user1 is not authorized to mint tokens
        token.mintTo(user1, amount);
        // Verify that user1's balance is still 0
        assertEq(token.balanceOf(user1), 0);
    }

    function testFailBurnUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to burn tokens from user1
        // This should fail because user1 is not authorized to burn tokens
        token.burn(amount);
        // Verify that user1's balance is still 0
        assertEq(token.balanceOf(user1), 0);
    }

    function testFailBurnFromUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to burn tokens from user1 by user1
        // This should fail because user1 is not authorized to burn tokens from another account
        token.burnFrom(user1, amount);
        // Verify that user1's balance is still 0
        assertEq(token.balanceOf(user1), 0);
    }

    function testFailTransferUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to transfer tokens from user1 to user2
        // This should fail because user1 is not authorized to transfer tokens
        token.transfer(user2, amount);
        // Verify that user1's balance is still 0
        assertEq(token.balanceOf(user1), 0);
        // Verify that user2's balance is still 0
        assertEq(token.balanceOf(user2), 0);
    }

    function testFailTransferFromUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to transfer tokens from user1 to user2 by user1
        // This should fail because user1 is not authorized to transfer tokens from another account
        token.transferFrom(user1, user2, amount);
        // Verify that user1's balance is still 0
        assertEq(token.balanceOf(user1), 0);
        // Verify that user2's balance is still 0
        assertEq(token.balanceOf(user2), 0);
    }

    function testFailSetContractURIUnauthorized() public {
        string memory uri = "https://vault-hill.com/token";
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to set the contract URI
        // This should fail because user1 is not authorized to set the contract URI
        token.setContractURI(uri);
        // Verify that the contract URI is still the default value
        assertEq(token.contractURI(), "");
    }

    function testApprove() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Approve user2 to spend tokens on behalf of user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
    }

    function testFailApproveUnauthorized() public {
        uint256 amount = 1000;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Attempt to approve user2 to spend tokens on behalf of user1
        // This should fail because user1 is not authorized to approve spending
        token.approve(user2, amount);
        // Verify that the allowance is still 0
        assertEq(token.allowance(user1, user2), 0);
    }

    function testDecreaseAllowance() public {
        uint256 amount = 1000;
        uint256 decreaseAmount = 500;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Approve user2 to spend tokens on behalf of user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
        // Simulate a transaction from user1 to decrease the allowance
        vm.prank(user1);
        // Decrease the allowance
        token.decreaseAllowance(user2, decreaseAmount);
        // Verify that the allowance is decreased correctly
        assertEq(token.allowance(user1, user2), amount - decreaseAmount);
    }

    function testFailDecreaseAllowanceUnauthorized() public {
        uint256 amount = 1000;
        uint256 decreaseAmount = 500;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Approve user2 to spend tokens on behalf of user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
        // Simulate a transaction from user2 to decrease the allowance
        vm.prank(user2);
        // Attempt to decrease the allowance
        // This should fail because user2 is not authorized to decrease the allowance
        token.decreaseAllowance(user2, decreaseAmount);
        // Verify that the allowance is still the original amount
        assertEq(token.allowance(user1, user2), amount);
    }

    function testIncreaseAllowance() public {
        uint256 amount = 1000;
        uint256 increaseAmount = 500;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Approve user2 to spend tokens on behalf of user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
        // Simulate a transaction from user1 to increase the allowance
        vm.prank(user1);
        // Increase the allowance
        token.increaseAllowance(user2, increaseAmount);
        // Verify that the allowance is increased correctly
        assertEq(token.allowance(user1, user2), amount + increaseAmount);
    }

    function testFailIncreaseAllowanceUnauthorized() public {
        uint256 amount = 1000;
        uint256 increaseAmount = 500;
        // Simulate a transaction from user1
        vm.prank(user1);
        // Approve user2 to spend tokens on behalf of user1
        token.approve(user2, amount);
        // Verify that the allowance is set correctly
        assertEq(token.allowance(user1, user2), amount);
        // Simulate a transaction from user2 to increase the allowance
        vm.prank(user2);
        // Attempt to increase the allowance
        // This should fail because user2 is not authorized to increase the allowance
        token.increaseAllowance(user2, increaseAmount);
        // Verify that the allowance is still the original amount
        assertEq(token.allowance(user1, user2), amount);
    }
}
