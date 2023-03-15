const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("History");
    //const historyContract = await history.deploy();
    const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    // await new Promise(res => setTimeout(res, 1000));
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);

    await historyContract.addSigner("0x7C56B1f449A61AE11D694AAa545B0F8905E4C818");
    // await new Promise(res => setTimeout(res, 1000));
    //await historyContract.addData(accounts[0], 1, "Hello");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })