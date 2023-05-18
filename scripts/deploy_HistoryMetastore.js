const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("HistoryMetastore");
    //const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    const historyContract = await history.deploy();
    //const historyContract = await history.attach("0xbC8cce756D8072ef4eE6e657666174363C39Ddf7");
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);

    // await new Promise(res => setTimeout(res, 1000));
    // await historyContract.addSigner('0x9E652304575EB70482Dc0850cB7e69c1b23b2A9c');
    //await historyContract.addData(accounts[0], 1, "Hello");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })




    //https://polygonscan.com/address/0x311e070B4aC4dc99F1f983eD74Aee7667F91d47C#code