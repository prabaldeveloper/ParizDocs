const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0xb0abe1623c73ee874b94083A349a7C1d00A8B573";

    const adminContract = "0x5DF40949F4063132E7C181A41C1e0edd3D99A7E5";
    const ticketControllerContract = "0x6DAF41F02903170e5C67c98719cA79f424814152";
    const conversionAddress = "0xc5b9C6F3F350dBba6DF40f9309eC60adb5C6b98c";
    
    const Token = await ethers.getContractFactory("Token");
    const TokenProxy = await Token.attach(Trace);
    // //const TokenProxy = await Token.deploy();
    console.log(TokenProxy.address);


    const TicketMaster = await hre.ethers.getContractFactory("TicketMasterV1");
    // const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    //const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach("0xf7910bF47A4789B9100c1Fa43db4be703E3E1187");
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);
    
    // await TokenProxy.approve(ticketControllerContract, "1500000000000000000");
    // await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.updateAdminContract(adminContract);

    // await ticketMaster.whitelistAdmin(eventProxy, true);

    const Conversion = await ethers.getContractFactory("Conversion");
    const conversionProxy = await Conversion.attach(conversionAddress);
    let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "1500000000000000000");
    ticketPrice  = ticketPrice.toString();
    console.log(ticketPrice);
    await ticketMaster.buyTicket(["0x99DC717eAe599b9451c904e508a8F492100f4A36"], [3], ["0x0000000000000000000000000000000000000000"], [ticketPrice], ["ERC20"], ["1683805849"],{
        value: ticketPrice
    });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e