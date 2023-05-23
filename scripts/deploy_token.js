

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



    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",27);
    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",28);
    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",29);
    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",30);
    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",31);
    // await TokenProxy.mint("0xfbae6Ab495FcBdEc876AD19761295BCD85C1f67B",32);

    // await TokenProxy.mint("0x018D0DAFC01e195c1274E59714941e6E21D447ab",23);
    // await TokenProxy.mint("0x018D0DAFC01e195c1274E59714941e6E21D447ab",24);
    // await TokenProxy.mint("0x018D0DAFC01e195c1274E59714941e6E21D447ab",25);
    // await TokenProxy.mint("0x018D0DAFC01e195c1274E59714941e6E21D447ab",26);
    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",55);
    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",56);
    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",57);
    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",58);
    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",59);
    // await TokenProxy.mint("0xdc4a5fc7a3c2dd304f7b44a7954fd4e5cb64c076",60);
    // await TokenProxy.mint("0xdc4a5fc7a3c2dd304f7b44a7954fd4e5cb64c076",61);
    // await TokenProxy.mint("0xdc4a5fc7a3c2dd304f7b44a7954fd4e5cb64c076",62);
    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",63);
    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",64);
    // await TokenProxy.mint("0xdc4a5fc7a3c2dd304f7b44a7954fd4e5cb64c076",65);
    // await TokenProxy.mint("0xdc4a5fc7a3c2dd304f7b44a7954fd4e5cb64c076",66);
    // await TokenProxy.mint("0xcC225f978A16C55dC3df39627a37c4226F5b27bD",64);
    // await TokenProxy.mint("0xcC225f978A16C55dC3df39627a37c4226F5b27bD",65);
    // await TokenProxy.mint("0xcC225f978A16C55dC3df39627a37c4226F5b27bD",66);
    // await TokenProxy.mint("0xcC225f978A16C55dC3df39627a37c4226F5b27bD",67);

    // await TokenProxy.mint("0x018d0dafc01e195c1274e59714941e6e21d447ab",68);
    // await TokenProxy.mint("0x018d0dafc01e195c1274e59714941e6e21d447ab",69);
    // await TokenProxy.mint("0x018d0dafc01e195c1274e59714941e6e21d447ab",70);
    // await TokenProxy.mint("0x018d0dafc01e195c1274e59714941e6e21d447ab",71);

    // await TokenProxy.mint("0xc3b3cee5c0b87e972fd95692809ed799e2529861",72);
    // await TokenProxy.mint("0xc3b3cee5c0b87e972fd95692809ed799e2529861",73);
    // await TokenProxy.mint("0xc3b3cee5c0b87e972fd95692809ed799e2529861",74);
    // await TokenProxy.mint("0xc3b3cee5c0b87e972fd95692809ed799e2529861",75);

    // await TokenProxy.mint("0x7cCD435E84544dcD75E4617F92AB28AD043C4ecD",74);
    // await TokenProxy.mint("0x7cCD435E84544dcD75E4617F92AB28AD043C4ecD",75);
    // await TokenProxy.mint("0x7cCD435E84544dcD75E4617F92AB28AD043C4ecD",76);
    // await TokenProxy.mint("0x7cCD435E84544dcD75E4617F92AB28AD043C4ecD",77);


    // await TokenProxy.mint("0xdC4A5fC7A3C2dd304F7B44a7954fD4E5cB64c076",78);

    // await TokenProxy.mint("0xdC4A5fC7A3C2dd304F7B44a7954fD4E5cB64c076",79);

    // await TokenProxy.mint("0xdC4A5fC7A3C2dd304F7B44a7954fD4E5cB64c076",80);

    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",81);

    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",82);

    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",83);

    // await TokenProxy.mint("0x75dc8E7515be89D43cf31C2E50e6abc4478f57F9",84);

    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",85);

    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",86);

    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",87);

    // await TokenProxy.mint("0x274DC0B318b3918d01b94d84bEAD5e1452Aaf521",88);

    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",41);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",42);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",43);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",44);

    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",45);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",46);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",47);
    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",48);

    // await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",49);


    
    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",97);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",98);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",99);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",100);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",101);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",102);

    await TokenProxy.mint("0x5966da6E4F91aF45a2d45f422A7A6681387Dd19c",103);

    




    


    

    

    








    // console.log(await TokenProxy.ownerOf(1));
    console.log("minted");
    

}



main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error)
    process.exit(1)
})
