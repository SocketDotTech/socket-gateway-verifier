import { SocketVerifier__factory } from "../typechain";
import { routeIdConfigs, VerifierName } from "./config";
import { confirm } from "./utils";
import { ethers } from "hardhat";

const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

export const addVerifier = async () => {
  try {
    const { network } = hre;
    const networkName = network.name;
    const [deployer] = await ethers.getSigners();

    const networkFilePath = path.join(
      __dirname,
      `../deployments/${networkName}.json`
    );
    // check if the contract is already deployed in deployments folder in json
    let deployment_json = undefined;
    deployment_json = fs.readFileSync(networkFilePath, "utf-8");
    const deployment = JSON.parse(deployment_json);
    const SocketVerifierAddress = deployment?.SocketVerifier;
    if (!SocketVerifierAddress) {
      throw new Error("SocketVerifier not deployed");
    }

    const contract = SocketVerifier__factory.connect(
      SocketVerifierAddress,
      deployer
    );

    // check owner
    const owner = await contract.owner();
    if (owner !== deployer.address) {
      throw new Error("Owner is not deployer");
    }

    // config
    const VerifierName: VerifierName = "AcrossV3Verification";
    // const VerifierName = "CCTPVerification";
    const verifierAddress = deployment[VerifierName];
    if (!verifierAddress) {
      throw new Error(`${VerifierName} not deployed`);
    }
    // @note change before running
    const routeId = routeIdConfigs[networkName][VerifierName];
    if (!routeId) {
      throw new Error("Route ID is not configured");
    }

    // check if the verifier is already added
    const currentVerifierAddress = await contract.routeIdsToVerifiers(routeId);
    if (
      currentVerifierAddress.toLowerCase() === verifierAddress.toLowerCase()
    ) {
      throw new Error("Verifier is already added");
    }

    console.log({
      routeId,
      networkName,
      VerifierName,
      verifierAddress,
      SocketVerifierAddress,
    });
    await confirm("Are you sure to add this verifier? (y/n)");

    console.log("🔌 Adding verifier");
    const tx = await contract.addVerifier(routeId, verifierAddress);
    console.log("tx", tx.hash);
    const receipt = await tx.wait();
    console.log("✅ Verifier added", tx.hash);

    return {
      success: true,
      receipt,
    };
  } catch (error) {
    console.log(`❌ Error in adding verifier`, error);
    return {
      success: false,
    };
  }
};

addVerifier()
  .then(() => {
    console.log(`✅ finished running the add verifier`);
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
