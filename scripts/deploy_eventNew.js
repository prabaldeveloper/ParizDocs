const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"
    // Mumbai
    const venueAddress = "0xe63C1CdC958963c12744bdd823Cdc9354F517C5d"
    const conversionAddress = "0x9722deb95Fa14F7C952FD23A8Fd4C456744AdD4f"
    // const ticketMasterAddress = "0x10405BCD4F83286619808a579B8b460a3A95fE16"

    // local
    // const venueAddress = "0xd9140951d8aE6E5F625a02F5908535e16e3af964"
    // const conversionAddress = "0x34B40BA116d5Dec75548a9e9A8f15411461E8c70"
    // const ticketMasterAddress = "0xc96304e3c037f81dA488ed9dEa1D8F2a48278a75"

    const dropsTreasury = await ethers.getContractFactory("Treasury");
    const treasuryProxy = await upgrades.deployProxy(dropsTreasury, [accounts[0]], { initializer: 'initialize' })
    await new Promise(res => setTimeout(res, 1000));

    console.log("Treasury proxy", treasuryProxy.address);
    console.log("Is admin", await treasuryProxy.isAdmin(accounts[0]));
    await new Promise(res => setTimeout(res, 1000));

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await TicketMaster.deploy();
    await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.deployed();
    console.log("ticketMaster contract", ticketMaster.address);


    const eventContract = await ethers.getContractFactory("EventsV1");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    await new Promise(res => setTimeout(res, 1000));
    console.log("Event contract", eventProxy.address);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateWhitelist([accounts[0]], [true]);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateDeviation(5);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(MATIC, true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(Trace, true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress)

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress)

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy.address)

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMaster.address)

    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const startTime = blockBefore.timestamp + 60;
    const thirtyDays = 1 * 24 * 60 * 60; // 1 day
    const endTime = startTime + thirtyDays;
    console.log(startTime, endTime);

    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.add(["EventOne", "Test Category One", "Test Event One"], [startTime, endTime],
    //     "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG", 1, 1000000, 0, MATIC, Trace, true, false{
    //     value: 
    // });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })