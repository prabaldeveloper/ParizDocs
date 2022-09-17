async function main() {

    const Venue = await ethers.getContractFactory("Venue")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xb63E63e8FbA2Ab8cde4AC85bE137565A584c9BC9", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
