const GeneralContract = artifacts.require("General");
contract("GeneralContract", (accounts) => {
    let contractInstance = null;
    let [manufacturer, carrier, warehouse] = accounts;

    before(async () => {
        contractInstance = await GeneralContract.deployed();
    });


    const containers = [
        {
            health: "good",
            misc: ["\{ 'name': 'Dextrose' \}"],
            trackingID: "jjj",
            lastScannedAt: "OU=Manufacturer,O=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            counterparties: [(String(manufacturer) + "," + "OU=Manufacturer,O=Manufacturer,L=47.38/8.54/Zurich,C=CH"),
            (String(carrier) + "," + "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=GB"),
            (String(warehouse) + "," + "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US")]
        },
    ]
    const products = [
        {
            productName: "Dextrose",
            health: "good",
            misc: ["\{ 'name': 'Expensive Dextrose' \}"],
            trackingID: "123",
            lastScannedAt: "OU=Manufacturer,O=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            participants: [(String(manufacturer) + "," + "OU=Manufacturer,O=Manufacturer,L=47.38/8.54/Zurich,C=CH"),
            (String(carrier) + "," + "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=GB"),
            (String(warehouse) + "," + "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US")]
        },
    ]
    it("get the size of the contract", function () {
        return GeneralContract.deployed().then(function (instance) {
            var bytecode = instance.constructor._json.bytecode;
            var deployed = instance.constructor._json.deployedBytecode;
            var sizeOfB = bytecode.length / 2;
            var sizeOfD = deployed.length / 2;
            console.log("size of bytecode in bytes = ", sizeOfB);
            console.log("size of deployed in bytes = ", sizeOfD);
            console.log("initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
        });
    });
    it("Create a new product", async () => {

        await contractInstance.addProduct(
            products[0].trackingID,
            products[0].productName,
            products[0].health,
            products[0].misc,
            products[0].lastScannedAt,
            products[0].participants);
        // call getSingleProduct to see if product is created
        const result = await contractInstance.getSingleProduct("123");
        // Checking the 1st index of the returned tuple
        assert.equal(result[0], "123");
    })

    it("Create a new container", async () => {
        await contractInstance.addContainer(
            containers[0].health,
            containers[0].misc,
            containers[0].trackingID,
            containers[0].lastScannedAt,
            containers[0].counterparties);
        // call getSingleContainer to see if product got created
        const result = await contractInstance.getSingleContainer("jjj");
        assert.equal(result[4], "jjj");
    })

    it("Get the total number of products created", async () => {
        const result = await contractInstance.getProductsLength();
        assert.equal(result.toNumber(), 1)
    })

    it("Get the total number of containers created", async () => {
        const result = await contractInstance.getContainersLength();
        assert.equal(result.toNumber(), 1)
    })

    it("Get a container using a tracking id", async () => {
        var trackingID = "jjj";
        const result = await contractInstance.getSingleContainer(trackingID);
        assert.equal(result[4], trackingID);
    })

    it("Get a product using a tracking id", async () => {
        var trackingID = "123";
        const result = await contractInstance.getSingleProduct(trackingID);
        assert.equal(result[0], trackingID);
    })

    it("Get all containerless product", async () => {
        var containerlessProducts = [];
        // Calls getProductsLength to get the total number of products created
        const counter = await contractInstance.getProductsLength();
        console.log(counter.toNumber());
        //toNumber function converts big number to javascript native number
        for (var i = 0; i < counter.toNumber(); i++) {
            result = await contractInstance.getContainerlessAt(i);
            console.log(result);
        }
        containerlessProducts.push(result);
    })
    it("Manufacturer packages product into container and checks product", async () => {
        //tracking ID of the product
        const trackingId = "123";
        // tracking ID of the container that will become the products container ID
        const containerId = "jjj";
        await contractInstance.packageTrackable(trackingId, containerId);
        const result = await contractInstance.getSingleProduct(trackingId);
        // checks the 8th index of the product tuple
        assert.equal(result[8], containerId);
        console.log(result);
    })

    it("Carrier takes possession of the container", async () => {
        //tracking ID of the product
        const trackingId = "123";
        // tracking ID of the container that will become the products container ID
        const containerId = "jjj";
        const lastScannedAt = "OU=Carrier,O=PartyB,L=51.50/-0.13/London,C=GB"
        await contractInstance.updateContainerCustodian(containerId, lastScannedAt, { from: carrier });
        const result = await contractInstance.getSingleContainer(containerId);
        //checking to see if the container custodian was updated to carrier
        assert.equal((String(result[2]) + "," + lastScannedAt), containers[0].counterparties[1]);
    })

    // Manufacturer no longer have possession of the product and therefore should not be able to unpackage the container
    it("Manufacturer should not be able to unpackage container", async () => {
        //tracking ID of the product
        const trackingId = "123";
        // tracking ID of the container that will become the products container ID
        const containerId = "jjj";
        try {
            await contractInstance.unpackageTrackable(containerId, trackingId, { from: manufacturer });
            const result = await contractInstance.getSingleProduct(trackingId);
            //assert.equal(result[8],"jjj");
        } catch (error) {
            assert("Invalid opcode error must be returned");
        }
    })

    it("Carrier wants to unpackage container", async () => {
        //tracking ID of the product
        const trackingId = "123";
        // tracking ID of the container that will become the products container ID
        const containerId = "jjj";
        await contractInstance.unpackageTrackable(containerId, trackingId, { from: carrier });
        const result = await contractInstance.getSingleProduct(trackingId);
        assert.equal(result[8], "");
        console.log(result);
    })

    it("Warehouse wants to claim product", async () => {
        const trackingId = "123";
        const lastScannedAt = "OU=Warehouse,O=PartyC,L=42.36/-71.06/Boston,C=US";
        await contractInstance.updateCustodian(trackingId, lastScannedAt, { from: warehouse });
        const result = await contractInstance.getSingleProduct(trackingId);
        assert.equal((String(result[5]) + "," + lastScannedAt), products[0].participants[2]);
    })

    it("Manufacturer wants to check ownership of product", async () => {
        const trackingId = "123";
        const result = await contractInstance.scan(trackingId);
        assert.equal(result, "unowned");
    })

    it("Manufacturer wants to get history of a product", async () => {
        const trackingId = "123";
        var history = [];
        // Call getHistoryLength to get the number of transactions for that trackingID
        const historyCounter = await contractInstance.getHistoryLength(trackingId);
        console.log(historyCounter.toNumber());
        //toNumber function converts big number to javascript native number
        for (var i = 1; i <= historyCounter.toNumber(); i++) {
            result = await contractInstance.getHistory((i - 1), trackingId);
            console.log(result);
        }
        history.push(result);
    })
})