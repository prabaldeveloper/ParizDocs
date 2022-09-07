async function main() {

    const EventsV1 = await ethers.getContractFactory("EventsV1")
    let EventsV1Proxy = await upgrades.upgradeProxy("0x7e2c1d661ED252451774c6f5d0b0aa552eAEa7A6", EventsV1)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
