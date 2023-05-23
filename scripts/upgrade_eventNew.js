async function main() {

    const Venue = await ethers.getContractFactory("TokenCompatibility")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xadfC90401FB4c56D68AeF5Eb8a55E610BCD3b580", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
