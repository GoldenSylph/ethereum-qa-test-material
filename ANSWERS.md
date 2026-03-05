# Senior QA Questionnaire: Answers

## EVM

### 1. What is the Ethereum Virtual Machine (EVM)?

The Ethereum Virtual Machine is the execution environment that processes smart contract bytecode and computes the resulting state transitions for transactions on Ethereum.

**Source:** https://ethereum.org/en/developers/docs/evm/

---

### 2. Why must EVM execution be deterministic?

Execution must be deterministic so that every node executing the same transaction produces the same state transition, ensuring the blockchain state remains consistent across the network.

**Source:** https://ethereum.org/en/developers/docs/evm/

---

### 3. What is gas in Ethereum?

Gas is a unit that measures the computational work required to execute operations in the EVM and prevents abuse of network resources by requiring users to pay for computation.

**Source:** https://ethereum.org/en/developers/docs/gas/

---

## Rollups

### 4. What is a rollup in Ethereum scaling?

A rollup is a Layer 2 scaling solution that processes transactions off the Ethereum mainnet but posts transaction data to Ethereum so the network can verify and secure the rollup state.

**Source:** https://ethereum.org/en/developers/docs/scaling/rollups/

---

### 5. What role does Ethereum L1 play in rollups?

Ethereum L1 provides data availability, settlement, and verification by storing rollup transaction data and verifying validity proofs or dispute outcomes.

**Source:** https://ethereum.org/en/developers/docs/scaling/rollups/

---

## ZK Rollups

### 6. What is a ZK-rollup?

A ZK-rollup is a Layer 2 scaling solution that executes transactions off-chain and submits cryptographic validity proofs to Ethereum that prove the correctness of the resulting state transition.

**Source:** https://ethereum.org/en/developers/docs/scaling/zk-rollups/

---

### 7. What is a validity proof in ZK-rollups?

A validity proof is a cryptographic proof that demonstrates that all transactions in a rollup batch were executed correctly according to the protocol rules.

**Source:** https://ethereum.org/en/developers/docs/scaling/zk-rollups/

---

### 8. Why do ZK-rollups not require a dispute period?

ZK-rollups do not require a dispute period because validity proofs verify the correctness of transactions before the state update is accepted on Ethereum.

**Source:** https://ethereum.org/en/developers/docs/scaling/zk-rollups/

---

### 9. What data do ZK-rollups publish to Ethereum?

ZK-rollups publish compressed transaction data and a cryptographic validity proof that Ethereum verifies to confirm correct execution.

**Source:** https://ethereum.org/en/developers/docs/scaling/zk-rollups/  
https://ethereum.org/en/developers/docs/scaling/rollups/

---

### 10. What is the key difference between ZK-rollups and Optimistic rollups?

ZK-rollups prove correctness using cryptographic validity proofs before finalization, while Optimistic rollups assume transactions are valid and rely on fraud proofs during a challenge period.

**Source:** https://ethereum.org/en/developers/docs/scaling/zk-rollups/  
https://ethereum.org/en/developers/docs/scaling/optimistic-rollups/

---

## Account Abstraction

### 11. What problem does account abstraction attempt to solve in Ethereum?

Account abstraction aims to make Ethereum accounts programmable so that transaction validation logic can be customized, enabling features such as smart contract wallets, alternative signature schemes, and flexible gas payment mechanisms.

**Source:** https://ethereum.org/en/developers/docs/account-abstraction/

---

### 12. What is EIP-4337?

EIP-4337 introduces account abstraction without changing the Ethereum consensus layer by defining a separate transaction flow based on UserOperations, which are processed by bundlers and executed through a smart contract EntryPoint.

**Source:** https://eips.ethereum.org/EIPS/eip-4337

---

### 13. What is a UserOperation in EIP-4337?

A UserOperation is a structured object that represents a user's intended transaction and includes fields such as sender, call data, gas limits, and signature. These operations are processed by bundlers instead of being submitted directly as Ethereum transactions.

**Source:** https://eips.ethereum.org/EIPS/eip-4337

---

### 14. What is the role of a bundler in EIP-4337?

