const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
    const Trace = "0x4287F07CBE6954f9F0DecD91d0705C926d8d03A4";
    const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F";

    const venueAddress = "0xEf8855663ECA315078690fb9eAFe1307A345d2Ee"
    const conversionAddress = "0x5Ee0441C6cdf1e166e438615Afb8401c96c5E5c0"
    const ticketMasterAddress = "0x1d967fa86A191A710af564dF7fa05D9Ee0E86616"
    const treasuryProxy = "0x61d0923659A969030b168A4D5330A9fBd46D855e"
    const manageEventContract = "0xb8A839E6D70dAd03f08B9c5c9BD78d927C2D1759"
    const signContract ="0x219C43D05829dbB546b204B8303F72934F0EF185"
    const eventContract = "0x71c2592C6424E1822F35841b40F0FE9dbFcEcF64"

    //// ************ DEPLOY ADMIN **************/////

    const admin = await ethers.getContractFactory("AdminFunctions");
    //const adminContract = await upgrades.deployProxy(admin, { initializer: 'initialize' })
    // const adminContract = await admin.deploy();
    const adminContract = admin.attach("0x9E4FaeEDc23da50bB3D18AA51F9Cc27f1611a2a7")
    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.deployed();
    console.log("Admin proxy", adminContract.address);

    // await adminContract.updateDeviation(5);

    // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.whitelistErc20TokenAddress(MATIC, true);

    // await adminContract.whitelistErc20TokenAddress(Trace, true);
    
    // await adminContract.whitelistErc20TokenAddress(USDC, true);

    // await adminContract.whitelistErc20TokenAddress(USDT, true);

    // await adminContract.updateBaseToken(Trace);

    // console.log("Token Added");

    // await new Promise(res => setTimeout(res, 5000));


    // await new Promise(res => setTimeout(res, 5000));

    // await adminContract.whitelistErc721TokenAddress(1,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(1,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(1, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);;

    // await adminContract.updateEventStatus(true);
    // await new Promise(res => setTimeout(res, 2000));
    // await new Promise(res => setTimeout(res, 3000));

    // await adminContract.updatePlatformFee(0);

    // // // // // // // await new Promise(res => setTimeout(res, 1000));

    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueRentalCommission(10);
    // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateTicketCommission(10);
    // await new Promise(res => setTimeout(res, 3000));
    // await adminContract.updateSignerAddress("0x8B0dE5873A816661B95a98C5Fc81fB6ae68Ae034");


    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateConversionContract(conversionAddress);

    await adminContract.updateEventContract(eventContract);

    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.updateVenueContract(venueAddress);

    // // // await new Promise(res => setTimeout(res, 1000));

    // await adminContract.updateSignatureContract(signContract);

    // // // // // // await new Promise(res => setTimeout(res, 1000));
    

    // await new Promise(res => setTimeout(res, 5000));

    // // // // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateWhitelist([accounts[0]], [true]);

    // // // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateTicketMasterContract(ticketMasterAddress);
    // await new Promise(res => setTimeout(res, 5000));

    // await adminContract.updateManageEventContract(manageEventContract);

    // await adminContract.updateTreasuryContract(treasuryProxy);

    // await adminContract.updateAdminTreasuryContract("0x4C2C13F7726fFD6518EA5157947C781cE43e7A21");

    
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