const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const adminContract = "0xCC5b4E9F9Bd81390F93268991c44F923836fd927";
    const tokenCompatibility = "0xadfC90401FB4c56D68AeF5Eb8a55E610BCD3b580";

    const eventCall = await hre.ethers.getContractFactory("EventCall");
    //const eventCallContract = await upgrades.deployProxy(eventCall,  { initializer: 'initialize'});
    
    const eventCallContract = await eventCall.attach("0x21277fFE24A413828273aec9785903EDE902E74A");

//    await eventCallContract.deployed();

    console.log("Event Call contract", eventCallContract.address);

    await eventCallContract.updateAdminContract(adminContract);

    //await eventCallContract.updateTokenCompatibility(tokenCompatibility);

 //   console.log(await eventCallContract.checkTokenCompatibility(["0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408"],["ERC20"]));
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e
