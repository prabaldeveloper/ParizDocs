const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const eventCall = await hre.ethers.getContractFactory("AdminFunctions");
    const eventCallContract = await eventCall.deploy();
    
    //const eventCallContract = await eventCall.attach("0x1d967fa86A191A710af564dF7fa05D9Ee0E86616");

    await eventCallContract.deployed();

    console.log("EventsV2 contract", eventCallContract.address);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e