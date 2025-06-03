import { SocketVerifier__factory } from "../typechain";

const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

export const claimOwner = async () => {
  try {
    const { getNamedAccounts, network } = hre;
    const networkName = network.name;
    const { deployer } = await getNamedAccounts();

    console.log("deployer ", deployer);

    const networkFilePath = path.join(
      __dirname,
      `../deployments/${networkName}.json`
    );
    // check if the contract is already deployed in deployments folder in json
    let deployment_json = undefined;
    deployment_json = fs.readFileSync(networkFilePath, "utf-8");
    const deployment = JSON.parse(deployment_json);
    const SocketVerifierAddress = deployment?.SocketVerifier;

    const contract = SocketVerifier__factory.connect(
      SocketVerifierAddress,
      deployer
    );

    // check nominee
    const owner = await contract.owner();
    const nominee = await contract.nominee();
    if (nominee !== deployer) {
      throw new Error("Nominee is not deployer");
    }

    console.log({
      currentOwner: owner,
      nominee,
      SocketVerifierAddress,
    });

    const tx = await contract.claimOwner();
    const receipt = await tx.wait();

    return {
      success: true,
      receipt,
    };
  } catch (error) {
    console.log(`Error in claiming owner`, error);
    return {
      success: false,
    };
  }
};

claimOwner()
  .then(() => {
    console.log(`✅ finished running the add verifier`);
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
