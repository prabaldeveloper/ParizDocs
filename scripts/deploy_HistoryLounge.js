const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("HistoryLounge");
    //const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    //const historyContract = await history.attach('0xF25B6897442d57452437086477C8478be9a357Fd');
    const historyContract = await history.deploy();
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);
    //f8cb718f37d75c8a9cc33b7cff6206f08633f60b96bdd414e2a54661dd0c9bb0
    // await new Promise(res => setTimeout(res, 1000));
    //await historyContract.addSigner('0x756bCa457364c750FEECB127C0e49B01826BF7a3');
    // await historyContract.addData(accounts[0], 1, "Hello");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })