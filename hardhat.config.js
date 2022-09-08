require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades')

require("dotenv").config()

// require('@primitivefi/hardhat-dodoc');


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const MAINNET_RPC_URL = "https://polygon-rpc.com/"
const MAINNET_PRIVATE_KEY = process.env.MAINNET_PRIVATE_KEY;

const MUMBAI_RPC_URL = "https://matic-mumbai.chainstacklabs.com";
//const MUMBAI_RPC_URL = "https://rpc-mumbai.maticvigil.com/";
const MUMBAI_PRIVATE_KEY = process.env.MUMBAI_PRIVATE_KEY;

const ROPSTEN_RPC_URL = "https://ropsten.infura.io/v3/9fe1548079c34c6ca0cd0a99d316a91d";
const ROPSTEN_PRIVATE_KEY = process.env.MUMBAI_PRIVATE_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: `https://polygon-mumbai.g.alchemy.com/v2/nnwB44ZrYOrWD_d1DApJk68k20i6Rakh`,
      }
    },
    local: {
      url: 'http://127.0.0.1:8545/'
    },
    mainnet: {
      url: MAINNET_RPC_URL,
      accounts: [MAINNET_PRIVATE_KEY],
      gasPrice: 30000000000,
      // accounts: {
      //   mnemonic: MNEMONIC,
      // },
      saveDeployments: true,
    },
    mumbai: {
      url: MUMBAI_RPC_URL,
      accounts: [MUMBAI_PRIVATE_KEY],
      gasPrice: 34000000000,
      // accounts: {
      //   mnemonic: MNEMONIC,
      // },
      saveDeployments: true,
    },
    ropsten: {
      url: ROPSTEN_RPC_URL,
      accounts: [ROPSTEN_PRIVATE_KEY],
      // accounts: {
      //   mnemonic: MNEMONIC,
      // },
      saveDeployments: true,
    },
  },
  solidity: {
    // version:  "0.7.6",
    compilers: [
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        },
      },
      {
        version: "0.8.2",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        },
      },
      {
        version: "0.7.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        },
      },
    ],
    // overrides: {
    //   "contracts/limitedCollection.sol": {
    //     version: "0.7.0",
    //   }
    // }
  }
}
