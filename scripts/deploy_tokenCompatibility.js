const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const router = "0x8954AfA98594b838bda56FE4C12a09D7739D179b"
    const factory = "0x5757371414417b8c6caad45baef941abc7d3ab32"

    const tokenCompatibility = await ethers.getContractFactory("TokenCompatibility");
    //const tokenCompatibilityContract = await upgrades.deployProxy(tokenCompatibility, { initializer: 'initialize' });
    const tokenCompatibilityContract = tokenCompatibility.attach("0x3dfba822644bD55c8275Dfe42b2b69646182dB24")
    await new Promise(res => setTimeout(res, 2000));
    //await tokenCompatibilityContract.deployed();
    console.log("TokenCompatibility Contract", tokenCompatibilityContract.address);
    
    // await tokenCompatibilityContract.addPriceFeedAddress("BTC","0x007A22900a3B98143368Bd5906f8E17e9867581b");
    // //await new Promise(res => setTimeout(res, 2000));
    
    // await tokenCompatibilityContract.addPriceFeedAddress("DAI","0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046");
    // //await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("ETH","0x0715A7794a1dc8e42615F059dD6e406A6594651A");
    //await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("EUR","0x7d7356bF6Ee5CDeC22B216581E48eCC700D0497A");
    // await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("LINK","0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408");
    // await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("MATIC","0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada");
    // //await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("SAND","0x9dd18534b8f456557d11B9DDB14dA89b2e52e308");
    // await new Promise(res => setTimeout(res, 2000));
    
    // await tokenCompatibilityContract.addPriceFeedAddress("SOL","0xEB0fb293f368cE65595BeD03af3D3f27B7f0BD36");
    // await new Promise(res => setTimeout(res, 2000));
    
    // await tokenCompatibilityContract.addPriceFeedAddress("USDC","0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0");
    // //await new Promise(res => setTimeout(res, 2000));

    // await tokenCompatibilityContract.addPriceFeedAddress("USDT","0x92C09849638959196E976289418e5973CC96d645");
    //await new Promise(res => setTimeout(res, 2000));

    //await tokenCompatibilityContract.adminUpdate(router, factory);

    // console.log("Read Functions");

    // console.log("BTC", await tokenCompatibilityContract.getPriceFeedAddress("BTC"));

    // console.log("DAI", await tokenCompatibilityContract.getPriceFeedAddress("DAI"));

    // console.log("ETH", await tokenCompatibilityContract.getPriceFeedAddress("ETH"));

    // //check compatibility
    console.log(await tokenCompatibilityContract.checkCompatibility("0xAB36a4c46D93F385082C40BE85fE1458480a02d7", "BTC"));

    // // 8 decimal token
    console.log(await tokenCompatibilityContract.checkCompatibility("0x4b020734168D4e23f12fba8250Aa957Cb16eFb8A", "Test8"));

    // console.log(await tokenCompatibilityContract.checkCompatibility("0xBDa3c5ec872Ec75D09957d8a6A8F6df4F8C1D435", "Test18"));

    // console.log(await tokenCompatibilityContract.isERC721("0x2a87119C747BFDC2C724837b873919e83655f68f"));


}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //chainlink Contract 0xE4f83D8f83ab2B00fB726A431f51e3568428dF6f