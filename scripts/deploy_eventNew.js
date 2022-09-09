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
    const treasuryProxyAddress = "0x63DD48e1F95432bCc7e6c2e0568940a2f2c16c4A"
    const ticketMasterAddress = "0xe083507f557A41f7CA839d4a88F1207F1a318014"

    // local
    // const venueAddress = "0x778652Ca63b282fD60F500a800E9494bFD228b68"
    // const conversionAddress = "0xf412DC788C1FCff286Ea0F717fA7831A6FFbd7BF"
    // const manageContract = "0x8d4E05C512D11426B8c16BfE573ff9946e480C7C";
    // const ticketMasterAddress = "0x9bD68dCa5a0e130838c30a66bA44f7367c136dAf"

    const dropsTreasury = await ethers.getContractFactory("Treasury");
    //const treasuryProxy = await upgrades.deployProxy(dropsTreasury, [accounts[0]], { initializer: 'initialize' })
    const treasuryProxy = await dropsTreasury.attach(treasuryProxyAddress);
    // await new Promise(res => setTimeout(res, 1000));

    console.log("Treasury proxy", treasuryProxy.address);
    // console.log("Is admin", await treasuryProxy.isAdmin(accounts[0]));

    // await new Promise(res => setTimeout(res, 1000));

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    //const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach(ticketMasterAddress);
    // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.deployed();
    console.log("ticketMaster contract", ticketMaster.address);

    const eventContract = await ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach("0xfF4f2c875fC03EDDA73f4f1A47a3A6aFDecF2c66");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    await new Promise(res => setTimeout(res, 1000));
    console.log("Event contract", eventProxy.address);

    // await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.whitelistAdmin(eventProxy.address, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateWhitelist([accounts[0]], [true]);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateDeviation(5);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(MATIC, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(Trace, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress(USDC, true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy.address);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateEventStatus(true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMasterAddress);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updatePlatformFee(5);

    // await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.updateEventContract(eventProxy.address);

    console.log("done");
    // await new Promise(res => setTimeout(res, 5000));

    await treasuryProxy.grantAdmin(eventProxy.address);
    await new Promise(res => setTimeout(res, 1000));
    await treasuryProxy.grantAdmin(ticketMasterAddress);

    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    // const manageEventContract = await manageEvent.attach("0x6EC139493f287C2D5ef2c57B6a5B9B6e9a379119");
    await manageEventContract.deployed();
    await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    await manageEventContract.updateEventContract(eventProxy.address);

    // const Token = await ethers.getContractFactory("Token");
    // const TokenProxy = await Token.attach(Trace);
    //const TokenProxy = await Token.deploy();
    //console.log(TokenProxy.address);

    //await TokenProxy.mint(accounts[0], "2000000000000000000000000000")
    
    // const blockNumBefore = await ethers.provider.getBlockNumber();
    // const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    // const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    // const startTime = blockBefore.timestamp + 40;
    // const endTime = startTime + 150;

    // console.log("time", startTime, endTime);

    // let fee = await eventProxy.calculateRent(1, startTime, endTime);
    // //let totalFee = Number(fee[0]) + Number(fee[1]);
    // fee[0] = fee[0].toString();
    // console.log(fee[0]);
    // await TokenProxy.approve("0xfF4f2c875fC03EDDA73f4f1A47a3A6aFDecF2c66", fee[0]);
    
    // console.log("approve done");

    // console.log("balance", await TokenProxy.balanceOf(accounts[0]));
    // await new Promise(res => setTimeout(res, 2000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [startTime, endTime],
    //     "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 1, fee[0], "200000000000000000", true, true);//tokenId = 1
    // console.log("done 1");

    
    // const Conversion = await ethers.getContractFactory("ConversionV1");
    // const conversionProxy = await Conversion.attach(conversionAddress);

    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "200000000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log("ticketPrice",ticketPrice);

    // // await new Promise(res => setTimeout(res, 1000));
    
    // // await TokenProxy.approve(ticketMasterAddress, "200000000000000000");

    // // //Buy Ticket
    // // await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", ticketPrice, {value: ticketPrice})
    // // console.log("Ticket Bought");

    // // // //Buy Ticket
    // // await new Promise(res => setTimeout(res, 1000));
    // // await ticketMaster.buyTicket(1, Trace, "200000000000000000");
    // // console.log("Ticket Bought");

    // // await new Promise(res => setTimeout(res, 1000));
    // // await eventProxy.updateEvent(1, "hello",[startTime, endTime-20]);
    // // console.log("Time Updated");

    // // await new Promise(res => setTimeout(res, 1000));
    // // await eventProxy.startEvent(1);
    // // console.log("Event started");

    // // await new Promise(res => setTimeout(res, 3000));
    // // await ticketMaster.join(1,1);
    // // console.log("joined");

    // // await new Promise(res => setTimeout(res, 5000));

    // // await eventProxy.claimVenueFees(1);
    // // console.log("Venue Fees Claimed");

    // await new Promise(res => setTimeout(res, 4000));
    // await ticketMaster.claimTicketFees(1,["0x0000000000000000000000000000000000000000",Trace]);
    // console.log("TicketFees Claimed");


    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [endTime + 8000, endTime + 10000],
    //     "Qmf3qJkz9S58TmvgFAeiHrzkyANUFwmyw5qDqFu29HJVAA", 1, fee[0], "1500000000000000000", true, false);

    // let fee2 = await eventProxy.calculateRent(1, endTime + 8000, endTime + 10000);
    // await TokenProxy.approve(eventProxy.address, fee2[0])

    // let ticketPrice2 = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000","1500000000000000000");
    // ticketPrice2  = ticketPrice2.toString();
    // console.log("ticketPrice",ticketPrice2);

    // await new Promise(res => setTimeout(res, 2000));
    // await eventProxy.payEvent(2,fee2[0]);

    // //Buy Ticket
    // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.buyTicket(2, "0x0000000000000000000000000000000000000000", ticketPrice2, {value: ticketPrice2});
    // console.log("Ticket Bought");

    // // //Cancel Event
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.cancelEvent(2);
    // console.log("Event Canceled");

    // await new Promise(res => setTimeout(res, 10000));
    // await eventProxy.refundVenueFees(2);
    // console.log("Fees Refunded");

    // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.refundTicketFees(2,1);
    // console.log("Ticket Fees Refunded");

       
    // );//tokenId = 2
    // console.log("done 2");


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

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })