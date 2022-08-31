const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    //mumbai

    // local
    const venueAddress = "0xBC05Cf0e8248C1eD6102479294440f0f7cd96742";
    const conversionAddress = "0xEF60E3fbfd02392Ad12ee68EbA44dac96Ae5781f";
    const eventAddress = "0xD0B2A68CC47798C6B910ea300504Aa571bfD6048";
    const ticketMasterAddress = "0x36F5EB061D32a53a6F5Ef53Af81E348803d6E3E5";
    
    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    await manageEventContract.deployed();
    // await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    // const manageEvent = await hre.ethers.getContractFactory("ManageEvent");
    // const manageEventContract = await manageEvent.attach("0x506988c329024867b3EDBdAb3864bE54E4287130");

    const conversionContract = await hre.ethers.getContractFactory("Conversion");
    const conversionProxy = await conversionContract.attach(conversionAddress);

    await manageEventContract.updateEventContract(eventAddress);
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await manageEventContract.getEventContract());

    const eventContract = await ethers.getContractFactory("EventsV1");
    const eventProxy = await eventContract.attach(eventAddress);

    // const venueProxy = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venueProxy.attach(venueAddress);
    // console.log(await eventProxy._exists(4));
    // const startTime = await eventProxy.getInfo(4).startTime;
    // const endTime = await eventProxy.getInfo(4).endTime;
    const startTime = 1661948241;
    const endTime = 1661969555;
    // console.log(startTime, endTime);

    let fee = await eventProxy.calculateRent(2, startTime, endTime);
    console.log("fee",parseInt(fee[0]));
    
    let rentalFee = await conversionProxy.convertFee(MATIC, fee[0]);
    rentalFee  = rentalFee.toString();
    console.log("rentalFee",rentalFee);

    let platformFee = await conversionProxy.convertFee(MATIC, fee[1]);
    platformFee  = platformFee.toString();
    console.log(platformFee);

    // AddAgenda
    // await manageEventContract.addAgenda(4, 1661946035, 1661946335, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await new Promise(res => setTimeout(res, 1000));
    // await manageEventContract.addAgenda(3, 1661962535, 1661962635, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("1");
    //await manageEventContract.addAgenda(3, 1661962505, 1661962935, "Meeting", ["Prabal"], [accounts[0]], 2)
    // console.log("2");
    // await manageEventContract.addAgenda(4, 1661946335, 1661946815, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("4");
    await manageEventContract.addAgenda(2, 1661948541, 1661958541, "Meeting", ["Prabal"], ["0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"], 2);
    console.log("3");

    // Start Event
    // await new Promise(res => setTimeout(res, 1000));
    await manageEventContract.startEvent(2, MATIC, rentalFee, {
        value: rentalFee
    });
    console.log("event Started");

    

    // //Cancel Event
    // await manageEventContract.cancelEvent(3);
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await  manageEventContract.isEventCanceled(3));
    
    // //InitiateSession
    // await manageEventContract.initiateSession(4,0);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
})