A bundler collects multiple UserOperations, packages them into a single Ethereum transaction, and submits them to the EntryPoint contract for execution.

**Source:** https://eips.ethereum.org/EIPS/eip-4337

---

### 15. What is EIP-7702?

EIP-7702 introduces a mechanism that allows externally owned accounts (EOAs) to behave like smart contracts by delegating execution to contract code during a transaction.

**Source:** https://eips.ethereum.org/EIPS/eip-7702

---

### 16. What capability does EIP-7702 enable for EOAs?

It allows EOAs to execute smart contract logic during a transaction, enabling features similar to smart contract wallets while preserving compatibility with existing Ethereum accounts.

**Source:** https://eips.ethereum.org/EIPS/eip-7702

---

## Foundry cast

### 17. What is `cast` and what is its primary purpose in the Foundry toolkit?

`cast` is Foundry's command-line tool for interacting with EVM networks from the terminal. It covers the full range of read and write operations: calling contract functions, sending transactions, querying chain state, encoding and decoding ABI data, and performing numeric conversions.

**Source:** https://book.getfoundry.sh/cast/

---

### 18. How do you call a read-only contract function with `cast` without spending gas?

Use `cast call`, which performs an `eth_call` — the call is executed locally by the node and does not create a transaction or consume gas.

```shell
cast call <CONTRACT> "<FUNCTION_SIG>" [ARGS...] --rpc-url <RPC_URL>
# e.g.
cast call 0x6B175474E89094C44Da98b954EedeAC495271d0F \
  "balanceOf(address)(uint256)" 0xYourAddress \
  --rpc-url https://mainnet.infura.io/v3/...
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-call

---

### 19. How do you send a state-changing transaction to a contract with `cast`?

Use `cast send`, which signs and broadcasts a transaction. A private key (or hardware wallet flag) is required.

```shell
cast send <CONTRACT> "<FUNCTION_SIG>" [ARGS...] \
  --private-key <PRIVATE_KEY> \
  --rpc-url <RPC_URL>
# e.g.
cast send 0x6B175... "transfer(address,uint256)" 0xRecipient 1000000000000000000 \
  --private-key $PRIVATE_KEY --rpc-url $RPC_URL
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-send

---

### 20. How do you compute the 4-byte selector for a function signature with `cast`?

Use `cast sig`, which returns `keccak256(<signature>)[0:4]` as a hex string.

```shell
cast sig "transfer(address,uint256)"
# 0xa9059cbb
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-sig

---

### 21. How do you decode ABI-encoded calldata using `cast`?

Use `cast decode-calldata`, supplying the function signature and the hex-encoded calldata.

```shell
cast decode-calldata "transfer(address,uint256)" <HEX_CALLDATA>
```

This strips the 4-byte selector and decodes the remaining bytes according to the provided ABI types.

**Source:** https://book.getfoundry.sh/reference/cast/cast-decode-calldata

---

### 22. How do you decode ABI-encoded return data using `cast`?

Use `cast abi-decode`, providing the function signature (so `cast` knows the return types) and the hex-encoded return data. Pass `--input` to decode calldata instead.

```shell
cast abi-decode "balanceOf(address)(uint256)" <HEX_RETURN_DATA>
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-abi-decode

---

### 23. How do you read a raw storage slot from a deployed contract with `cast`?

Use `cast storage`, which calls `eth_getStorageAt` and returns the raw 32-byte value at the given slot index.

```shell
cast storage <CONTRACT> <SLOT> --rpc-url <RPC_URL>
# e.g. slot 0
cast storage 0x6B175... 0 --rpc-url $RPC_URL
```

An optional `--block` flag allows querying historical state.

**Source:** https://book.getfoundry.sh/reference/cast/cast-storage

---

### 24. How do you retrieve the ABI of a verified contract as a Solidity interface with `cast`?

Use `cast interface`, which fetches the ABI from Etherscan and prints a Solidity `interface` definition. Requires `ETHERSCAN_API_KEY` to be set.

