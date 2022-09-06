const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const TicketMaster = await hre.ethers.getContractFactory("TicketMaster");
    const ticketMaster = await TicketMaster.attach("0x5C8767536419f98BB67e89825e3C368fE486D756")
    // const ticketMaster = await TicketMaster.deploy();
    // const ticketMaster = await upgrades.deployProxy(TicketMaster, { initializer: 'initialize'})
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);


    const Conversion = await ethers.getContractFactory("ConversionV1");
    const conversionProxy = await Conversion.attach("0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C");

    let rentalFee = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "200000000000000000");
    rentalFee  = rentalFee.toString();
    console.log(rentalFee);


    console.log(await ticketMaster.buyTicket(1, "0x0000000000000000000000000000000000000000", rentalFee, {value: rentalFee}))


    // console.log(await ticketMaster.checkTicketFeesTest(rentalFee,"200000000000000000",accounts[0],"0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC", "0x7E37935D71853f6094aff6aD691Eab5CBbD8cf6C"))
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })