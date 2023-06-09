## Socket Gateway Verifier lib
This library is used to verify the socket gateway connection and return common verifirable data.


```sol
 struct SocketRequest {
        uint256 amount;
        address recipient;
        uint256 toChainId;
        address token;
        bytes4 signature; // function signature used
    }

    struct UserRequest {
        uint32 routeId;
        bytes socketRequest;
    }
```

example verifiers can be found in the src/bridges folder

## Installation

```bash
forge install
```


## Tests 

```bash
forge test -vvvv
```

## Example Usage

- example usage can be found in test SocketVerifier.t.sol


All rights reserved.# socket-gateway-verifier
