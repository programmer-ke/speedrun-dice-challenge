import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat/";
import { DiceGame, RiggedRoll } from "../typechain-types";

const deployRiggedRoll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const diceGame: DiceGame = await ethers.getContract("DiceGame");

  await deploy("RiggedRoll", {
    from: deployer,
    log: true,
    args: [diceGame.address],
    autoMine: true,
  });

  const riggedRoll: RiggedRoll = await ethers.getContract("RiggedRoll", deployer);

    // Please replace the text "Your Address" with your own address.
    try {
	await riggedRoll.transferOwnership("0x2Bd5A8D3a93A13642327F2dc6C3dcb4AC90db505");
    } catch (err) {
	console.log(err);
    }
};

export default deployRiggedRoll;

deployRiggedRoll.tags = ["RiggedRoll"];
