// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SocketVerifier.sol";
import {HopL2Verifier} from "../src/bridges/hop/HopL2Verification.sol";
import {AnyswapV4Verification} from "../src/bridges/anyswap/AnyswapV4Verification.sol";
import {AcrossV3Verification} from "../src/bridges/across/AcrossV3Verification.sol";
import {CCTPVerification} from "../src/bridges/cctp/CCTPVerification.sol";
contract SocketVerifierTest is Test {
    SocketVerifier public socketVerifier;

    uint32 public constant HOP_L2_ROUTE_ID = 19;
    uint32 public constant ANYSWAP_V4_ROUTE_ID = 6;
    uint32 public constant ACROSS_V3_ROUTE_ID = 429;
    uint32 public constant CCTP_ROUTE_ID = 396;
    // bridges
    HopL2Verifier public hopVerifier = new HopL2Verifier();
    AnyswapV4Verification public anyswapVerifier = new AnyswapV4Verification();
    AcrossV3Verification public acrossV3Verifier = new AcrossV3Verification();
    CCTPVerification public cctpVerifier = new CCTPVerification();

    function setUp() public {
        socketVerifier = new SocketVerifier(address(this), 0x3a23F943181408EAC424116Af7b7790c94Cb97a5);
        socketVerifier.addVerifier(HOP_L2_ROUTE_ID, address(hopVerifier));
        socketVerifier.addVerifier(ANYSWAP_V4_ROUTE_ID, address(anyswapVerifier));
        socketVerifier.addVerifier(ACROSS_V3_ROUTE_ID, address(acrossV3Verifier));
        socketVerifier.addVerifier(CCTP_ROUTE_ID, address(cctpVerifier));
    }

    function testHopERC20Verification() public {
        bytes
            memory exampledata = hex"00000013b8fc75e100000000000000000000000032a80b98e33c3a0e57d635c56707208d29f970a20000000000000000000000002791bca1f2de4661ed88a30c99a7a9449aa8417400000000000000000000000076b22b8c1079a44f1211d867d68b1eda76a635a700000000000000000000000000000000000000000000000000000000004c4b400000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000000003d54c0000000000000000000000000000000000000000000000000000000000480c3b00000000000000000000000000000000000000000000000000000187d705ae4b0000000000000000000000000000000000000000000000000000000000480c3b00000000000000000000000000000000000000000000000000000187d705ae4b00000000000000000000000000000000000000000000000000000000000000cd";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, HOP_L2_ROUTE_ID);

        SocketVerifier.SocketRequest memory _expectedSocketRequest = SocketVerifier.SocketRequest({
            amount: 5000000,
            recipient: 0x32a80b98e33c3A0E57D635C56707208D29f970a2,
            toChainId: 100,
            token: 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
            signature: 0xb8fc75e1
        });

        SocketVerifier.UserRequestValidation memory _expectedUserRequestValidation = SocketVerifier
            .UserRequestValidation(HOP_L2_ROUTE_ID, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(exampledata, _expectedUserRequestValidation);
    }

    function testAnyswapERC20Verifier() public {
        bytes
            memory exampledata = hex"00000006f443318a0000000000000000000000000000000000000000000000000000000005390cf2000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e1b5ab67af1c99f8c7ebc71f41f75d4d6211e530000000000000000000000002791bca1f2de4661ed88a30c99a7a9449aa84174000000000000000000000000d69b31c3225728cc57ddaf9be532a4ee1620be51";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, ANYSWAP_V4_ROUTE_ID);

        SocketVerifier.SocketRequest memory _expectedSocketRequest = SocketVerifier.SocketRequest({
            amount: 87624946,
            recipient: 0x0E1B5AB67aF1c99F8c7Ebc71f41f75D4D6211e53,
            toChainId: 10,
            token: 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
            signature: 0xf443318a
        });

        SocketVerifier.UserRequestValidation memory _expectedUserRequestValidation = SocketVerifier
            .UserRequestValidation(ANYSWAP_V4_ROUTE_ID, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(exampledata, _expectedUserRequestValidation);
    }

    function testAcrossV3ERC20Verifier() public {
        bytes
            memory exampledata = hex"000001ad792ebcb90000000000000000000000000000000000000000000000000000000005f5e100000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000001e00000000000000000000000000000000000000000000000000000000000002a1f00000000000000000000000000000000000000000000000000000000000000cd0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000daee4d2156de6fe6f7d50ca047136d758f96a6f0000000000000000000000000daee4d2156de6fe6f7d50ca047136d758f96a6f00000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000003c499c542cef5e3811e1192ce70d8cc03d5c335900000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000005f5b6e1000000000000000000000000000000000000000000000000000000000000008900000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000067e68cff0000000000000000000000000000000000000000000000000000000067e6e105d00dfeeddeadbeef765753be7f7a64d5509974b0d678e1e3149b02f4";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, ACROSS_V3_ROUTE_ID);

        SocketVerifier.SocketRequest memory _expectedSocketRequest = SocketVerifier.SocketRequest({
            amount: 100000000,
            recipient: 0xDaeE4D2156DE6fe6f7D50cA047136D758f96A6f0,
            toChainId: 137,
            token: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            signature: 0x792ebcb9
        });

        SocketVerifier.UserRequestValidation memory _expectedUserRequestValidation = SocketVerifier
            .UserRequestValidation(ACROSS_V3_ROUTE_ID, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(exampledata, _expectedUserRequestValidation);
    }

    function testCCTPERC20Verifier() public {
        bytes
            memory exampledata = hex"0000018cb7dfe9d000000000000000000000000000000000000000000000000000000000004c4b400000000000000000000000000000000000000000000000000000000000001b3b000000000000000000000000daee4d2156de6fe6f7d50ca047136d758f96a6f0000000000000000000000000af88d065e77c8cc2239327c5edb3a432268e5831000000000000000000000000000000000000000000000000000000000000210500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000030d40";
        // should not throw errors
        socketVerifier.validateRotueId(exampledata, CCTP_ROUTE_ID);

        SocketVerifier.SocketRequest memory _expectedSocketRequest = SocketVerifier.SocketRequest({
            amount: 5000000,
            recipient: 0xDaeE4D2156DE6fe6f7D50cA047136D758f96A6f0,
            toChainId: 8453,
            token: 0xaf88d065e77c8cC2239327C5EDb3A432268e5831,
            signature: 0xb7dfe9d0
        });

        SocketVerifier.UserRequestValidation memory _expectedUserRequestValidation = SocketVerifier
            .UserRequestValidation(CCTP_ROUTE_ID, _expectedSocketRequest);
        socketVerifier.validateSocketRequest(exampledata, _expectedUserRequestValidation);
    }
}
