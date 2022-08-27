const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"

    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach("0x75CeFe0A146130B2132A69c84CEbEC273C813988");

    // await eventProxy.updateWhitelist(["0xE80CBA78510db3D9890aE826c95C79ac9306b741","0x6A2Dc29D33A433478A5aB8E9E16285C2ba46EdC4","0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18"],[true,true,true])

    // await eventProxy.updateVenueContract("0xe63C1CdC958963c12744bdd823Cdc9354F517C5d");

    // console.log(await eventProxy.getPlatformFeePercent());

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.whitelistTokenAddress("0xf2fe21e854c838c66579f62ba0a60ca84367cd8f", false);

    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.whitelistTokenAddress("0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC", true);

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
    const conversionProxy = await Conversion.attach("0x9722deb95Fa14F7C952FD23A8Fd4C456744AdD4f");

    let rentalFee = await conversionProxy.convertFee(MATIC, fee[0]);
    rentalFee  = rentalFee.toString();
    console.log(rentalFee);

    let platformFee = await conversionProxy.convertFee(MATIC, fee[1]);
    platformFee  = platformFee.toString();
    console.log(platformFee);

    await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.add(["EventOne", "Test Category One", "Test Event One"], [startTime, endTime],
    //     "QmQh36CsceXZoqS7v9YQLUyxXdRmWd8YWTBUz7WCXsiVty", 2, 1000000, 0, MATIC, Trace, true, false, {
    //     value: rentalFee
    // });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })