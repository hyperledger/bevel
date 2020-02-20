const ContainerContract = artifacts.require("ContainerContract");

const containers = [
    {
        health: "good",
        misc: "\{ 'name': 'Expensive Dextrose' \}",
        trackingID: "jjj",
        lastScannedAt: " ",
        counterparties: ["PartyA","PartyB","PartyC"]
    },
    {
        health: "bad",
        misc: "\{ 'name': 'Cheap Daisy' \}",
        trackingID: "aaa",
        lastScannedAt: " ",
        counterparties: ["PartyD","PartyE","PartyF"]
    }
]

contract("ContainerContract", (accounts) => {
    let [manufacturer] = accounts;
    let contractInstance;

    beforeEach(async () => {
        contractInstance = await ContainerContract.new();
    });

    it("Should be able to create a new container", async () => {
        const result = await contractInstance.addContainer(
            containers[0].health, 
            containers[0].misc,
            containers[0].trackingID,
            containers[0].lastScannedAt,
            containers[0].counterparties);
        assert.equal(result.receipt.status, true);
        assert.equal(result.receipt.logs[0].args.ID, containers[0].trackingID);
    })


    it("Should be able to get all containers", async () => {
        const result = await contractInstance.getAllContainers();
        assert.equal(result.receipt.status, true);
    })

    it("Should be able to get single container", async () => {
        const createResult = await contractInstance.addContainer(
            containers[0].health, 
            containers[0].misc,
            containers[0].trackingID,
            containers[0].lastScannedAt,
            containers[0].counterparties);
        const result = await contractInstance.getSingleContainer(containers[0].trackingID);
        assert.equal(result.receipt.status, true);
        console.log(createResult);

    })


})



// const CryptoZombies = artifacts.require("CryptoZombies");
// const zombieNames = ["Zombie 1", "Zombie 2"];
// contract("CryptoZombies", (accounts) => {
//     let [alice, bob] = accounts;

//     // start here

//     it("should be able to create a new zombie", async () => {
//         const contractInstance = await CryptoZombies.new();
//         const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
//         assert.equal(result.receipt.status, true);
//         assert.equal(result.logs[0].args.name,zombieNames[0]);
//     })

//     //define the new it() function
// })
