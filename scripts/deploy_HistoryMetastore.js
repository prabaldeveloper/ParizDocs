const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("HistoryMetastore");
    //const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    //const historyContract = await history.deploy();
    const historyContract = await history.attach("0x9AF0e7261256250FE46230ecb754429de9DFBB8E");
    await historyContract.deployed();
    console.log("History Contract", historyContract.address);

    await new Promise(res => setTimeout(res, 1000));
    await historyContract.updateSignerAddress('0x19Ed4Cd4d35888eD17624fb97942B276b65c8c56', true);
    //await historyContract.updateSecondSignerAddress("0x8824F894701Dc63e3531b2e1c80CdcbD75D3D5C0");
    //await historyContract.addData([accounts[0]], ["metastoreId"], ["Test Data"]);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })




    //https://polygonscan.com/address/0x311e070B4aC4dc99F1f983eD74Aee7667F91d47C#code

    //bscTestnet
    //History Metastore 0x17e01E0590D49D2ca5668710B027E36cb9B8f58b
    

    //mainnet
    //0xe8625254b22b24E871CD7bcAd229e9A8a174159B

    //bscmainnet
    //To be Given to UI
    //ShoppingContract: 0x9AF0e7261256250FE46230ecb754429de9DFBB8E