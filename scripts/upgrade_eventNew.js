async function main() {

    const ticketMaster = await ethers.getContractFactory("EventsV1")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x41906638f1E3b42a851aFE57c05Bc5c9bEC4194A", ticketMaster)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
