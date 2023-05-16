const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const chainlink = await ethers.getContractFactory("ChainLinkPriceFeed");
    const chainlinkContract = await upgrades.deployProxy(chainlink, { initializer: 'initialize' });

    await new Promise(res => setTimeout(res, 2000));
    await chainlinkContract.deployed();
    console.log("chainlink Contract", chainlinkContract.address);
    
    await chainlinkContract.addPriceFeedAddress("BTC","0x007A22900a3B98143368Bd5906f8E17e9867581b");
    await new Promise(res => setTimeout(res, 2000));
    
    await chainlinkContract.addPriceFeedAddress("DAI","0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("ETH","0x0715A7794a1dc8e42615F059dD6e406A6594651A");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("EUR","0x7d7356bF6Ee5CDeC22B216581E48eCC700D0497A");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("LINK","0x1C2252aeeD50e0c9B64bDfF2735Ee3C932F5C408");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("MATIC","0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("SAND","0x9dd18534b8f456557d11B9DDB14dA89b2e52e308");
    await new Promise(res => setTimeout(res, 2000));
    
    await chainlinkContract.addPriceFeedAddress("SOL","0xEB0fb293f368cE65595BeD03af3D3f27B7f0BD36");
    await new Promise(res => setTimeout(res, 2000));
    
    await chainlinkContract.addPriceFeedAddress("USDC","0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0");
    await new Promise(res => setTimeout(res, 2000));

    await chainlinkContract.addPriceFeedAddress("USDT","0x92C09849638959196E976289418e5973CC96d645");
    await new Promise(res => setTimeout(res, 2000));





}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //chainlink Contract 0xE4f83D8f83ab2B00fB726A431f51e3568428dF6f