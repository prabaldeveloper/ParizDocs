async function main() {

    const ticketMaster = await ethers.getContractFactory("TicketMaster")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xeBD9f8711dB196cb4474e642e5B7E7e54339E868", ticketMaster)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
