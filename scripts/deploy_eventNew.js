const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"
    // Mumbai
    // const venueAddress = "0xe63C1CdC958963c12744bdd823Cdc9354F517C5d"
    // const conversionAddress = "0x9722deb95Fa14F7C952FD23A8Fd4C456744AdD4f"
    // const ticketMasterAddress = "0x10405BCD4F83286619808a579B8b460a3A95fE16"

    // local
    const venueAddress = "0x37174ec423D11A03b6294A7105e9997fd6AeE8bE"
    const conversionAddress = "0x802F20029e0C3a1b2Be0fD63FB1929066a62cF2a"
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

    // await ticketmaster.whitelistowner(eventProxy.address)

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
    const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    const startTime = blockBefore.timestamp + thirtyDays;
    const endTime = startTime + 60;
    console.log(startTime, endTime);

    let fee = await eventProxy.calculateRent(1, startTime, endTime);
    console.log(parseInt(fee[0]));

    const Conversion = await ethers.getContractFactory("ConversionV1");
    const conversionProxy = await Conversion.attach(conversionAddress);

    let rentalFee = await conversionProxy.convertFee(MATIC, fee[0]);
    rentalFee  = rentalFee.toString();
    console.log(rentalFee);

    let platformFee = await conversionProxy.convertFee(MATIC, fee[1]);
    platformFee  = platformFee.toString();
    console.log(platformFee);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.add(["EventOne", "Test Category One", "Test Event One"], [startTime, endTime],
        "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 2, 1000000, 1000000, MATIC, Trace, true, false, {
        value: rentalFee
    });

    console.log("TicketToken",await eventProxy.ticketNFTAddress(1));

    let ticketPrice = await conversionProxy.convertFee(MATIC, 1000000);
    console.log(ticketPrice);

    await ticketMaster.updateEventContract(eventProxy.address);

    await ticketMaster.buyTicket(1, MATIC, ticketPrice, {
        value: ticketPrice
    });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })