const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const venue = await ethers.getContractFactory("Venue");
    const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
    await venueContract.deployed();
    await new Promise(res => setTimeout(res, 1000));

    console.log("Venue proxy", venueContract.address);

    // const venue = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venue.attach("0xa349553a541597b44a2347d088d3facaeb3e5f6a");

    await venueContract.updateVenueRentalCommission(5);
    await new Promise(res => setTimeout(res, 1000));

    await venueContract.add("Pariz Convention Center", "12,092", "Fashion Show", 50, 100000000, "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
    await new Promise(res => setTimeout(res, 1000));

    await venueContract.add("Pariz Fashion Gallery", "12,093", "Concert", 20, 200000001, "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
    await new Promise(res => setTimeout(res, 1000));

    await venueContract.add("Pariz Conference Room", "12,094", "Conference", 100, 400000002, "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1");
    await new Promise(res => setTimeout(res, 1000));

    await venueContract.add("Pariz Executive Room", "12,095", "Meetup", 30, 1000000002, "QmcbVTKvi6HrhHMEZnZrujkqdkTHbaj5EcDnUBKu2PTtx5");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


// Venue proxy 0x85c7eE172B92F0f1393f98926adF320c434E3262
// conversion proxy 0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF

//New
//Venue Proxy 0xD959B719922b7b70b2AC4b10D466aAbE3745d86c