const hre = require("hardhat");

const main = async () => {
  const AssignmentContract = await hre.ethers.getContractFactory("AssignmentContract");
  const assignmentContract = await AssignmentContract.deploy();

  await assignmentContract.deployed();

  console.log(
    "AssignmentContract deployed to: ", assignmentContract.address
  );
}


const runMain = async () => {
  try {
      await main();
      process.exit(0);
  } catch (error) {
      console.error(error);
      process.exit(1);
  }
}

runMain();