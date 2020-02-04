pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

contract containerContract {
    string public health;
    mapping (string => string) public misc;
    string public custodian;
    string public lastScannedAt;
    uint256 public timestamp;
    string public trackingID;
    string public containerID;
    string[] public contents;
    string[] public participants;

    address manufactorer;
    address identity;

    constructor() public{
        identity = msg.sender;
    }

    modifier onlyManufactorers(){
        require(identity == manufactorer, "Only manufactorers can create contracts");
        _;
    }

    function createContract(
        //mapping (string => string) memory _misc,
        string memory _health,
        string memory _trackingID,
        string memory _lastScannedAt,
        string[] memory _counterparties) public onlyManufactorers{

        //for(uint j = 0; j < _counterparties.length; j++){
          //  if(_counterparties[j] == identity){
                health = _health;
                trackingID = _trackingID;
                lastScannedAt = _lastScannedAt;
                participants = _counterparties;
                timestamp = now;
                containerID = "";
            //     custodian = identity;
            // }
        //}
    }

    function updateContainerCustodian(string memory _containerID) public{
        //require(identity == identity, "HTTP 404");
        //change custodian to us if containerid = containerid
        //check each container in selected container and update custodian
        //return 404
    }

    function getAllContainers() public{

    }

    function getSingleContainer(string memory _containerID) public{
    }

    function updateContainer(
        //mapping (string => string) memory _misc,
        string memory _health,
        string memory _trackingID,
        string memory _lastScannedAt,
        string[] memory _counterparties)
        public {
    }

    function unpackageContainer(        
        string memory _containerID,
        string memory _trackingID
    ) public{
    }

    function packageContainer(
        string memory _containerID,
        string memory _trackingID
    ) public{

    }
