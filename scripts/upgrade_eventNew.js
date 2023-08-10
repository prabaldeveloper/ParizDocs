async function main() {

    const Venue = await ethers.getContractFactory("HistoryLounge")
    //let EventsV1Proxy = await upgrades.forceImport("0xcb89cc98A0aCa08b757C50785c55D580EE91880B", Venue);
    let EventsV1Proxy = await upgrades.upgradeProxy("0x1C2856da62a175b457f1691546311c68152dA6FC", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
