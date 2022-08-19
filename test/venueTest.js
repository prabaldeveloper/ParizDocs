const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Venue", function ()  {
    async function deployState() {
        const [owner, otherAccount] = await ethers.getSigners();
        const venue = await ethers.getContractFactory("Venue");
        const venueContract = await upgrades.deployProxy(venue, { initializer: 'initialize' })
        await venueContract.deployed();
        await venueContract.updateVenueRentalCommission(5);
        await venueContract.add("Pariz Convention Center", "12,092", "Concert", 50, 100000000, "QmUtVYmeTh2kALCGJhbHPeu5ezLXSbSpV9rVcZRdFsTGNG");
        await venueContract.add("Pariz Fashion Gallery", "12,093", "Fashion Show", 20, 200000001, "QmZnwDAg98s3Qq8aYd1Xoz1hJu3dYa8J76JeUHs6M5fnqM");

        return {venueContract, owner, otherAccount};

    };

    describe("Deployment", function() {
        it("is venue rental commission updated", async function() {
            const {venueContract, owner, otherAccount} = await loadFixture(
                deployState
            );
            expect(await venueContract.getVenueRentalCommission()).to.equal(5);
        })
        it("is owner", async function () {
            const { venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            expect(await venueContract.owner()).to.equal(owner.address);
        })
    });

    describe("Update", function() {
        it("should be called only by the owner - updateVenueRentalCommission", async function() {
            const {venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            await expect(venueContract.connect(otherAccount).updateVenueRentalCommission(10)).to.be.revertedWith("Ownable: caller is not the owner");
            
        })
        it("should be called only by the owner - addVenue", async function() {
            const {venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            await expect(venueContract.connect(otherAccount).add("Pariz Conference Room", "12,094", "Conference", 100, 400000002, "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1")).to.be.revertedWith("Ownable: caller is not the owner");
            
        })
    });

    describe("Invalid Inputs", function() {
        it("invalid inputs - totalCapacity", async function() {
            const {venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            await expect(venueContract.add("Pariz Conference Room", "12,094", "Conference", 0, 400000002, "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1")).to.be.revertedWith("Venue: Invalid inputs");
        })

        it("invalid inputs - rentPerBlock", async function() {
            const {venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            await expect(venueContract.add("Pariz Conference Room", "12,094", "Conference", 100, 0, "QmPc29mi28h31zDh9dydGDdxukpUSqti2eVXz4oRC99KB1")).to.be.revertedWith("Venue: Invalid inputs");
        })

        it("invalid inputs - tokenId does not exist", async function() {
            const {venueContract, owner, otherAccount } = await loadFixture(
                deployState
            );
            await expect(venueContract.getTotalCapacity(5)).to.be.revertedWith("Venue: TokenId does not exist");
        })
    });

})
