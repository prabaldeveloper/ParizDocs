const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"
    const conversionAddress = "0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C"
    const ticketMasterAddress = "0x6630cA912b3A04Cb6cf8Ad17Ab3836199788fFd7"


    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach("0x3DBC17Cf31d27623ee7554D6E918Eb0c5Cd92ce7");

    const Token = await ethers.getContractFactory("Token");
    const TokenProxy = await Token.attach(Trace);
    // const TokenProxy = await Token.deploy();
    // console.log(TokenProxy.address);

    // await TokenProxy.mint(accounts[0], "2000000000000000000000000000")

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    //const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach(ticketMasterAddress);
    
    // const blockNumBefore = await ethers.provider.getBlockNumber();
    // const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    // const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    // const startTime = blockBefore.timestamp + 60;
    // const endTime = startTime + 200;

    // console.log("time", startTime, endTime);

    // let fee = await eventProxy.calculateRent(1, startTime, endTime);
    // //let totalFee = Number(fee[0]) + Number(fee[1]);
    // fee[0] = fee[0].toString();
    // console.log(fee[0]);
    // await TokenProxy.approve("0x3DBC17Cf31d27623ee7554D6E918Eb0c5Cd92ce7", fee[0]);
    
    // // console.log("approve done");

    // // console.log("balance", await TokenProxy.balanceOf(accounts[0]));

    // await new Promise(res => setTimeout(res, 4000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [startTime, endTime],
    //     "QmRioYZHtyRbnm3qr54d3ZgjhZnNGkyEWGN7Wf1dArXGZt", 1, fee[0], "200000000000000000", true, true);//tokenId = 1
    // console.log("done 1");

    
    // const Conversion = await ethers.getContractFactory("ConversionV1");
    // const conversionProxy = await Conversion.attach(conversionAddress);

    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "200000000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log("ticketPrice",ticketPrice);

    // await new Promise(res => setTimeout(res, 2000));
    
    // await TokenProxy.approve(ticketMasterAddress, "200000000000000000");

    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateEvent(1, "hello",[startTime, endTime-20]);
    // console.log("Time Updated");

    //Buy Ticket
    // await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", ticketPrice, {value: ticketPrice})
    // console.log("Ticket Bought");

    // //Buy Ticket
    // await new Promise(res => setTimeout(res, 2000));
    // await ticketMaster.buyTicket(1, Trace, "200000000000000000");
    // console.log("Ticket Bought");

    // await new Promise(res => setTimeout(res, 10000));
    // await eventProxy.startEvent(1);
    // console.log("Event started");

    // await new Promise(res => setTimeout(res, 5000));
    // await ticketMaster.join(1,1);
    // console.log("joined");

    // await new Promise(res => setTimeout(res, 5000));

    // await eventProxy.claimVenueFees(1);
    // console.log("Venue Fees Claimed");

    // await new Promise(res => setTimeout(res, 4000));
    // await ticketMaster.claimTicketFees(1,["0x0000000000000000000000000000000000000000",Trace]);
    // console.log("TicketFees Claimed");

    
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [endTime + 8000, endTime + 10000],
    //     "Qmf3qJkz9S58TmvgFAeiHrzkyANUFwmyw5qDqFu29HJVAA", 1, 0, "1500000000000000000", true, false);

    // let fee2 = await eventProxy.calculateRent(1, endTime + 8000, endTime + 10000);
    // await TokenProxy.approve(eventProxy.address, fee2[0])

    // let ticketPrice2 = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000","1500000000000000000");
    // ticketPrice2  = ticketPrice2.toString();
    // console.log("ticketPrice",ticketPrice2);

    // await new Promise(res => setTimeout(res, 2000));
    // await eventProxy.payEvent(2,fee2[0]);

    //Buy Ticket
    // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.buyTicket(2, "0x0000000000000000000000000000000000000000", ticketPrice2, {value: ticketPrice2});
    // console.log("Ticket Bought");

    // //Cancel Event
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.cancelEvent(2);
    // console.log("Event Canceled");

    // await new Promise(res => setTimeout(res, 10000));
    // await eventProxy.refundVenueFees(2);
    // console.log("Fees Refunded");

    console.log(await eventProxy.isEventCanceled(2));

    // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.refundTicketFees(2,1);
    // console.log("Ticket Fees Refunded");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })