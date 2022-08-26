const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Venue", function () {
    async function deployState() {
        const [owner, otherAccount] = await ethers.getSigners();

        const PRICE_MATIC_USD = "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada";
        const MATIC = "0x0000000000000000000000000000000000000000";

        const venue = await ethers.getContractFactory("Venue");
        const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
        await venueContract.deployed();

        await venueContract.updateVenueRentalCommission(5);
        await venueContract.add("Pariz Convention Center", "12,092", "Concert", 50, 100000000, "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
        await venueContract.add("Pariz Fashion Gallery", "12,093", "Fashion Show", 20, 200000001, "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
        console.log("here");
        const ConversionV1 = await ethers.getContractFactory("ConversionV1");
        const conversionV1 = await ConversionV1.deploy();

        await conversionV1.initialize();

        //await new Promise(res => setTimeout(res, 5000));
        await conversionV1.addToken(MATIC, PRICE_MATIC_USD);

        //await new Promise(res => setTimeout(res, 5000));
        await conversionV1.addToken(Trace, router);

        const EventsV1 = await ethers.getContractFactory("EventsV1");
        const eventProxy = await EventsV1.deploy();

        await eventProxy.initialize();

        await new Promise(res => setTimeout(res, 1000));
        await eventProxy.updateWhitelist([accounts[0]], [true]);

        await new Promise(res => setTimeout(res, 1000));
        await eventProxy.updateDeviation(5);

        await new Promise(res => setTimeout(res, 1000));
        await eventProxy.updateErc20TokenAddress(MATIC, true);

        const blockNumBefore = await ethers.provider.getBlockNumber();
        const blockBefore = await ethers.provider.getBlock(blockNumBefore);
        const startTime = blockBefore.timestamp;
        const thirtyDays = 30 * 24 * 60 * 60;
        const endTime = startTime + thirtyDays;

        return { venueContract, conversionV1, startTime, endTime, eventProxy, owner, otherAccount, MATIC };

    };

    describe("Deployment", function () {
        it("is advertiser contract updated at deployment", async function () {
            const { eventProxy, startTime, endTime, MATIC } = await loadFixture(
                deployState
            );
            await eventProxy.add(["EventOne", "Test Category One", "Test Event One"], [startTime, endTime],
                "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG", 1, 1000000, 0, MATIC, MATIC, true, false);
        })
    });
});