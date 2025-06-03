export const create3Factory = "0xf2b6544589ab65e731883a0244cbefe5735322c5";

export type VerifierName = "AcrossV3Verification" | "CCTPVerification";

// https://github.com/SocketDotTech/ll-core-v2/blob/main/src/addresses/index.ts
export const routeIdConfigs: Record<
  string,
  Record<VerifierName, number | undefined>
> = {
  avalanche: {
    AcrossV3Verification: undefined, // across not supported on avalanche
    CCTPVerification: 385,
  },
  base: {
    AcrossV3Verification: 411,
    CCTPVerification: 397,
  },
  xdai: {
    AcrossV3Verification: undefined, // across not supported on xdai
    CCTPVerification: undefined, // cctp not supported on xdai
  },
  ethereum: {
    AcrossV3Verification: 429,
    CCTPVerification: 407,
  },
  arbitrum: {
    AcrossV3Verification: 415,
    CCTPVerification: 396,
  },
  opt: {
    AcrossV3Verification: 413,
    CCTPVerification: 396,
  },
  polygon: {
    AcrossV3Verification: 416,
    CCTPVerification: 403,
  },
};
