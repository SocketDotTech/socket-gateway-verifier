
import { ethers, run } from 'hardhat';
import { create3Factory } from './config';
import Create3Abi from '../abi/create3/Create3Factory.json';
const hre = require("hardhat");
const CONTRACT_NAME = "SocketVerifier";
const fs = require('fs');
const path = require('path');
export const deploy = async () => {
  try {
    const { deployments, getNamedAccounts, network} = hre;
    const networkName = network.name;
    const { deployer } = await getNamedAccounts();
    const owner = deployer;

    console.log("deployer ", deployer);
    console.log("owner", owner);


    const networkFilePath = path.join(
      __dirname,
      `../deployments/${networkName}.json`
    );
    // check if the contract is already deployed in deployments folder in json
    let deployment_json = undefined;
    deployment_json = fs.readFileSync(networkFilePath, "utf-8");
    const deployment = JSON.parse(deployment_json);


    if (deployment?.[CONTRACT_NAME]) {
      console.log(
        "Socket Verifier already deployed at ",
        deployment?.[CONTRACT_NAME]
      );
      return {
        success: true,
        address: deployment?.[CONTRACT_NAME],
      };
    }
  
    const factory = await ethers.getContractFactory(`SocketVerifier`);
    // deployer singer
    const deployerSigner = await ethers.provider.getSigner(deployer);

    const create3FactoryContract = await new ethers.Contract(create3Factory, Create3Abi, deployerSigner);
    // find creation code for the contract
    const creationCode = factory.bytecode;
    // add arguments to the creation code
    const creationCodeWithArgs = creationCode + ethers.utils.defaultAbiCoder.encode(['address', 'address'], [owner, '0x3a23F943181408EAC424116Af7b7790c94Cb97a5']).slice(2);
    // find salt for the contract
    const salt = ethers.utils.formatBytes32String("L71"+CONTRACT_NAME);

    const tx = await create3FactoryContract.deploy(salt, creationCodeWithArgs );
    const receipt = await tx.wait();
    const deployedAddress = await create3FactoryContract.getDeployed(owner, salt);
    console.log("deployedAddress", deployedAddress);
    console.log(`about to deploy ${CONTRACT_NAME}`);


    deployment[CONTRACT_NAME] = deployedAddress;
    fs.writeFileSync(
      networkFilePath,
      JSON.stringify(deployment, null, 2),
      "utf-8"
    );

    await run("verify:verify", {
        address: deployedAddress,
        constructorArguments: [owner, '0x3a23F943181408EAC424116Af7b7790c94Cb97a5'],
    })

    return {
      success: true,
      address: deployedAddress,
    }


  } catch (error) {
    console.log(`Error in deploying ${CONTRACT_NAME}`, error);
    return {
      success: false,
    };
  }
};

deploy()
  .then(() => {
    console.log(`✅ finished running the deployment of ${CONTRACT_NAME}`);
    process.exit(0);
  })
  .catch(err => {
    console.error(err);
    process.exit(1);
  });

