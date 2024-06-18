// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/eip/interface/IERC20Permit.sol";
import "@thirdweb-dev/contracts/external-deps/openzeppelin/utils/cryptography/EIP712.sol";
import "@thirdweb-dev/contracts/external-deps/openzeppelin/utils/cryptography/ECDSA.sol";
import "@thirdweb-dev/contracts/external-deps/openzeppelin/utils/Counters.sol";
import "./VHTContractBase.sol";

/**
 * @title VHTContractPermit
 * @dev Abstract contract that adds permit functionality to VHTContractBase using EIP-2612.
 */
abstract contract VHTContractPermit is VHTContractBase, IERC20Permit {
    using Counters for Counters.Counter;

    mapping(address => Counters.Counter) private _nonces;

    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator();
    uint256 private immutable _CACHED_CHAIN_ID = block.chainid;
    address private immutable _CACHED_THIS = address(this);
    bytes32 private immutable _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /**
     * @dev Initializes the permit functionality.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     */
    function initialize(string memory name_, string memory symbol_) internal virtual override initializer {
        VHTContractBase.initialize(name_, symbol_);
    }

    /**
     * @dev Allows `spender` to spend `value` tokens on behalf of `owner` through a signed message.
     * @param owner The address of the token owner.
     * @param spender The address of the token spender.
     * @param value The amount of tokens to be spent.
     * @param deadline The time by which the permit must be used.
     * @param v The recovery byte of the signature.
     * @param r Half of the ECDSA signature pair.
     * @param s Half of the ECDSA signature pair.
     */
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        public
        virtual
        override
    {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));

        bytes32 hash = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR(), structHash);

        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        _approve(owner, spender, value);
    }

    /**
     * @dev Returns the current nonce for an address. This value must be included whenever a signature is generated for {permit}.
     * @param owner The address to query.
     * @return The current nonce for the address.
     */
    function nonces(address owner) public view virtual override returns (uint256) {
        return _nonces[owner].current();
    }

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     * @return The domain separator.
     */
    function DOMAIN_SEPARATOR() public view override returns (bytes32) {
        if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
            return _CACHED_DOMAIN_SEPARATOR;
        } else {
            return _buildDomainSeparator();
        }
    }

    /**
     * @dev Builds the domain separator for the current chain.
     * @return The domain separator.
     */
    function _buildDomainSeparator() private view returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name())),
                keccak256("1"),
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @dev Increments the nonce for an address.
     * @param owner The address to increment the nonce for.
     */
    function _useNonce(address owner) internal virtual returns (uint256 current) {
        Counters.Counter storage nonce = _nonces[owner];
        current = nonce.current();
        nonce.increment();
    }
}
