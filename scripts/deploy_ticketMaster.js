const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0xf0421A5CE166DEA75A0Eef770a56fc7a989932ce";
    const Test8 = "0x4b020734168D4e23f12fba8250Aa957Cb16eFb8A";
    const Test18 = "0xBDa3c5ec872Ec75D09957d8a6A8F6df4F8C1D435";
    const adminContract = "0xCC5b4E9F9Bd81390F93268991c44F923836fd927";
    const ticketControllerContract = "0x6DAF41F02903170e5C67c98719cA79f424814152";
    const conversionAddress = "0xE57e76f1113126EC278AC699e1B57eedD9fE7f30";
    

    const TicketMaster = await hre.ethers.getContractFactory("TicketMasterV1");
    //const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    //const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach("0xa9e816c4b2E027d0D6A3e332f2b68692D271fB39");
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);
    
    const Token = await ethers.getContractFactory("Token");
    const TokenProxy = await Token.attach(Trace);
    // // //const TokenProxy = await Token.deploy();
    console.log(TokenProxy.address);

    await TokenProxy.approve(ticketMaster.address, "1500000000000000000");
    await new Promise(res => setTimeout(res, 10000));
    // await ticketMaster.updateAdminContract(adminContract);

    // await ticketMaster.whitelistAdmin(eventProxy, true);

    const Conversion = await ethers.getContractFactory("Conversion");
    const conversionProxy = await Conversion.attach(conversionAddress);
    let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "1500000000000000000");
    ticketPrice  = ticketPrice.toString();
    console.log(ticketPrice);

    let ticketPrice2 = await conversionProxy.convertFee(Test18, "1500000000000000000");
    ticketPrice2  = ticketPrice2.toString();
    console.log(ticketPrice2);
    
    //buy with trace
    // await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [4], [Trace], ["1500000000000000000"], ["ERC20"], ["1685075006"]);

    // //buy with matic
    // await ticketMaster.buyTicket(["0x99DC717eAe599b9451c904e508a8F492100f4A36"], [4], ["0x0000000000000000000000000000000000000000"], [ticketPrice], ["ERC20"], ["1685075006"],{
    //     value: ticketPrice
    // });

    //buy with tokenGating
    await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [5], [Test18], [ticketPrice2], ["ERC20"], ["1685075006"]);
}   

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e