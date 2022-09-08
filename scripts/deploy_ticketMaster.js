const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    // const ticketMaster = await TicketMaster.deploy();
    //const ticketMaster = await TicketMaster.attach("0xf3626dFfdccD519FF882c31261114Be2c53E8DF1");
    //convert into proxy contract
    await ticketMaster.deployed();

    //await ticketMaster.updateEventContract("0x772DC7bb7568f1efB6b6c7788AcE25D5Ca3E1a80");

    console.log("ticketMaster contract", ticketMaster.address);
    await ticketMaster.updateTicketCommission(5);
    // await ticketMaster.buyTicket(2, USDC , 29924);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })