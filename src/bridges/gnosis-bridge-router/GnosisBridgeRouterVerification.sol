// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BaseVerifier} from "../BaseVerification.sol";

contract GnosisBridgeRouterVerification is BaseVerifier {
    address public constant NATIVE_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function bridgeERC20To(
        bytes32 metadata,
        address receiverAddress,
        address fromTokenAddress,
        uint256 toChainId,
        uint256 amount
    ) external returns (SocketRequest memory) {
        return SocketRequest({
            amount: amount,
            recipient: receiverAddress,
            toChainId: toChainId,
            token: fromTokenAddress,
            signature: msg.sig
        });
    }

    function bridgeNativeTo(bytes32 metadata, address receiverAddress, uint256 toChainId, uint256 amount)
        external
        returns (SocketRequest memory)
    {
        return SocketRequest({
            amount: amount,
            recipient: receiverAddress,
            toChainId: toChainId,
            token: NATIVE_TOKEN_ADDRESS,
            signature: msg.sig
        });
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
