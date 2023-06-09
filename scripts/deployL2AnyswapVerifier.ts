import fs from "fs";
import { ethers, run } from "hardhat";
import path from "path";

const hre = require("hardhat");
const CONTRACT_NAME = "AnyswapV4Verification";

export const deployAnyswapV6Verification= async () => {
  try {
    const { deployments, getNamedAccounts, network } = hre;
    const { deployer } = await getNamedAccounts();
    const owner = deployer;
    const networkName = network.name;
    const networkFilePath = path.join(
      __dirname,
      `../deployments/${networkName}.json`
    );
    // check if the contract is already deployed in deployments folder in json
    let deployment_json = undefined;
    deployment_json = fs.readFileSync(networkFilePath, "utf-8");
    const deployment = JSON.parse(deployment_json);


    const factory = await ethers.getContractFactory(CONTRACT_NAME);
    const Contract = await factory.deploy();
    console.log(`about to deploy ${CONTRACT_NAME}`);
    await Contract.deployed();
    console.log(`${CONTRACT_NAME} deployed to:`, Contract.address);

    // save the contract address in deployments folder
    const newDeployment = {
      ...deployment,
      [CONTRACT_NAME]: Contract.address,
    };


    fs.writeFileSync(
      networkFilePath,
      JSON.stringify(newDeployment, null, 2),
      "utf-8"
    );

    // verify the contract on etherscan
    await run("verify:verify", {
      address: Contract.address,
      constructorArguments: [
      ],
    });

    return {
      success: true,
      address: Contract.address,
    };
  } catch (error) {
    console.log(`Error in deploying ${CONTRACT_NAME}`, error);
    return {
      success: false,
    };
  }
};

deployAnyswapV6Verification()
  .then(() => {
    console.log(`✅ finished running the deployment of ${CONTRACT_NAME}`);
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
