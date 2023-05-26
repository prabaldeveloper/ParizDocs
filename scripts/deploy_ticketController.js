const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const adminContract = "0xCC5b4E9F9Bd81390F93268991c44F923836fd927";

    const ticketController = await hre.ethers.getContractFactory("TicketController");
    const ticketControllerContract = await upgrades.deployProxy(ticketController,  { initializer: 'initialize'});
    
    //const eventCallContract = await eventCall.attach("0x1d967fa86A191A710af564dF7fa05D9Ee0E86616");

    await ticketControllerContract.deployed();

    console.log("Ticket Controller contract", ticketControllerContract.address);

    await ticketControllerContract.updateAdminContract(adminContract);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e