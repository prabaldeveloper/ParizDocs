const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USX = "0xBE72D7FDDB9d7969507beF69f439840957E0b47c"

    const PRICE_MATIC_USD = "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada";
    const PRICE_USDC_USD = "0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0";

    const Trace = "0xb0A2D971803e74843f158B22c4DAEc154f038515";
    const router = "0x8954AfA98594b838bda56FE4C12a09D7739D179b";
    const factory = "0x5757371414417b8c6caad45baef941abc7d3ab32";
    

    // const venue = await ethers.getContractFactory("Venue");
    // const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
    // await venueContract.deployed();
    // await new Promise(res => setTimeout(res, 1000));

    // console.log("Venue proxy", venueContract.address);

    const venue = await hre.ethers.getContractFactory("Venue");
    const venueContract = await venue.attach("0x85c7eE172B92F0f1393f98926adF320c434E3262");
    
    // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.updateErc20TokenAddress(MATIC, true);
    
    // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.updateErc20TokenAddress(USDC, true);
    
    // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.updateErc20TokenAddress(Trace, true);
   

    //////// ************ DEPLOY CONVERSION **************/////

    // const Conversion = await ethers.getContractFactory("Conversion");
    // const conversion = await upgrades.deployProxy(Conversion, { initializer: 'initialize' })
    // await conversion.deployed();

    // await new Promise(res => setTimeout(res, 1000));

    // console.log("conversion proxy", conversion.address);

    // const Conversion = await hre.ethers.getContractFactory("Conversion");
    // const conversion = await Conversion.attach("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");

    ////// ************ ADD PRICE FEED ADDRESS **************/////

    // await conversion.addToken(MATIC, PRICE_MATIC_USD);
    // await new Promise(res => setTimeout(res, 1000));

    // await conversion.addToken(USDC, PRICE_USDC_USD);
    // await new Promise(res => setTimeout(res, 1000));

    // await conversion.addToken(USX, router);
    // await new Promise(res => setTimeout(res, 3000));

    // await conversion.addToken(Trace, router);
    // await new Promise(res => setTimeout(res, 3000));

    // await conversion.adminUpdate(USX, Trace, router, factory);
    // await new Promise(res => setTimeout(res, 3000));


    // await venueContract.updateConversionContract("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");
    // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.updateDeviation(5);
    // await new Promise(res => setTimeout(res, 1000));

    // console.log("Address",await venueContract.getConversionContract());

    // await venueContract.add("Pariz Convention Center", "12,092", "Concert", 50, 100000000, "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
    // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Fashion Gallery", "12,093", "Fashion Show", 20, 200000001, "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
    // await new Promise(res => setTimeout(res, 1000));

    await venueContract.add("Pariz Conference Room", "12,094", "Conference", 100, 400000002, "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1");
    //await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Executive Room", "12,095", "Meetup", 30, 1000000002, "QmcbVTKvi6HrhHMEZnZrujkqdkTHbaj5EcDnUBKu2PTtx5");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
})


// Venue proxy 0x85c7eE172B92F0f1393f98926adF320c434E3262
// conversion proxy 0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF