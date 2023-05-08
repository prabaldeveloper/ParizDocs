const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0x75ceF0380d2F9004cDD590C8F1ABd8852Bc1C569";

    const adminContract = "0x060fF4A3b764004d0bA5D42d042Edb61F80448BE";
    const TicketMaster = await hre.ethers.getContractFactory("TicketMasterV1");
    // const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    const ticketMaster = await TicketMaster.deploy();
    //const ticketMaster = await TicketMaster.attach("0x1d967fa86A191A710af564dF7fa05D9Ee0E86616");
    //convert into proxy contract
    // await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);

    // await ticketMaster.updateAdminContract(adminContract);

    // await ticketMaster.whitelistAdmin(eventProxy, true);

    //await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", "491773029829", "ERC20");
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e