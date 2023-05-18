async function main() {

    const Venue = await ethers.getContractFactory("EventsV2")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xc8677C605080Ab0aa7d47C890fe36f6DD7d834f3", Venue)
    //let EventsV1Proxy = await upgrades.forceImport("0xA45491B909fb5C1ae1f318Cb46E32Aa91Ea3F10e", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
