async function main() {
    const upgradeTreasury = await ethers.getContractFactory("Treasury")
    let upgradeTreasuryProxy = await upgrades.upgradeProxy("0xE29005B2fFEB8FBbA92a859365b600aec78c9cb7", upgradeTreasury)
    console.log("Your upgraded proxy is done!", upgradeTreasuryProxy.address)
    // console.log(await upgradeConversionProxy.owner())
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
