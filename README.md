# Ethereum QA Test Material

Solidity error-type reference contract, built with Foundry.

## Contract

| Contract | Description |
|---|---|
| `Failed` | Demonstrates every category of run-time error in Solidity 0.8+. Each external function is designed to revert unconditionally via a distinct mechanism. |

### Error types covered

| Function | Error type | Panic code |
|---|---|---|
| `demoPlainRevert` | `revert()` — empty return data | — |
| `demoRevertString` | `revert("…")` — `Error(string)` | — |
| `demoRevertSimpleCustomError` | Custom error, no parameters | — |
| `demoRevertDetailedCustomError` | Custom error with parameters | — |
| `demoRequireNoMessage` | `require(false)` — empty return data | — |
| `demoRequireWithMessage` | `require(false, "…")` — `Error(string)` | — |
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

> Answers are in `ANSWERS.md` (git-ignored).

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


