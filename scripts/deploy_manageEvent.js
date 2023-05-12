const { ethers, upgrades } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    //mumbai
    const adminContract = "0x5DF40949F4063132E7C181A41C1e0edd3D99A7E5";
    
    const manageEvent = await ethers.getContractFactory("ManageEventV1");
    // const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
    //const manageEventContract = await manageEvent.deploy();
    const manageEventContract = await manageEvent.attach("0xE94679A8d229F0e77Caf4B422A3894f3A691C30D");
    await manageEventContract.deployed();
    // await new Promise(res => setTimeout(res, 1000));
    console.log("Manage Event proxy", manageEventContract.address);

    // await manageEventContract.updateAdminContract(adminContract);
    // await new Promise(res => setTimeout(res, 1000));

    // await manageEventContract.deleteAgenda(1,1)

    // const eventContract = await ethers.getContractFactory("EventsV1");
    // const eventProxy = await eventContract.attach(eventAddress);

    // AddAgenda
    // await manageEventContract.addAgenda(1, 1683793649, 1683793949, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await new Promise(res => setTimeout(res, 10000));
    
    // console.log("here");

    //await manageEventContract.updateAgenda(1,0,1683793649, 1683793919, "Meeting", ["Prabal"], [accounts[0]], 2);
    // await manageEventContract.addAgenda(3, 1661962535, 1661962635, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("1");
    //await manageEventContract.addAgenda(3, 1661962505, 1661962935, "Meeting", ["Prabal"], [accounts[0]], 2)
    // console.log("2");
    // await manageEventContract.addAgenda(4, 1661946335, 1661946815, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("4");
    // await manageEventContract.addAgenda(2, 1662014957, 1662015957, "Meeting", ["Prabal"], [accounts[0]], 2);
    // console.log("3");
    // await new Promise(res => setTimeout(res, 20000));

    await manageEventContract.startEvent(1);
    console.log("Event started");

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