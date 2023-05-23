

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const ETH =  "0x9088732B7AB6Ab8c2132494160E006A74690f5f1";
    const BTC =  "0xAB36a4c46D93F385082C40BE85fE1458480a02d7";

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
    
    //For testing 8 decimals
    //await TokenProxy.initialize("Test8", "Test8", 8, "10000000000000000000000");
    //Token Address 0x4b020734168D4e23f12fba8250Aa957Cb16eFb8A


    //For testing 18 decimals
    //await TokenProxy.initialize("Test18", "Test18", 18, "1000000000000000000000000");
    //Token Address 0xBDa3c5ec872Ec75D09957d8a6A8F6df4F8C1D435

    //await TokenProxy.initialize("Testusdc18", "Testusdc18", 18, "1000000000000000000000000");
    //Token Address 0xFc5A44F53A8f4BEb50200EC9e833dbA76A33d6d2

    //await TokenProxy.initialize("Testusdc8", "Testusdc8", 8, "1000000000000000000000000");
    //Token Address 0xa318B9a9dcB02A433F286D39086DC6119A25Efa6

    


    

}



main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})
