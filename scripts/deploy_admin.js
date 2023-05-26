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

    const venueAddress = "0xF130d5eA1c7b1eb36061dEF9d1AF7Bc211280b43"
    const conversionAddress = "0xE57e76f1113126EC278AC699e1B57eedD9fE7f30"
    const ticketMasterAddress = "0xa9e816c4b2E027d0D6A3e332f2b68692D271fB39"
    const treasuryProxy = "0xaFb4dF4bcc8034Ee39971965c00B5fD3963374f7"
    const adminTreasuryProxy = "0xa8B0F6f54Bc8510714eec8f7F09Dd8fcB4C79934"
    const manageEventContract = "0xD4388Fa66c2Be74a28B4Eb3f757B6067d2Ca6CE9"
    const signContract ="0x4D733335eA2Ee9CD6906aD247FCcF1BB9BE7dDff"
    const eventContract = "0xf0421A5CE166DEA75A0Eef770a56fc7a989932ce"
    const eventCallContract = "0x21277fFE24A413828273aec9785903EDE902E74A";
    const ticketControllerContract = "0x6930c1B89D33Edc2a70a35BD655a2D12e4D48F7d";

    //// ************ DEPLOY ADMIN **************/////

    const admin = await ethers.getContractFactory("AdminFunctions");
    //const adminContract = await upgrades.deployProxy(admin, { initializer: 'initialize' })
    //const adminContract = await admin.deploy();
    const adminContract = admin.attach("0xCC5b4E9F9Bd81390F93268991c44F923836fd927");
    // await new Promise(res => setTimeout(res, 2000));
    await adminContract.deployed();
    console.log("Admin proxy", adminContract.address);

    // await adminContract.updateDeviation(5);

    // // // // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.whitelistErc20TokenAddress(MATIC, true, 0);

    // await adminContract.whitelistErc20TokenAddress(Trace, true, 0);
    
    // await adminContract.whitelistErc20TokenAddress(USDC, true, 0);

    // // await adminContract.whitelistErc20TokenAddress(USDT, true);

    // await adminContract.updateBaseToken(Trace);

    // console.log("Token Added");

    // await new Promise(res => setTimeout(res, 5000));


    // await new Promise(res => setTimeout(res, 5000));

    //await adminContract.whitelistErc721TokenAddressEvent(1,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(1,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(1, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);;

    // await adminContract.updateEventStatus(true);
    // // // // // await new Promise(res => setTimeout(res, 2000));
    // // // // await new Promise(res => setTimeout(res, 3000));

    // await adminContract.updatePlatformFee(5);

    // // // // // // // // await new Promise(res => setTimeout(res, 1000));

    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueRentalCommission(10);
    // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateTicketCommission(10);
    // // // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateSignerAddress("0x8B0dE5873A816661B95a98C5Fc81fB6ae68Ae034");


    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateConversionContract(conversionAddress);

    // await adminContract.updateEventContract(eventContract);

    // // // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueContract(venueAddress);

    // // // // // await new Promise(res => setTimeout(res, 1000));

    // await adminContract.updateSignatureContract(signContract);

    // // // // // // // await new Promise(res => setTimeout(res, 1000));
    

    // // await new Promise(res => setTimeout(res, 5000));

    // // // // // // // // // await new Promise(res => setTimeout(res, 1000));
    // // await adminContract.updateWhitelist([accounts[0]], [true]);

    // // // // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateTicketMasterContract(ticketMasterAddress);
    // // // // // await new Promise(res => setTimeout(res, 5000));

    // await adminContract.updateManageEventContract(manageEventContract);

    // await adminContract.updateTreasuryContract(treasuryProxy);

    // await adminContract.updateAdminTreasuryContract(adminTreasuryProxy);

    // await adminContract.updateEventCallContract(eventCallContract);

    // await adminContract.updateTicketControllerContract(ticketControllerContract);
    //await adminContract.whitelistErc721TokenAddress(118,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(118,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(118, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);

    //Tokens for testing tokenGating

    const Test8 = "0x4b020734168D4e23f12fba8250Aa957Cb16eFb8A"; 
    //const Test18 = "0xBDa3c5ec872Ec75D09957d8a6A8F6df4F8C1D435";

    await adminContract.whitelistErc20TokenAddress(Test8, true, "9999999999900");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //https://mumbai.polygonscan.com/address/0x5d8d5952229bb6a1ea224340ab249e4d1add8050