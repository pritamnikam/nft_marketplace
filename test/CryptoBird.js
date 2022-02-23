const { assert } = require('chai');

const CryptoBird = artifacts.require("CryptoBird");

// check the chai
require('chai')
.use(require('chai-as-promised'))
.should()

// contract("CryptoBird", function (/* accounts */) {
//   it("should assert true", async function () {
//     await CryptoBird.deployed();
//     return assert.isTrue(true);
//   });
// });

contract("CryptoBird", (accounts) => {
    let contract

    beforeEach( async () => {
        contract = await CryptoBird.deployed()
    })
    
    describe("Deployment", async () => {
        
        it("deploys successfully.", async () => {
            
            const address = contract.address;
            // assert.notEqual(address, null)
            // assert.notEqual(address, undefined)
            // assert.notEqual(address, 0x0)
            // assert.notEqual(address, '')
            expect(address).to.be.not.undefined;
            expect(address).to.be.not.null;
            expect(address).to.be.not.NaN;
            expect(address).to.not.empty;

        });

        it("has a name.", async () => {
            
            const name = await contract.name();
            // assert.equal(name, "CryptoBird")
            expect(name).to.equal("CryptoBird");
        });

        it("has a symbol.", async () => {
            
            const symbol = await contract.symbol();
            // assert.equal(symbol, "CRYPTOB")
            expect(symbol).to.equal("CRYPTOB");
        });

    });

    describe("Minting", async () => {
        
        it("create a new token.", async () => {
            await contract.mint('img1');
            const totalSupply = await contract.totalSupply();

            // success
            assert.equal(totalSupply, 1)
            // expect(totalSupply).to.equal(1);

            // failure
            await contract.mint('img1').should.be.rejected
        });

        it("emits transfer event", async () => {
            const result = await contract.mint('img2');
            const event = result.logs[0].args;
            // assert.equal(event._from, '0x0000000000000000000000000000000000000000')
            // assert.equal(event._to, accounts[0])
            // assert.equal(event._tokenId, 0)
            expect(event._from).to.equal('0x0000000000000000000000000000000000000000');
            expect(event._to).to.equal(accounts[0]);
        });

    });

    describe("Indexing", async () => {
        
        it("lists crypto tokens.", async () => {
            await contract.mint('img3');
            await contract.mint('img4');
            await contract.mint('img5');

            const totalSupply = await contract.totalSupply();
            assert.equal(totalSupply, 5)
            // expect(totalSupply).to.equal(5);

            const owner = await contract.ownerOf(2);
            // assert.equal(owner, accounts[0])
            expect(owner).to.equal(accounts[0]);

            // const tokens = await contract.balanceOf(accounts[0]);
            // assert.equal(tokens, totalSupply)
        });

        // it("loop  through list of crypto tokens.", async () => {
        //     const totalSupply = await contract.totalSupply();
        //     assert.equal(totalSupply, 5)

        //     let result = [];
        //     for (i = 0; i <totalSupply; ++i) {
        //         const tokenID = await contract._cryptoBirds[i];
        //         result.push(tokenID);
        //     }

        //     const expected = ['img1', 'img2', 'img3', 'img4', 'img5'];
        //     assert.equal(expected.join(', '), result.join(', '));
        // });

    });
});
  