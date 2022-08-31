const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    // Mumbai
    // const venueAddress = "0xe63C1CdC958963c12744bdd823Cdc9354F517C5d"
    // const conversionAddress = "0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C"
    // const ticketMasterAddress = "0x10405BCD4F83286619808a579B8b460a3A95fE16"
    // const manageContract = "0xe1654927B2AD2bd49CDCB8337fEe44f0099bB0fD";

    // local
    const venueAddress = "0xBC05Cf0e8248C1eD6102479294440f0f7cd96742"
    const conversionAddress = "0xEF60E3fbfd02392Ad12ee68EbA44dac96Ae5781f"
    const manageContract = "0x506988c329024867b3EDBdAb3864bE54E4287130";
    //const ticketMasterAddress = "0x36F5EB061D32a53a6F5Ef53Af81E348803d6E3E5"

    const dropsTreasury = await ethers.getContractFactory("Treasury");
    const treasuryProxy = await upgrades.deployProxy(dropsTreasury, [accounts[0]], { initializer: 'initialize' })
    // await new Promise(res => setTimeout(res, 1000));

    console.log("Treasury proxy", treasuryProxy.address);
    console.log("Is admin", await treasuryProxy.isAdmin(accounts[0]));
    // await new Promise(res => setTimeout(res, 1000));

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await TicketMaster.deploy();
    // await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.deployed();
    console.log("ticketMaster contract", ticketMaster.address);

    // const TicketMaster = await ethers.getContractFactory("TicketMaster");
    // const ticketMaster = await TicketMaster.attach(ticketMasterAddress);


    const eventContract = await ethers.getContractFactory("EventsV1");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    // await new Promise(res => setTimeout(res, 1000));
    // const eventProxy = await eventContract.attach("0x4aE4C2b936fCa432842f038c005BbAC3376Bb8Cf");
    console.log("Event contract", eventProxy.address);

    await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.whitelistAdmin(eventProxy.address, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateWhitelist([accounts[0]], [true]);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateDeviation(5);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(MATIC, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(Trace, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(USDC, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress)

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress)

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy.address)

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMaster.address)

    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    const startTime = blockBefore.timestamp+5;
    const endTime = startTime + 60;

    console.log("time",startTime, endTime);

    let fee = await eventProxy.calculateRent(1, startTime, endTime);
    console.log("fee",parseInt(fee[0]));

    const Conversion = await ethers.getContractFactory("ConversionV1");
    const conversionProxy = await Conversion.attach(conversionAddress);

    let rentalFee = await conversionProxy.convertFee(MATIC, fee[0]);
    rentalFee  = rentalFee.toString();
    console.log("rentalFee",rentalFee);

    let platformFee = await conversionProxy.convertFee(MATIC, fee[1]);
    platformFee  = platformFee.toString();
    console.log("platformFee",platformFee);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.add(["EventTwo", "Test Category Two", "Test Event Two"], [startTime, endTime],
        "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 1, 1000000, 1000000, MATIC, Trace, true, true, {
        value: rentalFee
    });//tokenId = 1
    // console.log("done 1");
    // await eventProxy.add(["EventTwo", "Test Category Two", "Test Event Two"], ["1661941775", "1661969735"],
    //     "QmcgGDw183xiyUS2R4jftuLfqEXr8L13BDGoo6iA4f8WqC", 1, 1000000, 1000000, MATIC, Trace, true, false
    // );//tokenId = 2 startEvent and addAgenda
    // console.log("done 2");
    // await eventProxy.add(["EventThree", "Test Category Three", "Test Event Three"], ["1661962535", "1661969735"],
    //     "QmWRQPUCr48tCo7eoE5hAJBb4wCoBY6iXmrDZayLZadb86", 2, 1000000, 1000000, MATIC, Trace, true, false
    // );//tokenId = 3 cancel event
    // console.log("done 3");

    await eventProxy.add(["EventFour", "Test Category Four", "Test Event Four"], ["1661948241", "1661969555"],
        "QmQdAYdCyCedSLpTSGdNDzLQXv5QsLBCQX5EAfxW7usKNy", 2, 1000000, 1000000, MATIC, Trace, true, false
    );//tokenId = 4 
    console.log("done 4");

    // console.log("TicketToken",await eventProxy.ticketNFTAddress(1));

    // let ticketPrice = await conversionProxy.convertFee(MATIC, 1000000);
    // console.log("ticketPrice",ticketPrice);
    // // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.updateEventContract(eventProxy.address);
    // // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.updateTicketCommission(5);

    await ticketMaster.updateManageEventContract(manageContract);
    // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.buyTicket(1, MATIC, ticketPrice, {
    //     value: ticketPrice
    // });
    // // await new Promise(res => setTimeout(res, 50000));
    // let ticketId = await ticketMaster.ticketIdOfUser(accounts[0],1);
    // console.log("ticketId",ticketId);
    // let ticketContract = await eventProxy.ticketNFTAddress(1);
    // console.log("ticketContract",ticketContract);
    
    // const ticketContractAddress = await ethers.getContractFactory("Ticket");
    // const TicketContractAddress = await ticketContractAddress.attach(ticketContract);

    // let balance = await TicketContractAddress.balanceOf(accounts[0]);
    // console.log("balance",balance);
    // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.join(1, ticketId);
    // console.log("join");
    // await new Promise(res => setTimeout(res, 51000));
    // await eventProxy.complete(1);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })