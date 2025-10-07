const hre = require("hardhat");

async function main() {
  // 获取合约工厂
  const MyToken = await hre.ethers.getContractFactory("MyToken");

  // 部署，传入初始供应量（比如 1000）
  const myToken = await MyToken.deploy(1000);

  // 等待部署完成
  await myToken.waitForDeployment();

  console.log("MyToken deployed to:", await myToken.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});