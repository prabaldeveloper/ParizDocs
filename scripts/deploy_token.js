

const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const Token = await ethers.getContractFactory("Token721");
    const TokenProxy = Token.attach("0x8E3DB4bf0Cbfed015F56643b6030bDB2aA45A06F");
    // const TokenProxy = await Token.deploy();
    // await TokenProxy.deployed();
    console.log("Token Address", TokenProxy.address);
    //await new Promise(res => setTimeout(res, 3000));
    // await TokenProxy.initialize("Guys", "RG");
    
    

    // await TokenProxy.mint(accounts[0], 1)
    // await TokenProxy.mint(accounts[0], 2)
    // await TokenProxy.mint(accounts[0], 3)
    // await TokenProxy.mint(accounts[0], 4)
    // await TokenProxy.mint(accounts[0], 5)
    // await TokenProxy.mint(accounts[0], 6)

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 7);

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 8);

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 9);

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 10);

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 11);

    // await TokenProxy.mint("0xE80CBA78510db3D9890aE826c95C79ac9306b741", 12);

    // await TokenProxy.mint("0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18", 13);

    // await TokenProxy.mint("0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18", 14);

    // await TokenProxy.mint("0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18", 15);

    // await TokenProxy.mint("0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18", 16);

    // await TokenProxy.mint("0x1e1f81176A625e5a4a097704e9D5C3747Ef48D18", 17);

    // await TokenProxy.mint(accounts[0], 18);

    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",19);

    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",20);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",21);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",22);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",23);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",24);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",25);
    // await TokenProxy.mint("0x6a2dc29d33a433478a5ab8e9e16285c2ba46edc4",26);



    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",27);
    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",28);
    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",29);
    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",30);
    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",31);
    await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",32);
    







    // console.log(await TokenProxy.ownerOf(1));
    console.log("minted");
    

}



main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})