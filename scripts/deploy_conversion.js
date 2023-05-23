const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    // testnet 
    const USDT = "0xf2fe21e854c838c66579f62ba0a60ca84367cd8f"
    const USDC = "0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC"
    const MATIC = "0x0000000000000000000000000000000000000000"
    const ETH =  "0x9088732B7AB6Ab8c2132494160E006A74690f5f1";
    const BTC =  "0xAB36a4c46D93F385082C40BE85fE1458480a02d7";
    const Test8 = "0x4b020734168D4e23f12fba8250Aa957Cb16eFb8A"; //8 decimal paired with trace(done)
    const Test18 = "0xBDa3c5ec872Ec75D09957d8a6A8F6df4F8C1D435"; //18 decimal paired with trace //79.934Test18 per TT(done)
    const Testusdc18 = "0xFc5A44F53A8f4BEb50200EC9e833dbA76A33d6d2"; //18 decimal paired with usdc(done)
    const Testusdc8 = "0xa318B9a9dcB02A433F286D39086DC6119A25Efa6"//8 decimal paired with usdc(done)
    

    const PRICE_MATIC_USD = "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada"
    const PRICE_USDT_USD = "0x92C09849638959196E976289418e5973CC96d645";
    const PRICE_USDC_USD = "0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0";

    const Trace = "0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f"
    const router = "0x8954AfA98594b838bda56FE4C12a09D7739D179b"
    const factory = "0x5757371414417b8c6caad45baef941abc7d3ab32"

    const tokenCompatibilityContract = "0xf30245429Bc7fCDf4ae4f35723Ec85CFc1cCbB29";

    //// ************ DEPLOY CONVERSION **************/////

    const Conversion = await ethers.getContractFactory("Conversion");
    //const conversion = await upgrades.deployProxy(Conversion, { initializer: 'initialize' })
    const conversion = await Conversion.attach("0xCfe3FB78359FA72bA1da6b824971E7eD4B1D0FAE");
    // await new Promise(res => setTimeout(res, 5000));
    console.log("conversion proxy", conversion.address);

    //// ************ ADD PRICE FEED ADDRESS **************/////

    // await new Promise(res => setTimeout(res, 5000));
    // await conversion.addToken(MATIC, PRICE_MATIC_USD);

    // // await new Promise(res => setTimeout(res, 5000));
    // await conversion.addToken(USDC, PRICE_USDC_USD);

    // // await new Promise(res => setTimeout(res, 5000));
    // await conversion.addToken(USDT, PRICE_USDT_USD);

    // await new Promise(res => setTimeout(res, 5000));
    // await conversion.addToken(Trace, router);

    // // await new Promise(res => setTimeout(res, 5000));
    // await conversion.adminUpdate(Trace, router, factory);

    // await conversion.addTokenCompatibilityContract(tokenCompatibilityContract);
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

    //Price conversion 

    // console.log("From Trace to Trace", await conversion.convertFee(Trace, "1000000000000000000"));

    // console.log("From Trace to Usdc", await conversion.convertFee(USDC, "1000000000000000000"));

    // console.log("From Trace to Matic", await conversion.convertFee(MATIC, "1000000000000000000"));

    // console.log("From Trace to Usdt", await conversion.convertFee(USDT, "1000000000000000000"));

    // console.log("From Trace to Eth", await conversion.convertFee(ETH, "1000000000000000000"));

    // console.log("From Trace to Btc", await conversion.convertFee(BTC, "1000000000000000000"));

    console.log("From Trace to 8 decimal token", await conversion.convertFee(Test8, "1000000000000000000"));
    
    console.log("From Trace to 18 decimal token", await conversion.convertFee(Test18, "1000000000000000000"));

    console.log("From Trace to 18 decimal token paired with usdc", await conversion.convertFee(Testusdc18, "1000000000000000000"));

    console.log("From Trace to 8 decimal token paired with usdc", await conversion.convertFee(Testusdc8, "1000000000000000000"));

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
