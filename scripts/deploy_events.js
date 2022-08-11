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
    

    // const eventContract = await ethers.getContractFactory("Events");
    // const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    // await eventProxy.deployed();
    // await new Promise(res => setTimeout(res, 1000));

    //  console.log("Event proxy", eventProxy.address);

    const eventTreasury = await hre.ethers.getContractFactory("Events");
    const eventProxy = await eventTreasury.attach("0x26705B80a694bD5F9451E29aB3000FDCb19c3b51");
    
    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateWhitelist([accounts[0]],[true]);
     
    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateDeviation(5);
    
    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateErc20TokenAddress(MATIC, true);
    
    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateErc20TokenAddress(USDC, true);
    
    // await new Promise(res => setTimeout(res, 1000));
    // await eventProxy.updateErc20TokenAddress(Trace, true);
    

    /// ************ DEPLOY CONVERSION **************/////

    // const Conversion = await ethers.getContractFactory("Conversion");
    // const conversion = await upgrades.deployProxy(Conversion, { initializer: 'initialize' })
    // await new Promise(res => setTimeout(res, 100));

    // console.log("conversion proxy", conversion.address);

    //// ************ ADD PRICE FEED ADDRESS **************/////

    // await new Promise(res => setTimeout(res, 100));
    // await conversion.addToken(MATIC, PRICE_MATIC_USD);

    // //await new Promise(res => setTimeout(res, 100));
    // await conversion.addToken(USDC, PRICE_USDC_USD);

    // await conversion.addToken(USX, router);

    // //await new Promise(res => setTimeout(res, 100));
    // await conversion.addToken(Trace, router);

    // //await new Promise(res => setTimeout(res, 100));
    // await conversion.adminUpdate(USX, Trace, router, factory);

    //-----------------------------------------------------------------


    // await eventProxy.updateVenueContract("0x85c7eE172B92F0f1393f98926adF320c434E3262");
    // await new Promise(res => setTimeout(res, 1000));
    //  console.log(await eventProxy.getVenueContract());

    // await eventProxy.updateConversionContract("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await eventProxy.getConversionContract());

    const venueProxy = await hre.ethers.getContractFactory("Venue");
    const venueContract = await venueProxy.attach("0x85c7eE172B92F0f1393f98926adF320c434E3262");
    console.log(await eventProxy.getVenueContract());

     const venueFees = await venueContract.getRentalFees(2);
     console.log("venueFees",venueFees);
    
     const conversionProxy = await hre.ethers.getContractFactory("Conversion");
     const conversionContract = await conversionProxy.attach("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");
    
    let feeAmount = await conversionContract.convertFee(MATIC,venueFees);
    console.log(feeAmount);
    feeAmount = feeAmount.toString();
    await new Promise(res => setTimeout(res, 1000));

    //console.log(await eventProxy.getConversionContract());

    await eventProxy.add("EventOne", "Test Category One", "Test Event One", 1660155773, 1660206173,"QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG",2,
    false,MATIC,0,true,1000000);

   console.log(await eventProxy.getInfo(1));

   await new Promise(res => setTimeout(res, 1000));

    //const etherValue = ethers.utils.parseEther("2275268862832004386");
     //console.log(etherValue);
    await eventProxy.add("EventTwo", "Test Category Two", "Test Event Two", 1660216501, 1660233701,"QmXe5xGgiF6kGjUozyV6c6TNRNKZ8RbmkaapTppwyoozC6",2,
    true,MATIC,feeAmount,true,2000000, {
        value: feeAmount
    });
    
    // await eventProxy.add("EventThree", "Test Category Three", "Test Event Three", 1660235262, 1660335262,"Qmb3qLzR6UmbfD7n8AnDMofUbZpYRWmQwe5EtDcty768nU",1,
    // true,MATIC,feeAmount,true,2000000, {
    //     value: feeAmount
    // });
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})


//event contract 0x26705B80a694bD5F9451E29aB3000FDCb19c3b51