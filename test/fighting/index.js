var chai = require('chai');
var expect = require('chai').expect
const BigNumber = require('bignumber.js');

chai.use(require('chai-bignumber')());

const { ethers } = require("hardhat");
async function deploy(){
  const FighterNFT = await ethers.getContractFactory('FighterNFT');
  return await FighterNFT.deploy().then((f)=> f.deployed());
}
describe("Fighter NFT", function () {
  before(async function(){
    this.accounts = await ethers.getSigners();
    this.firstUser = this.accounts[0];
    this.secondUser = this.accounts[1];
    this.fighterNFT = await deploy();

  })
  context('Setting up nfts', async function(){
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
  
      expect(BigNumber.isBigNumber(striking)).to.equal(true);
      expect(BigNumber.isBigNumber(grappling)).to.equal(true);
      expect(BigNumber.isBigNumber(stamina)).to.equal(true);
      expect(BigNumber.isBigNumber(health)).to.equal(true);
      expect(BigNumber.isBigNumber(PA)).to.equal(true);
    })
    it('should return combined stats of fighter', async function(){
      await this.fighterNFT.safeMint(this.firstUser.address);
      let result = await this.fighterNFT.combinedStats(0);
      expect(BigNumber.isBigNumber(result)).to.equal(true);
    })
  })
  context('Starting up fights', async function(){
    it('should send fight offer', async function(){
      await this.fighterNFT.safeMint(this.firstUser.address);
      await this.fighterNFT.safeMint(this.secondUser.address);
  
      expect(await this.fighterNFT.connect(this.firstUser)
      .sendFightOffer(this.secondUser.address, 0, 1))
      .to.emit(this.fighterNFT, 'FightOfferEmit')
      .withArgs(this.firstUser.address, this.secondUser.address, 0, 1)
    })
    it('should start fight', async function(){
      await this.fighterNFT.safeMint(this.firstUser.address);
      await this.fighterNFT.safeMint(this.secondUser.address);
      await this.fighterNFT.connect(this.firstUser)
      .sendFightOffer(this.secondUser.address, 0, 1);
      
      expect(await this.fighterNFT.connect(this.secondUser)
      .acceptFightOffer(this.firstUser.address, 0, 0, 1))
      .to.emit(this.fighterNFT, 'AcceptFightOffer')
      .withArgs(0);
    })
    it('shouldnt start fight', async function(){
      await this.fighterNFT.safeMint(this.firstUser.address);
      await this.fighterNFT.safeMint(this.secondUser.address);
  
      expect(await this.fighterNFT.connect(this.secondUser)
      .acceptFightOffer(this.secondUser.address, 0,0, 1))
      .to.not.emit(this.fighterNFT, 'AcceptFightOffer')
      .withArgs(0);
    })
  })
});