const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    // Mumbai
    const venueAddress = "0xf35BF6FD49C77905759E842464bb47b0A12cF3E7"
    const conversionAddress = "0xccb93Ceb1f9A1b29341f638e4755D54D339646BA"
    const ticketMasterAddress = "0x7185b0a09a39fDa0f669e2c89EeEe5fC07c57Dec"
    const nfttoken = "0x8E3DB4bf0Cbfed015F56643b6030bDB2aA45A06F"

    // local
    // const venueAddress = "0xbd32cFE6e57995cEa07F25921DD7006a87295c0d"
    // const conversionAddress = "0x994B804b178e2FA0F69ed7C0d71E5c6AE29B107E"
    // // const manageContract = "0x8d4E05C512D11426B8c16BfE573ff9946e480C7C";
    // const ticketMasterAddress = "0x07Ba11Ef168db9acc4B4E32C732e4FF4cB40dEFD"
    // const nfttoken = "0x9D6A70e2e1003d0bfc95129D658d1eBa5f08B481";

    const dropsTreasury = await ethers.getContractFactory("Treasury");
    const treasuryProxy = await upgrades.deployProxy(dropsTreasury, [accounts[0]], { initializer: 'initialize' })
    //const treasuryProxy = await dropsTreasury.attach(treasuryProxyAddress);
    await treasuryProxy.deployed();

    // await new Promise(res => setTimeout(res, 1000));
    console.log("Treasury proxy", treasuryProxy.address);
    console.log("Is admin", await treasuryProxy.isAdmin(accounts[0]));

    const Conversion = await ethers.getContractFactory("ConversionV1");
    const conversionProxy = await Conversion.attach(conversionAddress);

    // await new Promise(res => setTimeout(res, 1000));

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    // // //const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    const ticketMaster = await TicketMaster.attach(ticketMasterAddress);
    // // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.deployed();
    console.log("ticketMaster contract", ticketMaster.address);

    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach("0xCC975b87e6b2b09A0a1Df78799E6D0393Facb881");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    // // // await new Promise(res => setTimeout(res, 1000));
    console.log("Event contract", eventProxy.address);

    // const EventsV1 = await ethers.getContractFactory("EventsV1")

    // const EventsV1Proxy = await EventsV1.deploy();
    // await EventsV1Proxy.deployed();
    // console.log(EventsV1Proxy.address)

    // await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.whitelistAdmin(eventProxy.address, true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateSignerAddress(accounts[0]);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateWhitelist([accounts[0]], [true]);

    // // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateDeviation(5);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistErc20TokenAddress(MATIC, true);

    // // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistErc20TokenAddress(Trace, true);
    console.log("Token Added");

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistErc20TokenAddress(USDC, true);

    await eventProxy.whitelistErc721TokenAddress(nfttoken, true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy.address);

    console.log("Address Addded");

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateEventStatus(true);

    // await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMasterAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updatePlatformFee(5);

    await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.updateEventContract(eventProxy.address);

    console.log("done");
    // await new Promise(res => setTimeout(res, 5000));

    await treasuryProxy.grantAdmin(eventProxy.address);
    // await new Promise(res => setTimeout(res, 3000));
    await treasuryProxy.grantAdmin(ticketMaster.address);

    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    // const manageEventContract = await manageEvent.attach("0xE6aed862B2613815629Af5b7e0517Bc3E906eaB0");
    await manageEventContract.deployed();
    //await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    await manageEventContract.updateEventContract(eventProxy.address);

    await eventProxy.updateManageEventContract(manageEventContract.address);

    // const Token = await ethers.getContractFactory("Token");
    // const TokenProxy = await Token.attach(Trace);
    // //const TokenProxy = await Token.deploy();
    //console.log(TokenProxy.address);

    // // await TokenProxy.mint(accounts[0], "2000000000000000000000000000")
    // console.log("minted");
    
    // const blockNumBefore = await ethers.provider.getBlockNumber();
    // const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    // const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    // const startTime = blockBefore.timestamp + 15;
    // const endTime = startTime + 86400;

    // console.log("time", startTime, endTime);

    // let fee = await eventProxy.calculateRent(1, startTime, endTime);
    // //let totalFee = Number(fee[0]) + Number(fee[1]);
    // fee[0] = fee[0].toString();
    // console.log(fee[0]);
    //await TokenProxy.approve(eventProxy.address, fee[0]);
    
    
    // console.log("approve done");

    // console.log("balance", await TokenProxy.balanceOf(accounts[0]));
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [startTime, endTime],
    //     "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 1, fee[0], "20000000000000", true, false);//tokenId = 1
    // console.log("done 1");

    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "20000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log("ticketPrice",ticketPrice);

    // await new Promise(res => setTimeout(res, 3000));
    
    // await TokenProxy.approve(ticketMasterAddress, "20000000000000");

    // await new Promise(res => setTimeout(res, 3000));

    // // //Buy Ticket
    // await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", ticketPrice, "ERC20",{value: ticketPrice})
    // console.log("Ticket Bought");

    // await ticketMaster.buyTicket(1, Trace, "20000000000000", "ERC20");
    // console.log("Ticket Bought");

    // // // // // //Buy Ticket
    // // await new Promise(res => setTimeout(res, 3000));
    // const Token = await ethers.getContractFactory("Token721");
    // const TokenProxy = await Token.attach(nfttoken);
    // await TokenProxy.approve(ticketMaster.address, "1");
    // await ticketMaster.buyTicket(1, nfttoken, "1", "ERC721");
    // console.log("Ticket Bought");

    // // // // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateEvent(1, "hello",[startTime, endTime-20]);
    // console.log("Time Updated");

    // await new Promise(res => setTimeout(res, 15000));
    // await manageEventContract.startEvent(1);
    // console.log("Event started");

    // // await new Promise(res => setTimeout(res, 2000));
    // // await ticketMaster.join(1,1);
    // // console.log("joined");

    // // await new Promise(res => setTimeout(res, 5000));

    // // await eventProxy.claimVenueFees(1);
    // // console.log("Venue Fees Claimed");

    // // await new Promise(res => setTimeout(res, 4000));
    // // await ticketMaster.claimTicketFees(1,["0x0000000000000000000000000000000000000000",Trace]);
    // // console.log("TicketFees Claimed");


    // // await new Promise(res => setTimeout(res, 5000));
    // // await eventProxy.add(["Event", "Test Category", "Test Event"], [endTime + 8000, endTime + 10000],
    // //     "Qmf3qJkz9S58TmvgFAeiHrzkyANUFwmyw5qDqFu29HJVAA", 1, fee[0], "1500000000000000000", true, false);

    // // let fee2 = await eventProxy.calculateRent(1, endTime + 8000, endTime + 10000);
    // // await TokenProxy.approve(eventProxy.address, fee2[0])

    // // let ticketPrice2 = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000","1500000000000000000");
    // // ticketPrice2  = ticketPrice2.toString();
    // // console.log("ticketPrice",ticketPrice2);

    // // await new Promise(res => setTimeout(res, 2000));
    // // await eventProxy.payEvent(2,fee2[0]);

    // // // //Buy Ticket
    // // await new Promise(res => setTimeout(res, 1000));
    // // await ticketMaster.buyTicket(2, "0x0000000000000000000000000000000000000000", ticketPrice2, {value: ticketPrice2});
    // // console.log("Ticket Bought");

    // // // // // //Cancel Event
    // // await new Promise(res => setTimeout(res, 5000));
    // // await eventProxy.cancelEvent(2);
    // // console.log("Event Cancelled");

    // // // await new Promise(res => setTimeout(res, 10000));
    // // await eventProxy.refundVenueFees(2);
    // // console.log("Venue Fees Refunded");

    // // // await new Promise(res => setTimeout(res, 10000));
    // // await ticketMaster.refundTicketFees(2,[1]);
    // // console.log("Ticket Fees Refunded");

       
    // // );//tokenId = 2
    // // console.log("done 2");


    // // // await new Promise(res => setTimeout(res, 50000));
    // // let ticketId = await ticketMaster.ticketIdOfUser(accounts[0],1);
    // // console.log("ticketId",ticketId);
    // // let ticketContract = await eventProxy.ticketNFTAddress(1);
    // // console.log("ticketContract",ticketContract);

    // // const ticketContractAddress = await ethers.getContractFactory("Ticket");
    // // const TicketContractAddress = await ticketContractAddress.attach(ticketContract);

    // // let balance = await TicketContractAddress.balanceOf(accounts[0]);
    // // console.log("balance",balance);
    // // await new Promise(res => setTimeout(res, 10000));
    // // await ticketMaster.join(1, ticketId);
    // // console.log("join");
    // // await new Promise(res => setTimeout(res, 51000));

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })