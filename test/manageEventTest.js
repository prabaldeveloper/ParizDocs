const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
//const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

describe("ManageEvent", function () {
    
    async function deployState() {
        const [owner, otherAccount] = await ethers.getSigners();
        const manageEvent = await ethers.getContractFactory("ManageEvent");
        const manageEventContract = await upgrades.deployProxy(manageEvent,{initializer: 'initialize'});
        await manageEventContract.deployed();

        // const manageEventContractAddress = manageEventContract.address;

        await manageEventContract.updateVenueContract("0x85c7eE172B92F0f1393f98926adF320c434E3262");
        
        const venueContract = await manageEventContract.getVenueContract();

        await manageEventContract.updateEventContract("0x26705B80a694bD5F9451E29aB3000FDCb19c3b51");
    
        const eventContract = await manageEventContract.getEventContract();

        return {manageEventContract, owner, otherAccount, venueContract, eventContract};

    };

    describe("Deployment", function() {
        it("are contracts updated at deployment", async function() {
            const {manageEventContract, owner, otherAccount, venueContract, eventContract } = await loadFixture(
                deployState
            );
            expect(await manageEventContract.getVenueContract()).to.equal(venueContract)

            expect(await manageEventContract.getEventContract()).to.equal(eventContract)
        })
        it("is owner", async function () {
            const { manageEventContract, owner, otherAccount, venueContract, eventContract } = await loadFixture(
                deployState
            );
            expect(await manageEventContract.owner()).to.equal(owner.address);
        })

    describe("Update", function() {
        it("should be called only by the owner", async function() {
            const {manageEventContract, owner, otherAccount, venueContract, eventContract } = await loadFixture(
                deployState
            );
            expect(await manageEventContract.connect(otherAccount).updateVenueContract(venueContract)).to.be.revertedWith("Ownable: caller is not the owner");
            
        })
        it("should revert if passed non contract address", async function() {
            const {manageEventContract, owner, otherAccount, venueContract, eventContract } = await loadFixture(
                deployState
            );
            expect(await manageEventContract.connect(otherAccount).updateVenueContract(owner.address)).to.be.revertedWith("Ownable: caller is not the owner");
            
        })
    })
    })

 
})