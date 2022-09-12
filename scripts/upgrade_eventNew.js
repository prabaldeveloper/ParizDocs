async function main() {

    const ticketMaster = await ethers.getContractFactory("TicketMaster")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xe083507f557A41f7CA839d4a88F1207F1a318014", ticketMaster)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
