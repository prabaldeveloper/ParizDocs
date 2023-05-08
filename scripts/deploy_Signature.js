const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const sign = await ethers.getContractFactory("VerifySignature");
    const signContract =  await upgrades.deployProxy(sign);
    //const signContract = await sign.deploy();

    console.log("signContract proxy", signContract.address);




}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
