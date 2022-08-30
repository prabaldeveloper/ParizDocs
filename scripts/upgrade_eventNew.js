async function main() {

    const TicketMaster = await ethers.getContractFactory("TicketMaster")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xbc257563d5b1e31db8a96183a98483b93383a1db", EventsV1)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
