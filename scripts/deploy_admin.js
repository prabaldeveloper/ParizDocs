const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const MATIC = "0x0000000000000000000000000000000000000000";
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC";
    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f";

    const venueAddress = "0x09020bC6935186Dbb437b9451e863B97F8B8EcE4"
    const conversionAddress = "0xccb93Ceb1f9A1b29341f638e4755D54D339646BA"
    const ticketMasterAddress = "0x9C57d0C1aA00fb4E43b49334c260717ae645904A"
    const treasuryProxy = "0x106B7a1F99547F9811370A7F181D0f8ac28CD203"
    const manageEventContract = "0xA45491B909fb5C1ae1f318Cb46E32Aa91Ea3F10e"
    const signContract ="0x162E0dc3Ef6334AC08099448D653f2155e8Fbdef"
    const eventContract = "0xc8677C605080Ab0aa7d47C890fe36f6DD7d834f3"

    //// ************ DEPLOY ADMIN **************/////

    const admin = await ethers.getContractFactory("AdminFunctions");
    //const adminContract = await upgrades.deployProxy(admin, { initializer: 'initialize' })
    // const adminContract = await admin.deploy();
    const adminContract = admin.attach("0xcE0A81Ae0e9353d7716d346d50D1BC9A63662530")
    // await new Promise(res => setTimeout(res, 2000));
    // await adminContract.deployed();
    // console.log("Admin proxy", adminContract.address);

    // await adminContract.updateDeviation(5);

    // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.whitelistErc20TokenAddress(MATIC, true);

    // await adminContract.whitelistErc20TokenAddress(Trace, true);

    await adminContract.updateBaseToken(Trace);
    
    // await adminContract.whitelistErc20TokenAddress(USDC, true);

    // console.log("Token Added");

    // await new Promise(res => setTimeout(res, 1000));

    // await adminContract.updateEventContract(eventContract);

    // await new Promise(res => setTimeout(res, 5000));

    // await adminContract.whitelistErc721TokenAddress(1,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(1,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(1, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);

    // await adminContract.whitelistErc721TokenAddress(37,"0x8e3db4bf0cbfed015f56643b6030bdb2aa45a06f", true, 0);
    
    // await adminContract.whitelistErc721TokenAddress(37,"0x11c3a46087b34870C23452E5A62326E324ec1360", true, 1);

    // await adminContract.whitelistErc721TokenAddress(37, "0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576", true, 1);

    // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateConversionContract(conversionAddress);

    // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateVenueContract(venueAddress);

    // await new Promise(res => setTimeout(res, 1000));

    // await adminContract.updateSignatureContract(signContract);

    // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateEventStatus(true);

    // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updatePlatformFee(5);

    // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateSignerAddress("0x3B2091278d903435232e8E0F3F364A4e9b9F670C");

    // // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateWhitelist([accounts[0]], [true]);

    // await adminContract.updateVenueRentalCommission(5);

    // await adminContract.updateTicketCommission(5);

    // // // // // await new Promise(res => setTimeout(res, 1000));
    // await adminContract.updateTicketMasterContract(ticketMasterAddress);

    // await adminContract.updateManageEventContract(manageEventContract);

    // await adminContract.updateTreasuryContract(treasuryProxy);

    // await adminContract.updateAdminTreasuryContract("0x8c1a9a4C448eBaC625FB5159f49d1AaDC8f9F98A");

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //https://mumbai.polygonscan.com/address/0x5d8d5952229bb6a1ea224340ab249e4d1add8050