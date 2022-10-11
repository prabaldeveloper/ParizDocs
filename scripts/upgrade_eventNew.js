async function main() {

    const Venue = await ethers.getContractFactory("TicketMaster")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x9C57d0C1aA00fb4E43b49334c260717ae645904A", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
