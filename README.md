# Ethereum QA Test Material

Solidity error-type reference contract, built with Foundry.

## Contract

| | |
|---|---|
| **Network** | Base Sepolia |
| **Address** | [`0x3acce4e3066b49bf1aa33c01579400f7877c27fe`](https://sepolia.basescan.org/address/0x3acce4e3066b49bf1aa33c01579400f7877c27fe#code) |

| Contract | Description |
|---|---|
| `Failed` | Demonstrates every category of run-time error in Solidity 0.8+. Each external function is designed to revert unconditionally via a distinct mechanism. |

### Error types covered

| Function | Error type | Panic code |
|---|---|---|
| `demoPlainRevert` | `revert()` — empty return data | — |
| `demoRevertString` | `revert("...")` — `Error(string)` | — |
| `demoRevertSimpleCustomError` | Custom error, no parameters | — |
| `demoRevertDetailedCustomError` | Custom error with parameters | — |
| `demoRequireNoMessage` | `require(false)` — empty return data | — |
| `demoRequireWithMessage` | `require(false, "...")` — `Error(string)` | — |
| `demoRequireWithCustomError` | `require(false, CustomError())` (Solidity >= 0.8.26) | — |
| `demoAssertFail` | `assert(false)` | `0x01` |
| `demoArithmeticOverflow` | `uint256.max + 1` | `0x11` |
| `demoArithmeticUnderflow` | `0 - 1` (uint256) | `0x11` |
| `demoDivisionByZero` | `x / 0` | `0x12` |
| `demoModuloByZero` | `x % 0` | `0x12` |
| `demoInvalidEnumConversion` | `Status(99)` | `0x21` |
| `demoPopEmptyArray` | `.pop()` on empty storage array | `0x31` |
| `demoArrayOutOfBounds` | `arr[10]` on a 3-element array | `0x32` |
| `demoUninitializedFunctionPointer` | Calling a zero-initialized function pointer | `0x51` |

## Development

```shell
forge build
forge test
forge fmt
```

## Deploy

```shell
forge script script/Failed.s.sol:FailedScript \
  --rpc-url <RPC_URL> \
  --private-key <PRIVATE_KEY> \
  --broadcast \
  --verify \
  --etherscan-api-key <ETHERSCAN_API_KEY>
```

## Questions

> Answers are in [`ANSWERS.md`](./ANSWERS.md).

### EVM

1. What is the Ethereum Virtual Machine (EVM)?
2. Why must EVM execution be deterministic?
3. What is gas in Ethereum?

### Rollups

4. What is a rollup in Ethereum scaling?
5. What role does Ethereum L1 play in rollups?

### ZK Rollups

6. What is a ZK-rollup?
7. What is a validity proof in ZK-rollups?
8. Why do ZK-rollups not require a dispute period?
9. What data do ZK-rollups publish to Ethereum?
10. What is the key difference between ZK-rollups and Optimistic rollups?

### Account Abstraction

11. What problem does account abstraction attempt to solve in Ethereum?
12. What is EIP-4337?
13. What is a UserOperation in EIP-4337?
14. What is the role of a bundler in EIP-4337?
15. What is EIP-7702?
16. What capability does EIP-7702 enable for EOAs?

### Foundry cast

17. What is `cast` and what is its primary purpose in the Foundry toolkit?
18. How do you call a read-only contract function with `cast` without spending gas?
19. How do you send a state-changing transaction to a contract with `cast`?
20. How do you compute the 4-byte selector for a function signature with `cast`?
21. How do you decode ABI-encoded calldata using `cast`?
22. How do you decode ABI-encoded return data using `cast`?
23. How do you read a raw storage slot from a deployed contract with `cast`?
24. How do you retrieve the ABI of a verified contract as a Solidity interface with `cast`?
25. How do you convert a value between units (e.g. ether to wei) with `cast`?
26. How does `cast run` assist a QA engineer in debugging a historical transaction?

### ABI

27. What is the ABI in Ethereum?
28. What is a function selector and how is it derived?
29. How are function arguments encoded in the ABI?
30. What is the difference between static and dynamic ABI types?
31. What are the elementary (static) ABI types?
32. What are the dynamic ABI types?
33. How is a `tuple` type represented in the ABI?
34. How does ABI encoding differ between `call` data and `returndata`?
35. What is ABI-packed encoding and how does it differ from standard ABI encoding?


