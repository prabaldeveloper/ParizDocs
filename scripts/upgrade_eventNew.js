async function main() {

    const Venue = await ethers.getContractFactory("Venue")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x09020bC6935186Dbb437b9451e863B97F8B8EcE4", Venue)
    //let EventsV1Proxy = await upgrades.forceImport("0x09020bC6935186Dbb437b9451e863B97F8B8EcE4", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
