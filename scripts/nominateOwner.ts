import { SocketVerifier__factory } from "../typechain";

const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

export const nominateOwner = async () => {
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

    // check owner
    const owner = await contract.owner();
    if (owner !== deployer) {
      throw new Error("Owner is not deployer");
    }

    const newNominee = "0xDaeE4D2156DE6fe6f7D50cA047136D758f96A6f0";

    console.log({
      currentOwner: owner,
      newNominee,
      SocketVerifierAddress,
    });

    const tx = await contract.nominateOwner(newNominee);
    const receipt = await tx.wait();

    return {
      success: true,
      receipt,
    };
  } catch (error) {
    console.log(`Error in nominating owner`, error);
    return {
      success: false,
    };
  }
};

nominateOwner()
  .then(() => {
    console.log(`✅ finished running the add verifier`);
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
