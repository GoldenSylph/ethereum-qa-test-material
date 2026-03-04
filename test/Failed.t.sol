// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Test} from "forge-std-1.14.0/src/Test.sol";
import {stdError} from "forge-std-1.14.0/src/StdError.sol";
import {Failed} from "../src/Failed.sol";

contract FailedTest is Test {
    Failed internal target;

    function setUp() external {
        target = new Failed();
    }

    // -- revert() variants -----------------------------------------------------

    function test_PlainRevert() external {
        vm.expectRevert();
        target.demoPlainRevert();
    }

    function test_RevertString() external {
        vm.expectRevert("Something went wrong");
        target.demoRevertString();
    }

    function test_RevertSimpleCustomError() external {
        vm.expectRevert(Failed.SimpleError.selector);
        target.demoRevertSimpleCustomError();
    }

    function test_RevertDetailedCustomError() external {
        vm.expectRevert(
            abi.encodeWithSelector(Failed.DetailedError.selector, address(this), uint256(0), "context info")
        );
        target.demoRevertDetailedCustomError();
    }

    // -- require() variants ----------------------------------------------------

    function test_RequireNoMessage() external {
        vm.expectRevert();
        target.demoRequireNoMessage();
    }

    function test_RequireWithMessage() external {
        vm.expectRevert("Requirement not satisfied");
        target.demoRequireWithMessage();
    }

    function test_RequireWithCustomError() external {
        vm.expectRevert(Failed.SimpleError.selector);
        target.demoRequireWithCustomError();
    }

    // -- assert() - Panic(0x01) ------------------------------------------------

    function test_AssertFail() external {
        vm.expectRevert(stdError.assertionError);
        target.demoAssertFail();
    }

    // -- Arithmetic - Panic(0x11) ----------------------------------------------

    function test_ArithmeticOverflow() external {
        vm.expectRevert(stdError.arithmeticError);
        target.demoArithmeticOverflow();
    }

    function test_ArithmeticUnderflow() external {
        vm.expectRevert(stdError.arithmeticError);
        target.demoArithmeticUnderflow();
    }

    // -- Division / modulo by zero - Panic(0x12) -------------------------------

    function test_DivisionByZero() external {
        vm.expectRevert(stdError.divisionError);
        target.demoDivisionByZero();
    }

    function test_ModuloByZero() external {
        vm.expectRevert(stdError.divisionError);
        target.demoModuloByZero();
    }

    // -- Invalid enum conversion - Panic(0x21) ---------------------------------

    function test_InvalidEnumConversion() external {
        vm.expectRevert(stdError.enumConversionError);
        target.demoInvalidEnumConversion();
    }

    // -- Pop empty array - Panic(0x31) -----------------------------------------

    function test_PopEmptyArray() external {
        vm.expectRevert(stdError.popError);
        target.demoPopEmptyArray();
    }

    // -- Array out of bounds - Panic(0x32) -------------------------------------

    function test_ArrayOutOfBounds() external {
        vm.expectRevert(stdError.indexOOBError);
        target.demoArrayOutOfBounds();
    }

    // -- Zero-initialized function pointer - Panic(0x51) ----------------------

    function test_UninitializedFunctionPointer() external {
        vm.expectRevert(stdError.zeroVarError);
        target.demoUninitializedFunctionPointer();
    }
}
