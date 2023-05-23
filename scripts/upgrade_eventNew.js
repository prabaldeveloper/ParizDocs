async function main() {

    const Venue = await ethers.getContractFactory("EventCall")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x21277fFE24A413828273aec9785903EDE902E74A", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
