const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    const adminContract = "0x5DF40949F4063132E7C181A41C1e0edd3D99A7E5";
    const venue = await ethers.getContractFactory("Venue");
    const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
    //const venueContract = await venue.deploy();
    // const venueContract = venue.attach("0x09020bC6935186Dbb437b9451e863B97F8B8EcE4");
    // await venueContract.deployed();
    // await new Promise(res => setTimeout(res, 5000));

    console.log("Venue proxy", venueContract.address);

    await venueContract.updateAdminContract(adminContract);

    // await new Promise(res => setTimeout(res, 1000));
    //await venueContract.updateVenueFees(1, "100000000000000");
    await venueContract.add("PARIZ GENESIS PLAZA 1", "1,1,1", "EVENT", 10000, "100000000000000", "Qmas98PywDFmqjxaCq6vp4s4zmv3vT2Wxw5BSymM7VJicZ", "0xdC4A5fC7A3C2dd304F7B44a7954fD4E5cB64c076");
    await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Fashion Gallery", "12,093", "Concert", 20, "10000000000000", "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
    // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Conference Room", "12,094", "Conference", 100, "350000000000000", "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1");
    // // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Executive Room", "12,095", "Meetup", 30, "20000000000000", "QmcbVTKvi6HrhHMEZnZrujkqdkTHbaj5EcDnUBKu2PTtx5");

    // await venueContract.add("Genius Zone 90", "15,090", "Meetup", 80, "10000000000000000", "QmYwNGTYp1t9CegkkJaLJNmtHWss5tKT2Rxptqv76nbZd5");
    // // // await venueContract.updateVenueFees(5, "10000000000000000");

    // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("Genius Zone 91", "15,091", "Meetup", 40, "10000000000000", "QmfNxK3xWkdTe7KW6VyJQxXj3DSChT7xcYq2Tfd9yvnHMt");
    // // // await venueContract.updateVenueFees(6, "10000000000000");
    
    // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("Genius Zone 92", "15,092", "Meetup", 10, "20000000000000", "QmdeTKX9127pbYCVHok5jSY4R9eWthFSQ7oDR4cFE5Bq9y");
    // // // await venueContract.updateVenueFees(7, "20000000000000");

    // await venueContract.add("Genius Zone 93", "15,093", "Meetup", 20, "200000000000000", "QmWfKeMXA6nCVpzof7KKNunSjrRwpZcoz2uDCpqEdu7RVg");
    // // await venueContract.updateVenueFees(8, "200000000000000");
    // await new Promise(res => setTimeout(res, 1000));
    
    // await venueContract.add("Genius Zone 94", "15,094", "Meetup", 30, "15000000000000", "QmQfbFP2bsKyXS9HyT85TLvkoi7KGaSPgEt7DMAKgWP1Vk");
    // // await venueContract.updateVenueFees(9, "15000000000000");

    // await venueContract.add("Genius Zone 95", "15,095", "Meetup", 40, "25000000000000", "QmPzzWqHTr5v8hsB6AVoUFhkipfTiKqWzwiN1tK75QfQLt");
    // // await venueContract.updateVenueFees(10, "25000000000000");

    // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("Genius Zone 96", "15,096", "Meetup", 70, "35000000000000", "QmVwLQr7cKRsPVinbZ93pUzPBwoxr1WtZHKSb5ka9Kro2b");
    // await venueContract.updateVenueFees(11, "35000000000000");
    
    // await venueContract.add("Genius Zone 97", "15,097", "Meetup", 30, "10000000000000", "QmQBniwH2YNWBtnWZdqa5P9yaKm1xqrPSafSq23ZMNnoVv");
    // // await venueContract.updateVenueFees(12, "10000000000000")
    
    // await venueContract.add("Genius Zone 98", "15,098", "Meetup", 45, "10000000000000", "QmYBV6ESzD9CGGuaEUALAncTyKNdToLgagmR68J4zmKnXw");
    // // await venueContract.updateVenueFees(13, "10000000000000")
    // // await new Promise(res => setTimeout(res, 1000));
    
    // await venueContract.add("Genius Zone 99", "15,099", "Meetup", 200, "1500000000000", "QmNWG4yJy64Q9Wbi1yFKyPgLbWSX7k3mZMV9GxoSWJNaBJ");
    // // await venueContract.updateVenueFees(14, "1500000000000")
    
    // await venueContract.add("Genius Zone 100", "15,100", "Meetup", 55, "30000000000000", "QmTqrspcTcVYkFty8E4zARA9JwQ3UmgGvbCsnjZ6XBc76G");
    // // await venueContract.updateVenueFees(15, "30000000000000")
    // await new Promise(res => setTimeout(res, 1000));
    // console.log("Meetup added");
    
    // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("The Horizon 90", "16,090", "Conference", 15, "3000000000000", "QmPJCpfRCuxydoSq946HyUpNcGYizT2pVZbQDkrh56YJJk");
    // // await venueContract.updateVenueFees(16, "3000000000000")

    // await venueContract.add("The Horizon 91", "16,091", "Conference", 35, "3000000000000", "QmXtPofFc1NckpeZ5wiA79WvThJAShNDJWh6X8RpXL2YgC");
    // // await venueContract.updateVenueFees(17, "3000000000000")
    
    // await venueContract.add("The Horizon 92", "16,092", "Conference", 45, "9000000000000", "QmXEbc3v9oHUsmkJJdhX76skfHHDMMLTjZZYoqXDWsZ9LT");
    // // await venueContract.updateVenueFees(18, "9000000000000")
    
    // await venueContract.add("The Horizon 93", "16,093", "Conference", 50, "70000000000000", "QmRxvALoH4syNqRJuTYx4jcbFgkVzCukEibLQX482psFG3");
    // // // // await venueContract.updateVenueFees(19, "70000000000000")
    // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("The Horizon 94", "16,094", "Conference", 15, "2100000000000", "QmRX27CpY3TZWWxDYkpVoVzDh5WYCPvj9VnqTrPA8DeTX5");
    // // // // await venueContract.updateVenueFees(20, "2100000000000")

    // await venueContract.add("The Horizon 95", "16,095", "Conference", 25, "210000000000000", "QmegcpPtTFD2BAxCNdPFiUMYwSGXBQdPajGAJefENJdVr9a");
    // // await venueContract.updateVenueFees(21, "210000000000000")
    // console.log("Conference Added");

    // await venueContract.add("The Gallery 90", "17,090", "Fashion Show", 15, "4100000000000", "QmWv99wucFXFdrAAREnnKvYzBw3XhFYvZcJWAtp2vDhetn");
    // // await venueContract.updateVenueFees(22, "4100000000000")

    // await venueContract.add("The Gallery 91", "17,091", "Fashion Show", 20, "5100000000000", "QmWHsGj5NeMyUhHa6ipYL6DAxmobVHnuDTci7F3jmZtGFC");
    // // await venueContract.updateVenueFees(23, "5100000000000")

    // await venueContract.add("The Gallery 92", "17,092", "Fashion Show", 30, "3200000000000", "QmQuPev7gqDsjUJ5YGf1YzACLJVD8RdGL1ggWvW1yGDYGk");
    // // await venueContract.updateVenueFees(24, "3200000000000")

    // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("The Gallery 93", "17,093", "Fashion Show", 50, "4200000000000", "QmWdz4NvLuN4B1uSAMZXSSSFJwHFYTnyZFJuvKASdk46Yd");
    // // await venueContract.updateVenueFees(25, "4200000000000")

    // await venueContract.add("The Gallery 94", "17,094", "Fashion Show", 40, "11000000000000", "QmXMaWGPRaac6ciASsDqKMSNx8g6Ncdpj8E7FJLup3eqxV");
    // // await venueContract.updateVenueFees(26, "11000000000000")

    // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("The Gallery 95", "17,095", "Fashion Show", 15, "7100000000000", "Qmbv7agWd22cN5Wei33yjKNoBkbhBsZKVV5gJfBd779Naf");
    // // await venueContract.updateVenueFees(27, "7100000000000")

    // // await new Promise(res => setTimeout(res, 1000));
    // console.log("Fashion Show Added");

    // await venueContract.add("The Greenhouse 90", "18,090", "Concert", 15, "1100000000000", "QmRh7yL1S16R2zbJXFV8MnNodHDHNE8ogcVUDsyvQ7Uy2E");
    // // await venueContract.updateVenueFees(28, "1100000000000")

    // await venueContract.add("The Greenhouse 91", "18,091", "Concert", 20, "32000000000000", "Qmeg7rXq35AwAhNtzwQKk7X7J73inqzHXA9Q7q9DxfPvqf");
    // // await venueContract.updateVenueFees(29, "32000000000000")

    // await new Promise(res => setTimeout(res, 1000));
   
    // await venueContract.add("The Greenhouse 92", "18,092", "Concert", 100, "1200000000000", "QmRmjcLtFTENUUVECrv2XrDDypnZ8Vx6c9uVatKHFAJeUn");
    // // await venueContract.updateVenueFees(30, "1200000000000")

    // // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("The Greenhouse 93", "18,093", "Concert", 100, "3400000000000", "QmYe3VsnpauqSB6kjCM4263vjcSUMkK5mqg3AH1pQG9vdh");
    // // await venueContract.updateVenueFees(31, "3400000000000")

    // // // await new Promise(res => setTimeout(res, 1000));
    // await venueContract.add("The Greenhouse 94", "18,094", "Concert", 50, "2560000000000", "QmdWF4WuAabxgFs6gM9kVxg9kA2iQefBnbkBDjPGrsmari");
    // // await venueContract.updateVenueFees(32, "2560000000000")

    // await venueContract.add("The Greenhouse 95", "18,095", "Concert", 60, "7350000000000", "QmSv9XerS4pDk5VmZhS2qSezLHaeGw2jk5jaqdcoNMF5Fp");
    // // await venueContract.updateVenueFees(33, "7350000000000")
    // // // await new Promise(res => setTimeout(res, 1000));
    // console.log("Concert Added");
    



}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
