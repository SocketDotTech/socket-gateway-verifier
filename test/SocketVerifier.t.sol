// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SocketVerifier.sol";
import "../src/bridges/hop/HopL2Verification.sol";
import "../src/bridges/anyswap/AnyswapV4Verification.sol";

contract SocketVerifierTest is Test {
    SocketVerifier public socketVerifier;
    // bridges
    HopL2Verifier public hopVerifier = new HopL2Verifier();
    AnyswapV4Verification public anyswapVerifier = new AnyswapV4Verification();

    function setUp() public {
        socketVerifier = new SocketVerifier(
            address(this),
            0x3a23F943181408EAC424116Af7b7790c94Cb97a5
        );
        socketVerifier.addVerifier(19, address(hopVerifier));
        socketVerifier.addVerifier(6, address(anyswapVerifier));
    }

    function testHopERC20Verification() public {
        bytes
            memory exampledata = hex"00000013b8fc75e100000000000000000000000032a80b98e33c3a0e57d635c56707208d29f970a20000000000000000000000002791bca1f2de4661ed88a30c99a7a9449aa8417400000000000000000000000076b22b8c1079a44f1211d867d68b1eda76a635a700000000000000000000000000000000000000000000000000000000004c4b400000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000000003d54c0000000000000000000000000000000000000000000000000000000000480c3b00000000000000000000000000000000000000000000000000000187d705ae4b0000000000000000000000000000000000000000000000000000000000480c3b00000000000000000000000000000000000000000000000000000187d705ae4b00000000000000000000000000000000000000000000000000000000000000cd";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, 19);

        SocketVerifier.SocketRequest
            memory _expectedSocketRequest = SocketVerifier.SocketRequest(
                5000000,
                0x32a80b98e33c3A0E57D635C56707208D29f970a2,
                100,
                0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
                0xb8fc75e1
            );

        SocketVerifier.UserRequestValidation
            memory _expectedUserRequestValidation = SocketVerifier
                .UserRequestValidation(19, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(
            exampledata,
            _expectedUserRequestValidation
        );
    }

    function testAnyswapERC20Verifier() public {
        bytes
            memory exampledata = hex"00000006f443318a0000000000000000000000000000000000000000000000000000000005390cf2000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e1b5ab67af1c99f8c7ebc71f41f75d4d6211e530000000000000000000000002791bca1f2de4661ed88a30c99a7a9449aa84174000000000000000000000000d69b31c3225728cc57ddaf9be532a4ee1620be51";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, 6);

        SocketVerifier.SocketRequest
            memory _expectedSocketRequest = SocketVerifier.SocketRequest(
                87624946,
                0x0E1B5AB67aF1c99F8c7Ebc71f41f75D4D6211e53,
                10,
                0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
                0xf443318a
            );

        SocketVerifier.UserRequestValidation
            memory _expectedUserRequestValidation = SocketVerifier
                .UserRequestValidation(6, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(
            exampledata,
            _expectedUserRequestValidation
        );
    }
}
