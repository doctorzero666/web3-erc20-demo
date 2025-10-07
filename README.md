🪙 ERC20 Token Development and Deployment Guide

Author: Zhichao Jiang
Project: MyToken (ERC20 Demo)
Goal: Build, test locally, deploy to Sepolia test network, and verify on Etherscan.

⸻

🚀 1. Project Setup

1️⃣ Environment Preparation

Use nvm to manage Node.js versions:

nvm install 22
nvm use 22

Verify:

node -v
npm -v

✅ Hardhat v3 requires Node ≥ 22.10.

⸻

2️⃣ Initialize the Project

mkdir web3 && cd web3
npm init -y
npm install --save-dev hardhat@^2.22.6
npx hardhat

Choose:

> Create a JavaScript project


⸻

3️⃣ Install Dependencies

npm install @openzeppelin/contracts dotenv


⸻

4️⃣ Project Structure

web3/
├── contracts/          # Smart contracts  
├── scripts/            # Deployment scripts  
├── test/               # Test files  
├── hardhat.config.js   # Hardhat config  
├── .env                # Environment variables  
└── package.json


⸻

🧩 2. ERC20 Smart Contract

File: contracts/MyToken.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }
}

💡 Notes
	•	Uses OpenZeppelin ERC20 and Ownable modules
	•	initialSupply is the starting token supply (e.g., 1000)
	•	Default decimals() = 18

⸻

⚙️ 3. Hardhat Configuration

File: hardhat.config.js

require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    localhost: { url: "http://127.0.0.1:8545" },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

File: .env

SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
PRIVATE_KEY=0xYOUR_WALLET_PRIVATE_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY


⸻

🔐 4. Encrypting Your Environment Variables (Secure .env.enc)

To protect private keys and API keys when sharing code, you can encrypt your .env file using dotenvx.

1️⃣ Install dotenvx

npm install -g dotenvx

2️⃣ Encrypt your .env

dotenvx encrypt

You’ll be prompted for an encryption password and an .env.enc file will be created.
Keep your password safe (never store it in the repo).

3️⃣ Update .gitignore

.env
!*.env.enc

4️⃣ Run scripts securely (without modifying code)

dotenvx run -- npx hardhat run scripts/deploy.js --network sepolia

or add these npm scripts in package.json:

"scripts": {
  "encrypt": "dotenvx encrypt",
  "decrypt": "dotenvx decrypt",
  "deploy:secure": "dotenvx run -- npx hardhat run scripts/deploy.js --network sepolia",
  "verify:secure": "dotenvx run -- npx hardhat verify --network sepolia"
}

💡 No code changes are needed — your process.env variables are loaded automatically at runtime.

⸻

🧠 5. Deployment Script

File: scripts/deploy.js

const hre = require("hardhat");

async function main() {
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy(1000);
  await myToken.waitForDeployment();
  console.log(`MyToken deployed to: ${myToken.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


⸻

🧪 6. Local Testing

1️⃣ Start a Local Blockchain

npx hardhat node

2️⃣ Deploy to Local Network

npx hardhat run scripts/deploy.js --network localhost

Output example:

MyToken deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3

3️⃣ Open Hardhat Console

npx hardhat console --network localhost

4️⃣ Interact with the Contract

const MyToken = await ethers.getContractFactory("MyToken");
const myToken = await MyToken.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");

(await myToken.name());         // "MyToken"
(await myToken.symbol());       // "MTK"
(await myToken.totalSupply());  // "1000000000000000000000"

const [owner, addr1] = await ethers.getSigners();
await myToken.transfer(addr1.address, ethers.parseUnits("100", 18));
(await myToken.balanceOf(addr1.address)).toString();


⸻

🌐 7. Deploy to Sepolia Test Network

1️⃣ Deploy

dotenvx run -- npx hardhat run scripts/deploy.js --network sepolia

Output:

MyToken deployed to: 0xe47B78a3a4DFDD1635A7334629C1Df94A7635273

2️⃣ Verify on Etherscan

dotenvx run -- npx hardhat verify --network sepolia \
  --contract contracts/MyToken.sol:MyToken \
  0xe47B78a3a4DFDD1635A7334629C1Df94A7635273 \
  1000

Expected output:

Successfully verified contract MyToken on the block explorer.


⸻

🔍 8. Interact on Etherscan

Contract URL:
👉 https://sepolia.etherscan.io/address/0xe47B78a3a4DFDD1635A7334629C1Df94A7635273#code

✅ Read Contract
	•	Open Read Contract
	•	Find balanceOf(address)
	•	Input your address → Query
	•	Value is in wei ( 100000000000000000000 = 100 MTK )

✅ Write Contract
	•	Click Connect to Web3 to link MetaMask
	•	Find transfer(address,uint256)
	•	Input destination address and amount (e.g., 10 MTK → 10000000000000000000)
	•	Sign and submit the transaction

⸻

⚠️ 9. Common Errors and Fixes

Error	Cause	Fix
Error HH606	Solidity version mismatch	Ensure pragma and config match
Bytecode mismatch	Wrong verification path	Add --contract contracts/MyToken.sol:MyToken
Invalid account	Malformed private key	No quotes or spaces in .env
npx not found	nvm not loaded	source ~/.zshrc
Etherscan verification fail	API key not set	Check .env variables


⸻

🏁 10. Summary

You’ve successfully completed:
	1.	✅ Writing and testing an ERC20 contract
	2.	✅ Deploying to Sepolia test network
	3.	✅ Etherscan verification
	4.	✅ Secure environment variable management with dotenvx

🎯 Your ERC20 token is now a real on-chain asset, verified and interactable via Etherscan.

⸻

