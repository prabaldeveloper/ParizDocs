const { ethers } = require("hardhat");
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const history = await hre.ethers.getContractFactory("History");
    //const historyContract = await history.deploy();
    //const historyContract = await upgrades.deployProxy(history, {initializer: 'initialize'});
    const historyContract = await history.attach("0xd11b6e79f41E9f8b619458Ad6a07a555068044d3");
    // await new Promise(res => setTimeout(res, 1000));
    //await historyContract.deployed();
    console.log("History Contract", historyContract.address);

    //await historyContract.addSigner("0x3B2091278d903435232e8E0F3F364A4e9b9F670C"); // for testnet
    await historyContract.addSigner("0x70C055E24e4Cfd89Cbde07851da62d5c6F9054a2"); // for mainnet
    //await historyContract.addSigner("0x9FbF53a6C8B5762EB1F77b59100b739f57Ca24ec"); // for mainnet
    // await new Promise(res => setTimeout(res, 1000));
    // await historyContract.addData([accounts[0]], [1], ["Hello"]);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //History Contract 0xA4D4c44619A676F9F45f8b769100530905fDEF92

    //history contract with array mainnet this one should be used