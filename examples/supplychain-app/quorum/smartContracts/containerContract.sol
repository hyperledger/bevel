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
        require(msg.sender == manufactorer, "Only manufactorers can create contracts");
        _;
    }

    function createContract(
        //mapping (string => string) memory _misc,
        string memory _health,
        string memory _trackingID,
        string memory _lastScannedAt,
        string[] memory _counterparties) public onlyManufactorers{

        for( uint j = 0; j < _counterparties.length; j++){
            //if(_counterparties[j] == identity){
                health = _health;
                trackingID = _trackingID;
                lastScannedAt = _lastScannedAt;
                participants = _counterparties;
                timestamp = now;
                containerID = "";
            //     custodian = identity;
            // }
        }
    }
}