// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {BaseVerifier} from "../BaseVerification.sol";

contract AcrossV3Verification is BaseVerifier {

    address public constant NATIVE_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    struct AcrossBridgeDataNoToken {
        address[] senderReceiverAddresses; // 0 - sender, 1 - receiver
        address outputToken;
        uint256 toChainId;
        uint32[] quoteAndDeadlineTimeStamps; // 0 - quoteTimestamp, 1 - fillDeadline
        uint256 bridgeFee; // Absolute fee in input token decimals
        uint8 inputTokenDecimals; // Decimals of the input token (from swap or transfer)
        uint8 outputTokenDecimals; // Decimals of the output token on destination
        bytes32 metadata;
        bytes message; // Message for composable bridging
    }

    struct AcrossBridgeData {
        address[] senderReceiverAddresses; // 0 - sender, 1 - receiver
        address[] inputOutputTokens; // 0 - input token, 1 - output token
        uint256 toChainId;
        uint32[] quoteAndDeadlineTimeStamps; // 0 - quoteTimestamp, 1 - fillDeadline
        uint256 bridgeFee; // Absolute fee in input token decimals
        uint8 inputTokenDecimals; // Decimals of the input token
        uint8 outputTokenDecimals; // Decimals of the output token on destination
        bytes32 metadata;
        bytes message; // Message for composable bridging
    }

    function bridgeERC20To(
        uint256 amount,
        AcrossBridgeData memory acrossBridgeData
    ) external returns (SocketRequest memory) {
        return
            SocketRequest({
                amount: amount,
                recipient: acrossBridgeData.senderReceiverAddresses[1],
                toChainId: acrossBridgeData.outputAmountToChainIdArray[1],
                token: acrossBridgeData.inputOutputTokens[0],
                signature: msg.sig
            });
    }

    function bridgeNativeTo(
        uint256 amount,
        AcrossBridgeDataNoToken memory acrossBridgeData
    ) external returns (SocketRequest memory) {
        return
            SocketRequest({
                amount: amount,
                recipient: acrossBridgeData.senderReceiverAddresses[1],
                toChainId: acrossBridgeData.outputAmountToChainIdArray[1],
                token: NATIVE_TOKEN_ADDRESS,
                signature: msg.sig
            });
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
