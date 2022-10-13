async function main() {

    const Venue = await ethers.getContractFactory("AdminFunctions")
    let EventsV1Proxy = await upgrades.upgradeProxy("0xD4Da245ba5912Be5F8275aE017F38cF422bBbBbf", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