```shell
cast interface <CONTRACT> --rpc-url <RPC_URL>
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-interface

---

### 25. How do you convert a value between units (e.g. ether to wei) with `cast`?

Use `cast to-unit` for arbitrary unit conversions, `cast to-wei` to convert to wei, or `cast from-wei` to convert from wei.

```shell
cast to-wei 1 ether                          # 1000000000000000000
cast from-wei 1000000000000000000 ether      # 1
cast to-unit 1000000000 gwei                 # 1
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-to-unit

---

### 26. How does `cast run` assist a QA engineer in debugging a historical transaction?

`cast run` re-executes a historical transaction against a local fork of the chain at the block it was included in, then prints a full call trace with gas usage, return values, and revert reasons. This makes it possible to reproduce and inspect any on-chain execution without redeploying contracts.

```shell
cast run <TX_HASH> --rpc-url <RPC_URL>
```

**Source:** https://book.getfoundry.sh/reference/cast/cast-run

---

## ABI

### 27. What is the ABI in Ethereum?

The Application Binary Interface (ABI) is the standard way to interact with contracts in the Ethereum ecosystem, both from outside the blockchain and for contract-to-contract interaction. It describes how to encode function calls and decode return values as binary data according to the types specified in the contract.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html

---

### 28. What is a function selector and how is it derived?

A function selector is the first 4 bytes of the Keccak-256 hash of the canonical function signature (the function name and parameter types, with no spaces). It identifies which function to call within a contract.

```
selector = bytes4(keccak256("transfer(address,uint256)"))
         = 0xa9059cbb
```

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#function-selector

---

### 29. How are function arguments encoded in the ABI?

Arguments are appended after the 4-byte selector. Static types are encoded in-place as 32-byte words. Dynamic types (`bytes`, `string`, dynamic arrays) store a 32-byte offset in the head section pointing to the actual data in the tail section.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#formal-specification-of-the-encoding

---

### 30. What is the difference between static and dynamic ABI types?

A type is **static** (head-encoded) if its encoding is a fixed length of 32 bytes — the value itself sits inline in the encoded data. A type is **dynamic** if its encoding can vary in length (`bytes`, `string`, arrays of arbitrary size, or any tuple containing a dynamic member); these types store an offset in the head and the actual data in the tail.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#types

---

### 31. What are the elementary (static) ABI types?

- `uint<M>` / `int<M>` — unsigned/signed integers, M in steps of 8 from 8 to 256
- `address` — 20-byte Ethereum address (encoded as `uint160`)
- `bool` — boolean (encoded as `uint8`, 0 or 1)
- `bytes<M>` — fixed-size byte arrays, M from 1 to 32
- `function` — 24-byte value: 20-byte address + 4-byte selector
- Fixed-size arrays `T[k]` where T is itself static

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#types

---

### 32. What are the dynamic ABI types?

- `bytes` — variable-length byte array
- `string` — variable-length UTF-8 string
- `T[]` — dynamically sized array of any type T
- `T[k]` where T is dynamic
- `tuple` (struct) containing at least one dynamic member

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#types

---

### 33. How is a `tuple` type represented in the ABI?

A `tuple` is a sequence of components, each with its own type. In the JSON ABI a function parameter of struct type is represented with `"type": "tuple"` and a `"components"` array listing the member types. In the canonical signature, it appears as `(T1,T2,...)`. A tuple is static if all its components are static; otherwise it is dynamic.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#handling-tuple-types

---

### 34. How does ABI encoding differ between `call` data and `returndata`?

For a function call the encoded data is `selector || encode(args)`. For return data there is no selector prefix — the payload is purely `encode(returnValues)`. Both use identical encoding rules for the values themselves.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#function-selector-and-argument-encoding

---

### 35. What is ABI-packed encoding and how does it differ from standard ABI encoding?

`abi.encodePacked` (Solidity) produces a non-standard, tightly packed encoding where values are concatenated with the minimum number of bytes needed (no padding to 32-byte boundaries, no length prefixes for dynamic types). It is smaller but **not** compatible with standard ABI decoding and can produce hash collisions when multiple dynamic types are packed together. Standard ABI encoding always pads each value to a 32-byte word and includes explicit length fields for dynamic types.

**Source:** https://docs.soliditylang.org/en/latest/abi-spec.html#non-standard-packed-mode
