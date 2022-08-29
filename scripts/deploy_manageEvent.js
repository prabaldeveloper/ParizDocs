const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    //mumbai
    const eventAddress = "0xc670D1A7FC9Ccda08F32883f979364d0fCc0Ce3E";

    // local
    // const venueAddress = "0x78B3CeB87C561e746d0Cec5195BDE870E11Ca81d"
    // const eventAddress = "0x66c08bf6aC884BAc0e2883a0CA588426aA5F0fa9";
    // const conversionAddress = "0x0D902E14Ec1f1AeB5eEFbB79e19eD512b174EDfc"
    // const ticketMasterAddress = "0x651652BDa40fC753724533C1715cF6979dbb8f1F" 
    
    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    await manageEventContract.deployed();
    await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    // const manageEvent = await hre.ethers.getContractFactory("ManageEvent");
    // const manageEventContract = await manageEvent.attach("0xe1654927B2AD2bd49CDCB8337fEe44f0099bB0fD");

    await manageEventContract.updateEventContract(eventAddress);
    await new Promise(res => setTimeout(res, 1000));
    console.log(await manageEventContract.getEventContract());

    // const eventContract = await ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach(eventAddress);

    // const venueProxy = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venueProxy.attach("0x85c7eE172B92F0f1393f98926adF320c434E3262");

    // const startTime = await eventProxy.getInfo[1].startTime;
    // const endTime = await eventProxy.getInfo[1].endTime;

    // console.log(startTime, endTime);
    
    // const venueFees = await venueContract.getRentalFees(2);
    // console.log("venueFees",venueFees);
   
   
    // const conversionProxy = await hre.ethers.getContractFactory("Conversion");
    // const conversionContract = await conversionProxy.attach("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");
   
    // let rentalFee = await conversionContract.convertFee(MATIC,venueFees);
    // console.log(feeAmount);
    // feeAmount = feeAmount.toString();
    // await new Promise(res => setTimeout(res, 1000));
    
    //Start Event
    // await manageEventContract.startEvent(1, MATIC, feeAmount, {
    //     value: feeAmount
    // });
    // await new Promise(res => setTimeout(res, 1000));

    // //Cancel Event
    // await manageEventContract.cancelEvent(2);
    // await new Promise(res => setTimeout(res, 1000));

    //AddAgenda
    // await manageEventContract.addAgenda(1, 1661772453, 1661772853, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await new Promise(res => setTimeout(res, 1000));

    // //InitiateSession
    // await manageEventContract.initiateSession(1,1);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
})