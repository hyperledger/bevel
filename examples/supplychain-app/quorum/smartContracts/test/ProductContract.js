const ProductContract = artifacts.require("ProductContract");

contract("CryptoZombies", (accounts) => {
    let [manufacturer] = accounts;
    let contractInstance;

    beforeEach(async () => {
        contractInstance = await ProductContract.new();
    });

    it("Should be able to create a new product", async () => {
        const result = await contractInstance.addProduct("Test product",
            " ",
            "\{ 'name': 'Expensive Dextrose' \}",
            "Product ID",
            //FIXME: Update with a more meaningful value
            "Here?");
        assert.equal(result.receipt.status, true);
    })
})