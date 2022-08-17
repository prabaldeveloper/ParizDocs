const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const MATIC = "0x0000000000000000000000000000000000000000";
    const Trace = "0xb0A2D971803e74843f158B22c4DAEc154f038515";
    
    // const manageEvent = await ethers.getContractFactory("ManageEvent");
    // const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    // await manageEventContract.deployed();
    // // await new Promise(res => setTimeout(res, 1000));
    // console.log("Manage Event proxy", manageEventContract.address);

    const manageEvent = await hre.ethers.getContractFactory("ManageEvent");
    const manageEventContract = await manageEvent.attach("0x53f3F8A1399C70cCc808F4200B619eFDC1f1231a");

    await manageEventContract.updateVenueContract("0x85c7eE172B92F0f1393f98926adF320c434E3262");
    // await new Promise(res => setTimeout(res, 1000));
    console.log(await manageEventContract.getVenueContract());

    await manageEventContract.updateEventContract("0x26705B80a694bD5F9451E29aB3000FDCb19c3b51");
    // await new Promise(res => setTimeout(res, 1000));
    console.log(await manageEventContract.getEventContract());

    // const venueProxy = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venueProxy.attach("0x85c7eE172B92F0f1393f98926adF320c434E3262");

    // const venueFees = await venueContract.getRentalFees(2);
    // console.log("venueFees",venueFees);
   
   
    // const conversionProxy = await hre.ethers.getContractFactory("Conversion");
    // const conversionContract = await conversionProxy.attach("0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF");
   
    // let feeAmount = await conversionContract.convertFee(MATIC,venueFees);
    // console.log(feeAmount);
    // feeAmount = feeAmount.toString();
    // await new Promise(res => setTimeout(res, 1000));
    
    // //Start Event
    // await manageEventContract.startEvent(1, MATIC, feeAmount, {
    //     value: feeAmount
    // });
    // await new Promise(res => setTimeout(res, 1000));

    // //Cancel Event
    // await manageEventContract.cancelEvent(2);
    // await new Promise(res => setTimeout(res, 1000));

    // //AddAgenda
    // await manageEventContract.addAgena(1, 1660623397, 1660709797, "Meeting", ["Prabal"], [accounts[0]], 2);
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