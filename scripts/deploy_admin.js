const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    //MAINNET
    // const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
    // const Trace = "0x4287F07CBE6954f9F0DecD91d0705C926d8d03A4";
    // const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F";

    //TESTNET
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";
    const USDT = "";

    const venueAddress = "0x2f96423D99deBEcad907dFb825A81d333878CfAD"
    const conversionAddress = "0xc5b9C6F3F350dBba6DF40f9309eC60adb5C6b98c"
    const ticketMasterAddress = "0xcc30503cAfA93b80298FfC032dD32CB1E5A92941"
    const treasuryProxy = "0xaFb4dF4bcc8034Ee39971965c00B5fD3963374f7"
    const adminTreasuryProxy = "0xa8B0F6f54Bc8510714eec8f7F09Dd8fcB4C79934"
    const manageEventContract = "0x59C03f2dc36ca9B2B843453667060fb97cC4E82D"
    const signContract ="0x4D733335eA2Ee9CD6906aD247FCcF1BB9BE7dDff"
    const eventContract = "0x25b65770D1e976Db9BAEc9D9240F24F171A849Df"
    const eventCallContract = "0x06366d099A3dc53E819Afce21de48BCE5D45EF1b";
    const ticketControllerContract = "0xf3aff08FCAa5440C4628565aec234D7E0421e2d8";

    //// ************ DEPLOY ADMIN **************/////

    const admin = await ethers.getContractFactory("AdminFunctions");
    //const adminContract = await upgrades.deployProxy(admin, { initializer: 'initialize' })
    //const adminContract = await admin.deploy();
    const adminContract = admin.attach("0x5b41e018d38024C0B006F535D50defFa5eEb7654");
    // await new Promise(res => setTimeout(res, 2000));
    await adminContract.deployed();
    console.log("Admin proxy", adminContract.address);

    // await adminContract.updateDeviation(5);

    // // // // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.whitelistErc20TokenAddress(MATIC, true);

    // await adminContract.whitelistErc20TokenAddress(Trace, true);
    
    // await adminContract.whitelistErc20TokenAddress(USDC, true);

    // await adminContract.whitelistErc20TokenAddress(USDT, true);

    // await adminContract.updateBaseToken(Trace);

    // console.log("Token Added");

    // await new Promise(res => setTimeout(res, 5000));


    // await new Promise(res => setTimeout(res, 5000));

    //await adminContract.whitelistErc721TokenAddressEvent(1,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(1,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(1, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);;

    // await adminContract.updateEventStatus(true);
    // // // await new Promise(res => setTimeout(res, 2000));
    // // await new Promise(res => setTimeout(res, 3000));

    // await adminContract.updatePlatformFee(5);

    // // // // // // // // await new Promise(res => setTimeout(res, 1000));

    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueRentalCommission(10);
    // // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateTicketCommission(10);
    // // // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateSignerAddress("0x8B0dE5873A816661B95a98C5Fc81fB6ae68Ae034");


    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateConversionContract(conversionAddress);

    await adminContract.updateEventContract(eventContract);

    // // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueContract(venueAddress);

    // // // // await new Promise(res => setTimeout(res, 1000));

    // await adminContract.updateSignatureContract(signContract);

    // // // // // // await new Promise(res => setTimeout(res, 1000));
    

    // await new Promise(res => setTimeout(res, 5000));

    // // // // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateWhitelist([accounts[0]], [true]);

    // // // // // // // await new Promise(res => setTimeout(res, 1000));
    await adminContract.updateTicketMasterContract(ticketMasterAddress);
    // // // await new Promise(res => setTimeout(res, 5000));

    await adminContract.updateManageEventContract(manageEventContract);

    await adminContract.updateTreasuryContract(treasuryProxy);

    await adminContract.updateAdminTreasuryContract(adminTreasuryProxy);

    await adminContract.updateEventCallContract(eventCallContract);

    await adminContract.updateTicketControllerContract(ticketControllerContract);
    // await adminContract.whitelistErc721TokenAddress(118,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(118,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(118, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //https://mumbai.polygonscan.com/address/0x5d8d5952229bb6a1ea224340ab249e4d1add8050