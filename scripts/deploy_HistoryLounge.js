const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("HistoryLounge");
    //const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    const historyContract = await history.attach('0x5f650c9C3DB1bf81C93C3097e8b5d2D42987F441');
    //const historyContract = await history.deploy();
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);
    //f8cb718f37d75c8a9cc33b7cff6206f08633f60b96bdd414e2a54661dd0c9bb0
    // await new Promise(res => setTimeout(res, 1000));
    await historyContract.updateSignerAddress("0x6DC250be548A978f9C3eCe85d2EcecFcD1a0FD5d", true);
    await new Promise(res => setTimeout(res, 5000));
    //await historyContract.updateSecondSignerAddress("0x1B00F7EBf5C6F98B61c327D0dd38787b99266Dfd");
    //await historyContract.addData([accounts[0]], ["loungeId"], ["Test Data"]);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //bscTestnet
    //History Lounge 0x7f1d22c021f76cEA7aabCC1D7FF83c22b4e99e5d
    //History Metastore 0x17e01E0590D49D2ca5668710B027E36cb9B8f58b

    //bscMainnet
    //To be given to UI
    //LoungeContract: 0x5f650c9C3DB1bf81C93C3097e8b5d2D42987F441