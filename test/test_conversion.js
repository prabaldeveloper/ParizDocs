const {
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Conversion", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshopt in every test.
    async function deployState() {
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();

        const ConversionV1 = await ethers.getContractFactory("ConversionV1");
        const conversionV1 = await ConversionV1.deploy();

        await conversionV1.initialize();

        return { conversionV1, owner, otherAccount };
    };

    describe("Deployment", function () {
        it("call convertFee", async function () {
            const { conversionV1, owner, otherAccount } = await loadFixture(
                deployState
            );
            console.log(await conversionV1.convertFee("0x0000000000000000000000000000000000000000", "1000000000000000000"));
        })
    });
});