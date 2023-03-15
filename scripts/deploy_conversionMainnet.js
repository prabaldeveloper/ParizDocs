const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    // testnet 
    const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"
    const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
    const MATIC = "0x0000000000000000000000000000000000000000"

    const PRICE_MATIC_USD = "0xAB594600376Ec9fD91F8e885dADF0CE036862dE0"
    const PRICE_USDT_USD = "0x0A6513e40db6EB1b165753AD52E80663aeA50545";
    const PRICE_USDC_USD = "0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7";

    const Trace = "0x4287F07CBE6954f9F0DecD91d0705C926d8d03A4"
    const router = "0x630144415F6a084CE89461cf4F53B9C6368270bE"
    const factory = "0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32"

    //// ************ DEPLOY CONVERSION **************/////

    const Conversion = await ethers.getContractFactory("Conversion");
    //const conversion = await upgrades.deployProxy(Conversion, { initializer: 'initialize' })
    const conversion = await Conversion.attach("0x5Ee0441C6cdf1e166e438615Afb8401c96c5E5c0");
    // await new Promise(res => setTimeout(res, 10000));
    console.log("conversion proxy", conversion.address);

    //// ************ ADD PRICE FEED ADDRESS **************/////

    // await new Promise(res => setTimeout(res, 5000));
    // await conversion.addToken(MATIC, PRICE_MATIC_USD);

    // await new Promise(res => setTimeout(res, 5000));
    await conversion.addToken(USDC, PRICE_USDC_USD);

    await new Promise(res => setTimeout(res, 5000));
    await conversion.addToken(USDT, PRICE_USDT_USD);

    await new Promise(res => setTimeout(res, 5000));
    await conversion.addToken(Trace, router);

    await new Promise(res => setTimeout(res, 5000));
    await conversion.adminUpdate(Trace, router, factory);
    // await new Promise(res => setTimeout(res, 5000));

    // await conversion.getERC20Details(MATIC);
    // // // await new Promise(res => setTimeout(res, 5000));

    // await conversion.getERC20Details(Trace);
    // // // await new Promise(res => setTimeout(res, 5000));

    // await conversion.getERC20Details(USDC);

    // await conversion.getERC721Details("0x9c7890e9aEfF837927160FA70A8d11759AF06975");
    // // await new Promise(res => setTimeout(res, 5000));

    // await conversion.getERC721Details("0x11c3a46087b34870C23452E5A62326E324ec1360");

    // await conversion.getERC721Details("0x60f969Dd2c310C65E13bB9c9FEC75dc4F9144576");

    // console.log("For USDT ------------------------------");

    // console.log("swap Trace price", await conversion.getSwapPrice(USDC, Trace));

    // console.log("Base token Price", await conversion.getBaseTokenInUSD());

    // console.log("Target Token price USDT", await conversion.getTargetTokenInUSD(USDT));

    // console.log("USDT Price ", await conversion.convertFee(USDT, "1000000000000000000"));

    // console.log("Target Token price USDC", await conversion.getTargetTokenInUSD(USDC));

    // console.log("USDC Price ", await conversion.convertFee(USDC, "1000000000000000000"));

    // console.log("Target Token price- Matic", await conversion.getTargetTokenInUSD(MATIC));

    // console.log("matic price ", await conversion.convertFee(MATIC, "1000000000000000000"));

    // console.log("Trace price ", await conversion.convertFee(Trace, "1000000000000000000"));


}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })