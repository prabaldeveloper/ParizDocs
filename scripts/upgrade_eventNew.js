async function main() {

    const Venue = await ethers.getContractFactory("ManageEventV1")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xE94679A8d229F0e77Caf4B422A3894f3A691C30D", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
