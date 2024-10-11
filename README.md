# Vault Hill Token (VHT)

## Technical and Functional Requirements Documentation

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architectural Approach](#architectural-approach)

   2.1 [Contract Structure](#contract-structure)
   
   2.2 [Rationale](#rationale)
   
   2.3 [Technology Stack](#technology-stack)
3. [Functional Requirements](#functional-requirements)
   
   3.1 [Token Functionality](#token-functionality)
   
   3.2 [Administrative Functions](#administrative-functions)
   
   3.3 [Upgradability](#upgradability)
4. [Technical Requirements](#technical-requirements)
   
   4.1 [Smart Contract Specifications](#smart-contract-specifications)
   
   4.2 [Security Considerations](#security-considerations)
   
   4.3 [Gas Optimization](#gas-optimization)
5. [User Interaction](#user-interaction)
   
   5.1 [User Roles](#user-roles)
   
   5.2 [Utility Provided](#utility-provided)
   
   5.3 [Interaction Methods](#interaction-methods)
6. [Testing and Quality Assurance](#testing-and-quality-assurance)
7. [Deployment and Maintenance](#deployment-and-maintenance)
8. [Future Considerations](#future-considerations)
9. [Conclusion](#conclusion)

## 1. Project Overview

The Vault Hill Token (VHT) project represents a significant evolution in blockchain-based utility tokens, designed to surpass the limitations of its predecessor, the VHC token. While the VHC token was primarily focused on the Vault Hill City metaverse, VHT expands its utility to encompass a broader ecosystem of decentralized applications and services.

Key Improvements and Features:

1. **Enhanced Flexibility**: VHT is engineered to be a versatile utility token, capable of seamlessly integrating with various decentralized platforms beyond just the metaverse context. This increased adaptability opens up new use cases and potential partnerships.

2. **Advanced Token Economics**: Leveraging cutting-edge smart contract capabilities, VHT introduces dynamic minting and burning mechanisms. These features allow for more sophisticated token supply management, potentially leading to better value stability and growth opportunities.

3. **Improved Scalability**: Built on the Thirdweb framework, VHT incorporates state-of-the-art scalability solutions, ensuring lower transaction costs and faster processing times compared to its predecessor.

4. **Enhanced Security**: VHT employs the latest in smart contract security practices, including upgradability features that allow for continuous improvement and rapid response to potential vulnerabilities or changing market conditions.

5. **Expanded Utility**: Beyond basic transfer and storage of value, VHT introduces advanced features such as delegated transfers, batch transactions (multicall capabilities), and metadata management, enhancing its utility in complex DeFi and Web3 ecosystems.

6. **Governance Ready**: While maintaining centralized control for initial stability, VHT's architecture is designed with future decentralization in mind, potentially allowing token holders to participate in ecosystem governance.

7. **Cross-Platform Compatibility**: Unlike the VHC token, VHT is designed with cross-chain functionality in mind, paving the way for interoperability with various blockchain networks and expanding its reach beyond a single ecosystem.

8. **Improved Developer Experience**: With comprehensive documentation and standardized interfaces, VHT makes it easier for developers to integrate the token into new projects and applications, fostering a growing ecosystem of VHT-powered solutions.

By leveraging the Thirdweb framework and incorporating various extensions, VHT aims to position itself as a next-generation utility token. It not only addresses the limitations of the VHC token but also sets a new standard for flexibility, security, and functionality in the rapidly evolving blockchain space.

The primary goals of this project are:
- Implement a secure and standards-compliant ERC20 token with advanced features
- Provide sophisticated minting and burning capabilities for dynamic supply management
- Ensure upgradability to accommodate future improvements and market demands
- Optimize for gas efficiency and user experience across various blockchain environments
- Implement robust security measures to protect user assets and maintain trust
- Create a token ecosystem that extends far beyond the original metaverse use case, opening up new opportunities for users, developers, and partners

## 2. Architectural Approach

### 2.1 Contract Structure

The project consists of three main contracts:

1. **VHTContractBase**:

   - Implements the ERC20 standard
   - Handles basic token functionalities:
     - Balance management
     - Allowance system
     - Token metadata (name, symbol, decimals)

2. **VHTContractImpl**:

   - Extends VHTContractBase
   - Implements additional functionalities:
     - Minting tokens
     - Burning tokens
   - Incorporates Upgradeable and Initializable patterns

3. **VHTContractProxy**:
   - Acts as a proxy for the implementation contract
   - Enables upgradability without state loss
   - Delegates calls to the implementation contract

### 2.2 Rationale

The chosen architecture offers several benefits:

1. **Upgradability**: The proxy pattern allows for contract upgrades without requiring users to migrate to a new contract address.
2. **Separation of Concerns**: By separating the logic (VHTContractImpl) from the state (VHTContractProxy), the system becomes more modular and easier to maintain.
3. **Extensibility**: The use of Thirdweb's extensions provides built-in functionalities that can be easily integrated and expanded upon.
4. **Standards Compliance**: Adhering to the ERC20 standard ensures compatibility with existing wallets and exchanges.

### 2.3 Technology Stack

- **Solidity**: The primary language for smart contract development
- **Thirdweb Framework**: Provides pre-built contract extensions and development tools
- **OpenZeppelin**: Offers secure, tested, and community-audited smart contract components
- **Forge**: Development environment for compiling, testing, and deploying smart contracts
- **Ethers.js**: JavaScript library for interacting with the Ethereum blockchain

## 3. Functional Requirements

### 3.1 Token Functionality

1. **Token Metadata**:

   - Name: Vault Hill Token
   - Symbol: VHT
   - Decimals: 18

2. **Basic ERC20 Functions**:

   - `balanceOf(address account)`: Returns the token balance of an account
   - `transfer(address recipient, uint256 amount)`: Transfers tokens to a specified address
   - `approve(address spender, uint256 amount)`: Approves an address to spend tokens on behalf of the owner
   - `transferFrom(address sender, address recipient, uint256 amount)`: Transfers tokens on behalf of an approved spender
   - `totalSupply()`: Returns the total supply of tokens

3. **Minting**:

   - `mintTo(address to, uint256 amount)`: Mints new tokens to a specified address
   - Restricted to authorized minters

4. **Burning**:
   - `burn(uint256 amount)`: Burns tokens from the caller's balance
   - `burnFrom(address account, uint256 amount)`: Burns tokens from a specified account (requires approval)

### 3.2 Administrative Functions

1. **Ownership Management**:

   - `transferOwnership(address newOwner)`: Transfers contract ownership
   - `renounceOwnership()`: Renounces contract ownership

2. **Metadata Management**:

   - `setContractURI(string memory _uri)`: Sets the contract metadata URI

3. **Role Management**:
   - `grantRole(bytes32 role, address account)`: Grants a role to an account
   - `revokeRole(bytes32 role, address account)`: Revokes a role from an account

### 3.3 Upgradability

1. **Proxy Upgrade**:
   - `upgradeTo(address newImplementation)`: Upgrades the implementation contract
   - `upgradeToAndCall(address newImplementation, bytes memory data)`: Upgrades the implementation and calls a function

## 4. Technical Requirements

### 4.1 Smart Contract Specifications

1. **Solidity Version**: ^0.8.0
2. **EVM Compatibility**: Ethereum mainnet and compatible sidechains/L2 solutions
3. **Contract Size**: Must not exceed 24KB (Ethereum contract size limit)
4. **State Variables**: Minimize the number of storage variables to reduce gas costs

### 4.2 Security Considerations

1. **Access Control**: Implement role-based access control for administrative functions
2. **Integer Overflow/Underflow**: Utilize Solidity 0.8.x's built-in overflow checks
3. **Event Emission**: Emit events for all state-changing functions to facilitate off-chain tracking

### 4.3 Gas Optimization

1. **Efficient Storage**: Use appropriate data types to minimize storage costs
2. **Batched Operations**: Implement multicall functionality for gas-efficient batch transactions
3. **Minimize External Calls**: Reduce the number of external contract calls to save gas

## 5. User Interaction

### 5.1 User Roles

1. **Token Holders**: Users who own and transact with VHT tokens
2. **Contract Administrators**: Users with privileged access to manage the contract
3. **Minters**: Authorized addresses that can mint new tokens

### 5.2 Utility Provided

1. **Token Transactions**: Transfer and receive VHT tokens
2. **Supply Management**: Mint new tokens or burn existing ones
3. **Allowance System**: Approve other addresses to spend tokens on behalf of the owner
4. **Metadata Access**: Retrieve token and contract metadata

### 5.3 Interaction Methods

1. **Minting**:

   - Function: `mintTo(address to, uint256 amount)`
   - Description: Mints a specified amount of tokens to the given address

2. **Burning**:

   - Function: `burn(uint256 amount)`
   - Description: Burns a specified amount of tokens from the caller's balance

3. **Transfer**:

   - Function: `transfer(address to, uint256 amount)`
   - Description: Transfers tokens from the caller's address to another address

4. **Allowance Management**:

   - Functions:
     - `approve(address spender, uint256 amount)`
     - `transferFrom(address from, address to, uint256 amount)`
   - Description: Allows users to approve another address to spend tokens on their behalf

5. **Multicall**:
   - Function: `multicall(bytes[] calldata data)`
   - Description: Executes multiple function calls in a single transaction

## 6. Testing and Quality Assurance

1. **Unit Testing**: Comprehensive test suite covering all contract functions
2. **Integration Testing**: Tests for interaction between different contract components
3. **Gas Consumption Analysis**: Monitoring and optimization of gas usage for all functions
4. **Security Audits**: Third-party security audit to identify and mitigate vulnerabilities
5. **Formal Verification**: Consider formal verification of critical contract components

## 7. Deployment

1. **Deployment Process**:

   - **Step 1**: Deploy `VHTContractBase`
   - **Step 2**: Deploy `VHTContractImpl` with `VHTContractBase` as the base
   - **Step 3**: Deploy `VHTContractProxy` with the implementation address of `VHTContractImpl`
   - **Step 4**: Initialize the proxy contract with token parameters

     **Commands**:

     ```bash
     npm run deploy <thirdweb-secret-key>
     # or
     yarn deploy <thirdweb-secret-key>

     ```

2. **Upgrade Process**:

   - Deploy new implementation contract
   - Call `upgradeTo` on the proxy contract

3. **Release Process**:

   - **Description**: To release a version of the contracts publicly, use one of the following commands:
   - **Commands**:
     ```bash
     npm run release
     # or
     yarn release
     ```

## 8. Conclusion

This technical and functional requirements document outlines the comprehensive plan for developing the Vault Hill Token (VHT) smart contract system. By adhering to these specifications, the project aims to deliver a secure, efficient, and flexible token solution that meets the needs of users and administrators while maintaining the ability to adapt to future blockchain developments.
