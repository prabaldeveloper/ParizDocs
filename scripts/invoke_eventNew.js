const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const eventContract = await hre.ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach("0x5A15a0aB07DfDa774fA7504A38E1283B1Be71F4c");

    await new Promise(res => setTimeout(res, 1000));
    await eventProxy.updateConversionContract("0x9722deb95Fa14F7C952FD23A8Fd4C456744AdD4f")

    const MATIC = "0x0000000000000000000000000000000000000000";
    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const startTime = blockBefore.timestamp + 60;
    const thirtyDays = 30 * 24 * 60 * 60;
    const endTime = startTime + thirtyDays;
    console.log(startTime, endTime);

    await eventProxy.add(["EventOne", "Concert", "Test Event One"], [startTime, endTime],
        "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG", 1, 1000000, 0, MATIC, MATIC, true, false);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })