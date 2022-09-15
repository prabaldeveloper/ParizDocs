const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"
    const conversionAddress = "0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C"
    const ticketMasterAddress = "0xCE7DD08c8124eEa67ab91021be80aec3bBFdA766"
    const eventProxyAddress = "0x3967888Aad7F90D742C91D363285E3819B38f015";

    
    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach(eventProxyAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateVenueContract(venueAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract(conversionAddress);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateTreasuryContract(treasuryProxy.address);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateEventStatus(true);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateticketMasterContract(ticketMaster.address);

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updatePlatformFee(5);

    await new Promise(res => setTimeout(res, 1000));
    await ticketMaster.updateEventContract(eventProxy.address);

    // // let fee = await eventProxy.calculateRent(1, startTime, endTime);
    // // // let totalFee = Number(fee[0]) + Number(fee[1]);
    // // fee[0] = fee[0].toString();
    // // console.log(fee[0]);
    // // await TokenProxy.approve(eventProxyAddress, fee[0]);
    
    // // console.log("approve done");

    // // console.log("balance", await TokenProxy.balanceOf(accounts[0]));

    // // await new Promise(res => setTimeout(res, 4000));
    // // await eventProxy.add(["Event", "Test Category", "Test Event"], [startTime, endTime],
    // //     "Qmf3qJkz9S58TmvgFAeiHrzkyANUFwmyw5qDqFu29HJVAA", 1, fee[0], "200000000000000000", true, true);//tokenId = 1
    // // console.log("done 1");

    // const Conversion = await ethers.getContractFactory("ConversionV1");
    // const conversionProxy = await Conversion.attach(conversionAddress);

    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "200000000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log("ticketPrice",ticketPrice);

    // await TokenProxy.approve(ticketMasterAddress, "200000000000000000");

    // await new Promise(res => setTimeout(res, 2000));
    // await eventProxy.updateEvent(1, "hello",[startTime, endTime-20]);
    // console.log("Time Updated");

    // // Buy Ticket
    // await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", ticketPrice, {value: ticketPrice})
    // console.log("Ticket Bought");

    // //Buy Ticket
    // await new Promise(res => setTimeout(res, 2000));
    // await ticketMaster.buyTicket(1, Trace, "200000000000000000");
    // console.log("Ticket Bought");

    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.startEvent(1);
    // console.log("Event started");

    // await new Promise(res => setTimeout(res, 5000));
    // await ticketMaster.join(1,1);
    // console.log("joined");

    // await new Promise(res => setTimeout(res, 21000));

    // await eventProxy.claimVenueFees(1);
    // console.log("Venue Fees Claimed");

    // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.claimTicketFees(1,["0x0000000000000000000000000000000000000000",Trace]);
    // console.log("TicketFees Claimed");

    // console.log("Part One Testing done");
    
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.add(["Event", "Test Category", "Test Event"], [endTime + 8000, endTime + 10000],
    //     "QmRL2CTNVddAFX3wscFS84w24oz8PXuh1TUEL5sTSZBjwa", 1, 0, "1500000000000000000", true, false);

    // let fee2 = await eventProxy.calculateRent(1, endTime + 8000, endTime + 10000);
    // await TokenProxy.approve(eventProxy.address, fee2[0])

    // let ticketPrice2 = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000","1500000000000000000");
    // ticketPrice2  = ticketPrice2.toString();
    // console.log("ticketPrice",ticketPrice2);

    // await new Promise(res => setTimeout(res, 2000));
    // await eventProxy.payEvent(2,fee2[0]);
    // console.log("Event paid");

    // Buy Ticket
    // await new Promise(res => setTimeout(res, 1000));
    // await ticketMaster.buyTicket(2, "0x0000000000000000000000000000000000000000", ticketPrice2, {value: ticketPrice2});
    // console.log("Ticket Bought");
    // await TokenProxy.approve(ticketMasterAddress, "1500000000000000000");
    //await new Promise(res => setTimeout(res, 1000));
    // console.log(await eventProxy._exists(1));
    // await ticketMaster.buyTicket(1, Trace, "1500000000000000000");
    // console.log("Ticket Bought");


    // Cancel Event
    // await new Promise(res => setTimeout(res, 5000));
    // await eventProxy.cancelEvent(1);
    // console.log("Event Cancelled");

    // await new Promise(res => setTimeout(res, 2000));    
    // await ticketMaster.refundTicketFees(1,[1]);
    // console.log("Ticket Fees Refunded");

    // await new Promise(res => setTimeout(res, 4000));
    
    await eventProxy.refundVenueFees(1);
    console.log("Fees Refunded");

    // console.log(await eventProxy.isEventCancelled(2));


}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })