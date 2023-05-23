const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const adminContract = "0x0C4FF6a699e14504C976d5a25Ce56cD62aF32D12";
    const tokenCompatibility = "0x3dfba822644bD55c8275Dfe42b2b69646182dB24";

    const eventCall = await hre.ethers.getContractFactory("EventCall");
    //const eventCallContract = await upgrades.deployProxy(eventCall,  { initializer: 'initialize'});
    
    const eventCallContract = await eventCall.attach("0x21277fFE24A413828273aec9785903EDE902E74A");

//    await eventCallContract.deployed();

    console.log("Event Call contract", eventCallContract.address);

    //await eventCallContract.updateAdminContract(adminContract);

    await eventCallContract.updateTokenCompatibility(tokenCompatibility);

    console.log(await eventCallContract.checkTokenCompatibility(["0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408", "0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408"],["ERC20","ERC20"]));
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e
