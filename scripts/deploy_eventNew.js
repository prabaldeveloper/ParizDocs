const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    // Mumbai
    const venueAddress = "0xb63E63e8FbA2Ab8cde4AC85bE137565A584c9BC9"
    const conversionAddress = "0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C"
    const treasuryProxy = "0x63DD48e1F95432bCc7e6c2e0568940a2f2c16c4A"
    // const ticketMasterAddress = "0xf3626dFfdccD519FF882c31261114Be2c53E8DF1"

    // local
    // const venueAddress = "0x0447385e1B3A5B9151AA5D3DD2996C0084Ba504e"
    // const conversionAddress = "0xf0b43c664283BDa4E57B8077f8d1D5e645E83DDE"
    // const manageContract = "0x8d4E05C512D11426B8c16BfE573ff9946e480C7C";
    // const ticketMasterAddress = "0xaA1b814590259c67Dbced57dEfeA5746Bf41A2E8"

    // const dropsTreasury = await ethers.getContractFactory("Treasury");
    // const treasuryProxy = await upgrades.deployProxy(dropsTreasury, [accounts[0]], { initializer: 'initialize' })
    // //await new Promise(res => setTimeout(res, 1000));

    // console.log("Treasury proxy", treasuryProxy.address);
    // console.log("Is admin", await treasuryProxy.isAdmin(accounts[0]));
    // //await new Promise(res => setTimeout(res, 1000));

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    //await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.deployed();
    console.log("ticketMaster contract", ticketMaster.address);

    const eventContract = await ethers.getContractFactory("EventsV1");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    //await new Promise(res => setTimeout(res, 1000));
    console.log("Event contract", eventProxy.address);

    //await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.whitelistAdmin(eventProxy.address, true);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateWhitelist([accounts[0]], [true]);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateDeviation(5);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(MATIC, true);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(Trace, true);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(USDC, true);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateEventStatus(true);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMaster.address);

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updatePlatformFee(5);

    //await new Promise(res => setTimeout(res, 1000));
    console.log("here")
    //await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.updateEventContract(eventProxy.address);

    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    await manageEventContract.deployed();
    //await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    await manageEventContract.updateEventContract(eventProxy.address);

    const Token = await ethers.getContractFactory("Token");
    const TokenProxy = await Token.attach(Trace);

    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    const startTime = blockBefore.timestamp + 20;
    const endTime = startTime + thirtyDays;

    console.log("time", startTime, endTime);

    let fee = await eventProxy.calculateRent(1, startTime, endTime);
    // console.log("fee", parseInt(fee[0]));
    // fee = fee[0] + fee[1];
    // fee = fee.toString();
    console.log("fee test", fee[0], fee[1]);

    await TokenProxy.approve(eventProxy.address, fee[0])

    //await new Promise(res => setTimeout(res, 1000));
    await eventProxy.add(["Event", "Test Category", "Test Event"], [startTime, endTime],
        "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 1, fee[0], "200000000000000000", true, true);//tokenId = 1
    console.log("done 1");

    // const Conversion = await ethers.getContractFactory("ConversionV1");
    // const conversionProxy = await Conversion.attach("0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C");

    // let rentalFee = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "200000000000000000");
    // rentalFee  = rentalFee.toString();
    // console.log(rentalFee);


    // await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", rentalFee, {value: rentalFee})

    // console.log(await ticketMaster.getvalue());


    // await eventProxy.updateTime(1, [startTime, endTime-100],
       
    // );//tokenId = 2
    // console.log("done 2");


    // console.log("TicketToken",await eventProxy.ticketNFTAddress(1));

    // let ticketPrice = await conversionProxy.convertFee(MATIC, 1000000);
    // console.log("ticketPrice",ticketPrice);
    // // await new Promise(res => setTimeout(res, 10000));

    //await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.updateTicketCommission(5);

    // await new Promise(res => setTimeout(res, 5000));
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

    // // Start Event
    //await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.startEvent(2, MATIC, rentalFee, {
    //     value: rentalFee
    // });
    // console.log("event Started");

    // await eventProxy.complete(1);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })