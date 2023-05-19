async function main() {

    const Venue = await ethers.getContractFactory("Conversion")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xCfe3FB78359FA72bA1da6b824971E7eD4B1D0FAE", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
