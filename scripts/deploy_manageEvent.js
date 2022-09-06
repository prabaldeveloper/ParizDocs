const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    //mumbai
    const eventAddress = "0x1835704Db3d8F9c403eaF1460560e1D15274434f";

    // local
    // const venueAddress = "0xBC05Cf0e8248C1eD6102479294440f0f7cd96742";
    // const conversionAddress = "0xEF60E3fbfd02392Ad12ee68EbA44dac96Ae5781f";
    // const eventAddress = "0x30507B848D2328FCcBf514CEDE6B1Af9cD61c8a1";
    // const ticketMasterAddress = "0x36F5EB061D32a53a6F5Ef53Af81E348803d6E3E5";
    
    const manageEvent = await ethers.getContractFactory("ManageEvent");
    const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    await manageEventContract.deployed();
    await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    // const manageEvent = await hre.ethers.getContractFactory("ManageEvent");
    // const manageEventContract = await manageEvent.attach("0x8d4E05C512D11426B8c16BfE573ff9946e480C7C");

    await manageEventContract.updateEventContract(eventAddress);
    await new Promise(res => setTimeout(res, 1000));
    console.log(await manageEventContract.getEventContract());

    // await manageEventContract.deleteAgenda(1,1)

    // const eventContract = await ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach(eventAddress);

    // AddAgenda
    // await manageEventContract.addAgenda(1, 1661946035, 1661946335, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await new Promise(res => setTimeout(res, 1000));
    // await manageEventContract.addAgenda(3, 1661962535, 1661962635, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("1");
    //await manageEventContract.addAgenda(3, 1661962505, 1661962935, "Meeting", ["Prabal"], [accounts[0]], 2)
    // console.log("2");
    // await manageEventContract.addAgenda(4, 1661946335, 1661946815, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("4");
    // await manageEventContract.addAgenda(2, 1662014957, 1662015957, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("3");
    // await new Promise(res => setTimeout(res, 20000));

    // //Cancel Event
    // await manageEventContract.cancelEvent(2);
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await  manageEventContract.isEventCanceled(3));
    
    // //InitiateSession
    // await manageEventContract.initiateSession(1,0);
    // console.log("done");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
})