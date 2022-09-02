const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("History");
    const historyContract = await history.deploy();
    await new Promise(res => setTimeout(res, 1000));
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);

    await new Promise(res => setTimeout(res, 1000));
    await historyContract.addData(accounts[0], 1, "Hello");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })