// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

/// @title Failed
/// @notice Demonstrates every category of run-time error available in Solidity 0.8+.
/// @dev Each external function is designed to revert unconditionally, illustrating
///      a distinct error kind: plain revert, Error(string), custom errors, assert,
///      arithmetic panics, division panics, enum-conversion panics, array panics,
///      and uninitialized function-pointer panics.
contract Failed {
    // -- Custom error declarations ------------------------------------------

    /// @notice Reverts with no additional data.
    /// @dev Selector: bytes4(keccak256("SimpleError()"))
    error SimpleError();

    /// @notice Reverts carrying structured context about the failure.
    /// @dev Selector: bytes4(keccak256("DetailedError(address,uint256,string)"))
    /// @param caller The address that triggered the revert.
    /// @param value  The ETH value (in wei) attached to the call.
    /// @param reason A human-readable description of the failure.
    error DetailedError(address caller, uint256 value, string reason);

    // -- Supporting state / types ----------------------------------------------

    /// @dev Status enum used solely to demonstrate invalid enum-conversion panics.
    enum Status {
        Active,
        Inactive
    }

    /// @dev Storage array used solely to demonstrate pop-on-empty panics.
    uint256[] internal _storageArray;

    // --------------------------------------------------------------------------
    //  revert() variants
    // --------------------------------------------------------------------------

    /// @notice Reverts with absolutely no return data (empty bytes).
    /// @dev Equivalent to a raw `revert()` opcode; the returndata length is zero.
    function demoPlainRevert() external pure {
        revert();
    }

    /// @notice Reverts with a plain string message, ABI-encoded as Error(string).
    /// @dev The EVM encodes this as abi.encodeWithSignature("Error(string)", message).
    function demoRevertString() external pure {
        revert("Something went wrong");
    }

    /// @notice Reverts with a parameter-less custom error.
    /// @dev Return data equals the 4-byte selector of SimpleError().
    function demoRevertSimpleCustomError() external pure {
        revert SimpleError();
    }

    /// @notice Reverts with a custom error that carries contextual parameters.
    /// @dev The function is payable so that msg.value is accessible.
    ///      Return data is ABI-encoded DetailedError(address,uint256,string).
    function demoRevertDetailedCustomError() external payable {
        revert DetailedError(msg.sender, msg.value, "context info");
    }

    // --------------------------------------------------------------------------
    //  require() variants
    // --------------------------------------------------------------------------

    /// @notice Fails a require with no message, producing empty revert data.
    /// @dev In Solidity >= 0.8.0 a bare require(false) produces zero bytes of
    ///      returndata (not an Error(string) with an empty string).
    function demoRequireNoMessage() external pure {
        require(false);
    }

    /// @notice Fails a require with a string message, producing Error(string).
    /// @dev Internally equivalent to revert("Requirement not satisfied").
    function demoRequireWithMessage() external pure {
        require(false, "Requirement not satisfied");
    }

    /// @notice Fails a require with a custom error (Solidity >= 0.8.26).
    /// @dev The three-argument form require(condition, CustomError()) is only
    ///      available from Solidity 0.8.26 onwards.
    function demoRequireWithCustomError() external pure {
        require(false, SimpleError());
    }

    // --------------------------------------------------------------------------
    //  assert() -> Panic(0x01)
    // --------------------------------------------------------------------------

    /// @notice Trips an assert, producing Panic(0x01).
    /// @dev assert() compiles to the INVALID opcode in older versions; from 0.8.0
    ///      it emits Panic(uint256) with code 0x01 (assertion failure).
    function demoAssertFail() external pure {
        assert(false);
    }

    // --------------------------------------------------------------------------
    //  Arithmetic overflow / underflow -> Panic(0x11)
    // --------------------------------------------------------------------------

    /// @notice Overflows a uint256 in default checked arithmetic, producing Panic(0x11).
    /// @dev Default arithmetic in Solidity 0.8+ is checked; use unchecked{} to opt out.
    /// @return The result of type(uint256).max + 1, which always reverts.
    function demoArithmeticOverflow() external pure returns (uint256) {
        uint256 x = type(uint256).max;
        return x + 1;
    }

    /// @notice Underflows a uint256 in default checked arithmetic, producing Panic(0x11).
    /// @dev Attempting to subtract 1 from 0 wraps in unchecked math but reverts here.
    /// @return The result of 0 - 1, which always reverts.
    function demoArithmeticUnderflow() external pure returns (uint256) {
        uint256 x = 0;
        return x - 1;
    }

    // --------------------------------------------------------------------------
    //  Division / modulo by zero -> Panic(0x12)
    // --------------------------------------------------------------------------

    /// @notice Divides by zero, producing Panic(0x12).
    /// @dev Division-by-zero is not affected by the checked/unchecked context.
    /// @return The result of 1 / 0, which always reverts.
    function demoDivisionByZero() external pure returns (uint256) {
        uint256 x = 1;
        uint256 denominator = 0;
        return x / denominator;
    }

    /// @notice Takes modulo by zero, producing Panic(0x12).
    /// @dev Like division, modulo-by-zero reverts regardless of checked context.
    /// @return The result of 1 % 0, which always reverts.
    function demoModuloByZero() external pure returns (uint256) {
        uint256 x = 1;
        uint256 denominator = 0;
        return x % denominator;
    }

    // --------------------------------------------------------------------------
    //  Invalid enum conversion -> Panic(0x21)
    // --------------------------------------------------------------------------

    /// @notice Converts an out-of-range integer to an enum, producing Panic(0x21).
    /// @dev The compiler inserts a bounds check for every explicit enum cast.
    ///      Status only defines values 0 and 1; casting 99 therefore panics.
    /// @return The Status value for integer 99, which always reverts.
    function demoInvalidEnumConversion() external pure returns (Status) {
        uint8 invalid = 99;
        return Status(invalid);
    }

    // --------------------------------------------------------------------------
    //  .pop() on empty storage array -> Panic(0x31)
    // --------------------------------------------------------------------------

    /// @notice Calls .pop() on an empty storage array, producing Panic(0x31).
    /// @dev _storageArray is never populated, so its length is always zero.
    function demoPopEmptyArray() external {
        _storageArray.pop();
    }

    // --------------------------------------------------------------------------
    //  Array index out of bounds -> Panic(0x32)
    // --------------------------------------------------------------------------

    /// @notice Accesses an out-of-bounds memory array index, producing Panic(0x32).
    /// @dev The compiler emits an index check before every array access.
    ///      arr has length 3; index 10 is out of range.
    /// @return The element at index 10 of a 3-element array, which always reverts.
    function demoArrayOutOfBounds() external pure returns (uint256) {
        uint256[] memory arr = new uint256[](3);
        return arr[10];
    }

    // --------------------------------------------------------------------------
    //  Zero-initialized internal function pointer -> Panic(0x51)
    // --------------------------------------------------------------------------

    /// @notice Calls a zero-initialized internal function pointer, producing Panic(0x51).
    /// @dev Internal function pointers default to zero. Invoking one before
    ///      assigning a target triggers a Panic(0x51) (zero-variable call).
    function demoUninitializedFunctionPointer() external pure {
        function() internal pure fp;
        fp();
    }
}
