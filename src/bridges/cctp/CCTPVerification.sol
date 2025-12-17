// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {BaseVerifier} from "../BaseVerification.sol";

contract CCTPVerification is BaseVerifier {
    function bridgeERC20To(
        uint256 amount,
        bytes32 metadata,
        address receiverAddress,
        address token,
        uint256 toChainId,
        uint32 destinationDomain,
        uint256 feeAmount
    ) external returns (SocketRequest memory) {
        return
            SocketRequest({
                amount: amount,
                recipient: receiverAddress,
                toChainId: toChainId,
                token: token,
                signature: msg.sig
            });
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
