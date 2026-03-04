// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import { Script, console } from "forge-std-1.14.0/src/Script.sol";
import { Failed } from "../src/Failed.sol";

/// @notice Deploys the Failed contract and logs the address.
contract FailedScript is Script {
    function run() public returns (Failed deployed) {
        vm.startBroadcast();
        deployed = new Failed();
        vm.stopBroadcast();

        console.log("Failed contract deployed at:", address(deployed));
    }
}
