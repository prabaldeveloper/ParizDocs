async function main() {

    const Venue = await ethers.getContractFactory("TicketMasterV1")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xD037144cDf6beCdB96857497f11E7DDbd2070eEd", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
