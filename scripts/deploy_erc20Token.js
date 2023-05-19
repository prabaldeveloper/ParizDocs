

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Token = await ethers.getContractFactory("Token");
    //const TokenProxy = Token.attach("0xa7DaEDa2b350D8a7e8185aF13dA143127A19ffb4");
    const TokenProxy = await Token.deploy();
    // await TokenProxy.deployed();
    console.log("Token Address", TokenProxy.address);
    //await new Promise(res => setTimeout(res, 3000));
    //For ethereum
    //await TokenProxy.initialize("Ethereum", "ETH",18, "1000000000000000000000000");
    
    //For bitcoin
    //await TokenProxy.initialize("Bitcoin", "BTC", 8, "1000000000000000000000000");
    
    


    

}



main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})
