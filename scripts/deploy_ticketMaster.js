const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0xf0421A5CE166DEA75A0Eef770a56fc7a989932ce";

    const adminContract = "0x0C4FF6a699e14504C976d5a25Ce56cD62aF32D12";
    const ticketControllerContract = "0x6DAF41F02903170e5C67c98719cA79f424814152";
    const conversionAddress = "0xc5b9C6F3F350dBba6DF40f9309eC60adb5C6b98c";
    

    const TicketMaster = await hre.ethers.getContractFactory("TicketMasterV1");
    const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    //const ticketMaster = await TicketMaster.deploy();
    //const ticketMaster = await TicketMaster.attach("0xcc30503cAfA93b80298FfC032dD32CB1E5A92941");
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);
    
    // const Token = await ethers.getContractFactory("Token");
    // const TokenProxy = await Token.attach(Trace);
    // // // //const TokenProxy = await Token.deploy();
    // console.log(TokenProxy.address);

    // await TokenProxy.approve(ticketMaster.address, "1000000000000000");
    // await new Promise(res => setTimeout(res, 10000));
    await ticketMaster.updateAdminContract(adminContract);

    await ticketMaster.whitelistAdmin(eventProxy, true);

    // const Conversion = await ethers.getContractFactory("Conversion");
    // const conversionProxy = await Conversion.attach(conversionAddress);
    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "1000000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log(ticketPrice);
    //await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [Trace], ["1000000000000000"], ["ERC20"], ["1683892820"]);
    // await ticketMaster.buyTicket(["0x99DC717eAe599b9451c904e508a8F492100f4A36"], [1], ["0x0000000000000000000000000000000000000000"], [ticketPrice], ["ERC20"], ["1683892820"],{
    //     value: ticketPrice
    // });
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e