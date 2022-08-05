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
    

    const venueContract = await ethers.getContractFactory("Venue");
    const venueTreasury = await upgrades.deployProxy(venueContract, { initializer: 'initialize' })
    await new Promise(res => setTimeout(res, 5000));

    console.log("Venue proxy", venueTreasury.address);
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.add("VenueOne", "Test Location", 50, 10000000000, "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.add("VenueTwo", "Test Location Two", 20, 200000000, "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.adminUpdateDeviation(5);
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.updateErc20TokenAddress(MATIC, true);
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.updateErc20TokenAddress(USDC, true);
    await new Promise(res => setTimeout(res, 5000));

    await venueTreasury.updateErc20TokenAddress(Trace, true);
    await new Promise(res => setTimeout(res, 5000));

    /// ************ DEPLOY CONVERSION **************/////

    const Conversion = await ethers.getContractFactory("Conversion");
    const conversion = await upgrades.deployProxy(Conversion, { initializer: 'initialize' })
    await new Promise(res => setTimeout(res, 100));

    console.log("conversion proxy", conversion.address);

    //// ************ ADD PRICE FEED ADDRESS **************/////

    await new Promise(res => setTimeout(res, 100));
    await conversion.addToken(MATIC, PRICE_MATIC_USD);

    //await new Promise(res => setTimeout(res, 100));
    await conversion.addToken(USDC, PRICE_USDC_USD);

    await conversion.addToken(USX, router);

    await new Promise(res => setTimeout(res, 100));
    await conversion.addToken(Trace, router);

    await new Promise(res => setTimeout(res, 100));
    await conversion.adminUpdate(USX, Trace, router, factory);


    await venueTreasury.updateConversionContract(conversion.address);
    await new Promise(res => setTimeout(res, 10000));
    console.log(await venueTreasury.getConversionContract());


}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
})


// Venue proxy 0xCa386c62bb2963AC766a52bDF58551135690E416
// conversion proxy 0x5C106D1c4eA4e81a69B32716897934594c4636A8