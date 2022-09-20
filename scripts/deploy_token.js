

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Token = await ethers.getContractFactory("Token721");
    const TokenProxy = await Token.attach("0x8E3DB4bf0Cbfed015F56643b6030bDB2aA45A06F");
    //const TokenProxy = await Token.deploy();
    //await TokenProxy.initialize("Test NFT", "Test NFT");
    console.log("Token Address", TokenProxy.address);

    await TokenProxy.mint(accounts[0], 1)
    await TokenProxy.mint(accounts[0], 2)
    await TokenProxy.mint(accounts[0], 3)
    await TokenProxy.mint(accounts[0], 4)
    await TokenProxy.mint(accounts[0], 5)
    await TokenProxy.mint(accounts[0], 6)

    console.log(await TokenProxy.ownerOf(1));
    console.log("minted");
    

}



main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})