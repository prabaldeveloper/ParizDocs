async function main() {

    const EventsV1 = await ethers.getContractFactory("EventsV1")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x241D564d552ADacFE74b695D1309d110591c3eC9", EventsV1)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
