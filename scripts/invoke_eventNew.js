const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"

    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach("0xC17D916119F4E2273c4B1a5e97F38B68C188D17d");

    // await eventProxy.updateWhitelist(["0xE80CBA78510db3D9890aE826c95C79ac9306b741","0x6A2Dc29D33A433478A5aB8E9E16285C2ba46EdC4","0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18"],[true,true,true])

    const MATIC = "0x0000000000000000000000000000000000000000";
    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const thirtyDays = 1 * 24 * 60 * 60; // 1 days
    const startTime = blockBefore.timestamp + thirtyDays;
    const endTime = startTime + 60;
    console.log(startTime, endTime);

    let fee = await eventProxy.calculateRent(1, startTime, endTime);
    console.log(parseInt(fee[0]));

    const Conversion = await ethers.getContractFactory("ConversionV1");
    const conversionProxy = await Conversion.attach("0x802F20029e0C3a1b2Be0fD63FB1929066a62cF2a");

    let rentalFee = await conversionProxy.convertFee(MATIC, fee[0]);
    rentalFee  = rentalFee.toString();
    console.log(rentalFee);

    let platformFee = await conversionProxy.convertFee(MATIC, fee[1]);
    platformFee  = platformFee.toString();
    console.log(platformFee);

    console.log(await eventProxy.ticketNFTAddress(1));

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.add(["EventOne", "Test Category One", "Test Event One"], [startTime, endTime],
        "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 2, 1000000, 0, MATIC, Trace, true, false, {
        value: rentalFee
    });
    console.log(await eventProxy.ticketNFTAddress(1));

    const TicketMaster = await ethers.getContractFactory("TicketMaster");
    const ticketMaster = await TicketMaster.attach("0xb3339CA2A823c1271EE89209f10Cf17d42d58d4b");

    await ticketMaster.buyTicket(1,1000000);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })