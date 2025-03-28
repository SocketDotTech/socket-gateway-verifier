// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {BaseVerifier} from "../BaseVerification.sol";

contract AcrossV3Verification is BaseVerifier {
    struct AcrossBridgeData {
        address[] senderReceiverAddresses; // 0 - sender, 1 - receiver
        address[] inputOutputTokens; // 0 - input token, 1 - output token
        uint256[] outputAmountToChainIdArray; // 0 -output amount, 1 - tochainId
        uint32[] quoteAndDeadlineTimeStamps; // 0 - quoteTimestamp, 1 - fillDeadline
        uint256 bridgeFee; // incase of swap involved in the tx, bridgeFee is deducted from swapped amount
        bytes32 metadata;
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

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
