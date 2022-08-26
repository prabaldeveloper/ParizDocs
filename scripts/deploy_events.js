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
    

    const eventContract = await ethers.getContractFactory("Events");
    const eventProxy = await upgrades.deployProxy(eventContract, { initializer: 'initialize' })
    await eventProxy.deployed();
    await new Promise(res => setTimeout(res, 1000));

     console.log("Event proxy", eventProxy.address);

     

    // const eventContract = await hre.ethers.getContractFactory("Events");
    // const eventProxy = await eventContract.attach("0x58bBFE5a9559f1df29655E70Ba0DCbC02d3A2Cb5");
    
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

    // await eventProxy.updateVenueContract("0xA349553a541597b44a2347D088D3FacaeB3E5f6A");
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await eventProxy.getVenueContract());

    // await eventProxy.updateConversionContract("0xA086631d3DeeFaAd6c9c336366fa951D4A1826ef");
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await eventProxy.getConversionContract());

    // await eventProxy.updatePlatformFee(5);
    // await new Promise(res => setTimeout(res, 1000));

    // await eventProxy.updateTicketCommission(2);
    // await new Promise(res => setTimeout(res, 1000));

    // const venueProxy = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venueProxy.attach("0xA349553a541597b44a2347D088D3FacaeB3E5f6A");
    // console.log(await eventProxy.getVenueContract());

    //  const venueFees = await venueContract.getRentalFeesPerBlock(1);
    //  console.log("venueFees",venueFees);
    
    //  const conversionProxy = await hre.ethers.getContractFactory("ConversionNew");
    //  const conversionContract = await conversionProxy.attach("0xA086631d3DeeFaAd6c9c336366fa951D4A1826ef");
    
    // let feeAmount = await conversionContract.convertFee(MATIC,venueFees);
    // console.log(feeAmount);
    // feeAmount = feeAmount.toString();
    // await new Promise(res => setTimeout(res, 1000));

    //console.log(await eventProxy.getConversionContract());
    // var details = new Array(3);
    // details[0]  = "EventOne";
    // details[1] = "Test Category One"; 
    // details[2] = "Test Event One";
    // var time = new Array(2);
    // time[0] = "1661414168";
    // time[1] = "1661442968";
    await eventProxy.add(["EventOne", "Test Category One", "Test Event One"],[1661386728,1661444328],"QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG",1,
    false,MATIC,0,true,MATIC,1000000);

   console.log(await eventProxy.getInfo(1));

   await new Promise(res => setTimeout(res, 1000));

    //const etherValue = ethers.utils.parseEther("2275268862832004386");
     //console.log(etherValue);
    // await eventProxy.add("EventTwo", "Test Category Two", "Test Event Two", 1660216501, 1660233701,"QmXe5xGgiF6kGjUozyV6c6TNRNKZ8RbmkaapTppwyoozC6",2,
    // true,MATIC,feeAmount,true,2000000, {
    //     value: feeAmount
    // });
    
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