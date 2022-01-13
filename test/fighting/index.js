const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
async function deploy(){
  const FighterNFT = await ethers.getContractFactory('FighterNFT');
  return await FighterNFT.deploy().then((f)=> f.deployed());
}
describe("Fighter NFT", function () {
  before(async function(){
    this.accounts = await ethers.getSigners();
    this.firstUser = this.accounts[0];
    this.fighterNFT = await deploy();
  })
  it("should give 2 nfts", async function () {
    let oldNFTs = await this.fighterNFT.balanceOf(this.firstUser.address);
    await this.fighterNFT.safeMint(this.firstUser.address);
    await this.fighterNFT.safeMint(this.firstUser.address);
    let newNFTBalance = await this.fighterNFT.balanceOf(this.firstUser.address);
    await expect(oldNFTs.eq(0));
    await expect(newNFTBalance.eq(2));
  });
  it('should have correct address for first nft', async function(){
    await this.fighterNFT.safeMint(this.firstUser.address);
    expect(this.firstUser.address == await this.fighterNFT.ownerOf(0));
  })
  it('should have "random" stats', async function(){
    await this.fighterNFT.safeMint(this.firstUser.address);
    let striking = await this.fighterNFT.getStriking(0);
    let grappling = await this.fighterNFT.getGrappling(0);
    let stamina = await this.fighterNFT.getStamina(0);
    let health = await this.fighterNFT.getHealth(0);
    let PA = await this.fighterNFT.getPA(0);

    expect(striking.eq(5));
    expect(grappling.eq(9));
    expect(stamina.eq(4));
    expect(health.eq(3));
    expect(PA.eq(9));
  })
  it('should return combined stats of fighter', async function(){
    await this.fighterNFT.safeMint(this.firstUser.address);
    let result = await this.fighterNFT.combinedStats(0);
    expect(result.eq(18))
  })
});