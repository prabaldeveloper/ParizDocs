

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Token = await ethers.getContractFactory("Token721");
    const TokenProxy = await Token.attach("0x25878178dCd3a55f2BAb89DfB6370B3a8f64db44");
    // const TokenProxy = await Token.deploy();
    // await TokenProxy.initialize("Test NFT", "Test NFT");
    // console.log(TokenProxy.address);

    // await TokenProxy.mint(accounts[0], 1)
    // await TokenProxy.mint(accounts[0], 2)

    console.log(await TokenProxy.ownerOf(1));
    console.log(await TokenProxy.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"));
    console.log("minted");
    

}















main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})