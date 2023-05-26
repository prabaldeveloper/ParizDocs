const { ethers, upgrades } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    //mumbai
    const adminContract = "0xCC5b4E9F9Bd81390F93268991c44F923836fd927";
    
    const manageEvent = await ethers.getContractFactory("ManageEventV1");
    //const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    //const manageEventContract = await manageEvent.deploy();
    const manageEventContract = await manageEvent.attach("0xD4388Fa66c2Be74a28B4Eb3f757B6067d2Ca6CE9");
    //await manageEventContract.deployed();
    // await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    await manageEventContract.updateAdminContract(adminContract);
    // await new Promise(res => setTimeout(res, 1000));

    // await manageEventContract.deleteAgenda(1,1)

    // const eventContract = await ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach(eventAddress);

    // AddAgenda
    // await manageEventContract.addAgenda(1, 1683892220, 1683892820, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await new Promise(res => setTimeout(res, 12000));
    
    // console.log("here");

    // await manageEventContract.updateAgenda(1,0,1683892220, 1683892800, "Meeting", ["Prabal"], [accounts[0]], 2);
    // // await manageEventContract.addAgenda(3, 1661962535, 1661962635, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("1");
    //await manageEventContract.addAgenda(3, 1661962505, 1661962935, "Meeting", ["Prabal"], [accounts[0]], 2)
    // console.log("2");
    // await manageEventContract.addAgenda(4, 1661946335, 1661946815, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("4");
    // await manageEventContract.addAgenda(2, 1662014957, 1662015957, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("3");
    //await new Promise(res => setTimeout(res, 12000));

    // await manageEventContract.startEvent(1);
    // console.log("Event started");

    // //Cancel Event
    // await manageEventContract.cancelEvent(2);
    // await new Promise(res => setTimeout(res, 1000));
    // console.log(await  manageEventContract.isEventCancelled(3));
    
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