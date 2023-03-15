const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0x71c2592C6424E1822F35841b40F0FE9dbFcEcF64";

    const adminContract = "0x9E4FaeEDc23da50bB3D18AA51F9Cc27f1611a2a7";
    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
     //const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    // const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach("0x1d967fa86A191A710af564dF7fa05D9Ee0E86616");
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);

    await ticketMaster.updateAdminContract(adminContract);

    await ticketMaster.whitelistAdmin(eventProxy, true);

    //await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", "491773029829", "ERC20");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })