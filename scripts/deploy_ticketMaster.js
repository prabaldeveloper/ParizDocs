const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await upgrades.deployProxy(TicketMaster, { initializer: 'initialize'})
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })