const { ethers } = require("hardhat")
async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);

    const venue = await ethers.getContractFactory("Venue");
    // const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
    const venueContract = await venue.attach("0xb63E63e8FbA2Ab8cde4AC85bE137565A584c9BC9")
    await venueContract.deployed();
    // await new Promise(res => setTimeout(res, 1000));

    console.log("Venue proxy", venueContract.address);

    // const venue = await hre.ethers.getContractFactory("Venue");
    // const venueContract = await venue.attach("0xa349553a541597b44a2347d088d3facaeb3e5f6a");

    // await venueContract.updateVenueRentalCommission(5);
    // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Convention Center", "12,092", "Fashion Show", 50, "3000000000000", "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
    // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Fashion Gallery", "12,093", "Concert", 20, "10000000000000", "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");
    // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Conference Room", "12,094", "Conference", 100, "350000000000000", "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1");
    // // await new Promise(res => setTimeout(res, 1000));

    // await venueContract.add("Pariz Executive Room", "12,095", "Meetup", 30, "20000000000000", "QmcbVTKvi6HrhHMEZnZrujkqdkTHbaj5EcDnUBKu2PTtx5");

    await venueContract.add("Genius Zone 90", "15,090", "Meetup", 80, "200000", "QmYwNGTYp1t9CegkkJaLJNmtHWss5tKT2Rxptqv76nbZd5");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("Genius Zone 91", "15,091", "Meetup", 40, "20000", "QmfNxK3xWkdTe7KW6VyJQxXj3DSChT7xcYq2Tfd9yvnHMt");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("Genius Zone 92", "15,092", "Meetup", 10, "10000", "QmdeTKX9127pbYCVHok5jSY4R9eWthFSQ7oDR4cFE5Bq9y");

    await venueContract.add("Genius Zone 93", "15,093", "Meetup", 20, "90000", "QmWfKeMXA6nCVpzof7KKNunSjrRwpZcoz2uDCpqEdu7RVg");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("Genius Zone 94", "15,094", "Meetup", 30, "100000", "QmQfbFP2bsKyXS9HyT85TLvkoi7KGaSPgEt7DMAKgWP1Vk");

    await venueContract.add("Genius Zone 95", "15,095", "Meetup", 40, "70000", "QmPzzWqHTr5v8hsB6AVoUFhkipfTiKqWzwiN1tK75QfQLt");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("Genius Zone 96", "15,096", "Meetup", 70, "4000", "QmVwLQr7cKRsPVinbZ93pUzPBwoxr1WtZHKSb5ka9Kro2b");

    await venueContract.add("Genius Zone 97", "15,097", "Meetup", 30, "3000", "QmQBniwH2YNWBtnWZdqa5P9yaKm1xqrPSafSq23ZMNnoVv");

    await venueContract.add("Genius Zone 98", "15,098", "Meetup", 45, "70000", "QmYBV6ESzD9CGGuaEUALAncTyKNdToLgagmR68J4zmKnXw");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("Genius Zone 99", "15,099", "Meetup", 200, "2000", "QmNWG4yJy64Q9Wbi1yFKyPgLbWSX7k3mZMV9GxoSWJNaBJ");

    await venueContract.add("Genius Zone 100", "15,100", "Meetup", 55, "1000", "QmTqrspcTcVYkFty8E4zARA9JwQ3UmgGvbCsnjZ6XBc76G");
    await new Promise(res => setTimeout(res, 1000));
    console.log("Meetup added");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Horizon 90", "16,090", "Conference", 15, "3000", "QmPJCpfRCuxydoSq946HyUpNcGYizT2pVZbQDkrh56YJJk");

    await venueContract.add("The Horizon 91", "16,091", "Conference", 35, "2000", "QmXtPofFc1NckpeZ5wiA79WvThJAShNDJWh6X8RpXL2YgC");

    await venueContract.add("The Horizon 92", "16,092", "Conference", 45, "1000", "QmXEbc3v9oHUsmkJJdhX76skfHHDMMLTjZZYoqXDWsZ9LT");

    await venueContract.add("The Horizon 93", "16,093", "Conference", 50, "1000", "QmRxvALoH4syNqRJuTYx4jcbFgkVzCukEibLQX482psFG3");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Horizon 94", "16,094", "Conference", 15, "5000", "QmRX27CpY3TZWWxDYkpVoVzDh5WYCPvj9VnqTrPA8DeTX5");

    await venueContract.add("The Horizon 95", "16,095", "Conference", 25, "7000", "QmegcpPtTFD2BAxCNdPFiUMYwSGXBQdPajGAJefENJdVr9a");

    console.log("Conference Added");

    await venueContract.add("The Gallery 90", "17,090", "Fashion Show", 15, "4500", "QmWv99wucFXFdrAAREnnKvYzBw3XhFYvZcJWAtp2vDhetn");

    await venueContract.add("The Gallery 91", "17,091", "Fashion Show", 20, "5500", "QmWHsGj5NeMyUhHa6ipYL6DAxmobVHnuDTci7F3jmZtGFC");

    await venueContract.add("The Gallery 92", "17,092", "Fashion Show", 30, "6600", "QmQuPev7gqDsjUJ5YGf1YzACLJVD8RdGL1ggWvW1yGDYGk");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Gallery 93", "17,093", "Fashion Show", 50, "7500", "QmWdz4NvLuN4B1uSAMZXSSSFJwHFYTnyZFJuvKASdk46Yd");

    await venueContract.add("The Gallery 94", "17,094", "Fashion Show", 40, "9500", "QmXMaWGPRaac6ciASsDqKMSNx8g6Ncdpj8E7FJLup3eqxV");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Gallery 95", "17,095", "Fashion Show", 15, "2000", "Qmbv7agWd22cN5Wei33yjKNoBkbhBsZKVV5gJfBd779Naf");
    await new Promise(res => setTimeout(res, 1000));
    console.log("Fashion Show Added");

    await venueContract.add("The Greenhouse 90", "18,090", "Concert", 15, "2000", "QmRh7yL1S16R2zbJXFV8MnNodHDHNE8ogcVUDsyvQ7Uy2E");

    await venueContract.add("The Greenhouse 91", "18,091", "Concert", 20, "1000", "Qmeg7rXq35AwAhNtzwQKk7X7J73inqzHXA9Q7q9DxfPvqf");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Greenhouse 92", "18,092", "Concert", 100, "5000", "QmRmjcLtFTENUUVECrv2XrDDypnZ8Vx6c9uVatKHFAJeUn");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Greenhouse 93", "18,093", "Concert", 100, "6000", "QmYe3VsnpauqSB6kjCM4263vjcSUMkK5mqg3AH1pQG9vdh");
    await new Promise(res => setTimeout(res, 1000));
    await venueContract.add("The Greenhouse 94", "18,094", "Concert", 50, "9500", "QmdWF4WuAabxgFs6gM9kVxg9kA2iQefBnbkBDjPGrsmari");

    await venueContract.add("The Greenhouse 95", "18,095", "Concert", 60, "35000", "QmSv9XerS4pDk5VmZhS2qSezLHaeGw2jk5jaqdcoNMF5Fp");
    await new Promise(res => setTimeout(res, 1000));
    console.log("Concert Added");
    



}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })


// Venue proxy 0x85c7eE172B92F0f1393f98926adF320c434E3262
// conversion proxy 0x02e90531aac91fD8e6B8a5F323cE171DD3c29AdF

//New
//Venue Proxy 0xD959B719922b7b70b2AC4b10D466aAbE3745d86c

//Local venue = "0x78B3CeB87C561e746d0Cec5195BDE870E11Ca81d"