

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Token = await ethers.getContractFactory("Token");
    // const TokenProxy = await Token.attach(Trace);
    const TokenProxy = await Token.deploy();
    console.log(TokenProxy.address);

    await TokenProxy.mint(accounts[0], "2000000000000000000000000000")
    console.log("minted");
    

}















main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})