const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const eventProxy = "0x882Eb072fC810ad69D32839F0D5CD6cFb32CAAbc";

    const adminContract = "0x2C7583602Fe34B6F7a18Abf4a9099a1E58a96AC9";
    const ticketControllerContract = "0x6DAF41F02903170e5C67c98719cA79f424814152";
    const conversionAddress = "0xc5b9C6F3F350dBba6DF40f9309eC60adb5C6b98c";
    
    const nftAddress = "0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f";

    const Token = await ethers.getContractFactory("Token");
    const TokenProxy = await Token.attach(Trace);
    // //const TokenProxy = await Token.deploy();
    console.log("Token Contract",TokenProxy.address);


    const TicketMaster = await hre.ethers.getContractFactory("TicketMasterV1");
    //const ticketMaster = await upgrades.deployProxy(TicketMaster, [accounts[0]], { initializer: 'initialize'})
    //const ticketMaster = await TicketMaster.deploy();
    const ticketMaster = await TicketMaster.attach("0xD037144cDf6beCdB96857497f11E7DDbd2070eEd");
    //convert into proxy contract
    await ticketMaster.deployed();

    console.log("ticketMaster contract", ticketMaster.address);
    
    // await TokenProxy.approve(ticketMaster.address, "1500000000000000000");
    // await new Promise(res => setTimeout(res, 10000));
    // //await ticketMaster.updateAdminContract(adminContract);

    // await ticketMaster.whitelistAdmin(eventProxy, true);

    // const Conversion = await ethers.getContractFactory("Conversion");
    // const conversionProxy = await Conversion.attach(conversionAddress);
    // let ticketPrice = await conversionProxy.convertFee("0x0000000000000000000000000000000000000000", "1500000000000000000");
    // ticketPrice  = ticketPrice.toString();
    // console.log(ticketPrice);
    // await ticketMaster.buyTicket(["0x99DC717eAe599b9451c904e508a8F492100f4A36"], [3], ["0x0000000000000000000000000000000000000000"], [ticketPrice], ["ERC20"], ["1683805849"],{
    //     value: ticketPrice
    // });

    //await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [Trace], ["1500000000000000000"], ["ERC20"], ["1684205854"]);

    // Buy Ticket with nft
    const nft = await ethers.getContractFactory("Token721");
    const nftContract = await nft.attach(nftAddress);
    console.log("nft Contract",nftContract.address);

    //freePass
    // await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [nftAddress], [39], ["ERC721"], ["1684205854"]);
    // await new Promise(res => setTimeout(res, 5000));
    //await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [nftAddress], [40], ["ERC721"], ["1684205854"]);

    //approve
    //  await nftContract.setApprovalForAll(ticketMaster.address, true);
    //  await new Promise(res => setTimeout(res, 7000));
     await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [nftAddress], [96], ["ERC721"], ["1684205854"]);

    //nft 
    // await ticketMaster.buyTicket(["0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9"], [1], [nftAddress], [39], ["ERC721"], ["1684205854"]);
}   


main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


    ///0xB6be38E7924cb499fC7FC018f2C24FDe2C85C81e