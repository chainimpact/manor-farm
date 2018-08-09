pragma solidity ^0.4.24;


contract Animals {

    string public name;
    string public birthdate;
    string public deathdate;
    string public race;
    string public species;
    string public color;
    address public dam;
    address public sire;
    uint public chipId;
    address public currentMaster;

    enum Sex {male, female, other, none}
    Sex public sex;

    MedicalEvent[] public medicalHistory;
    Prize[] public prizesHistory;

    modifier isCustodian(){
        require (
            custodiansList[msg.sender] != 0
            );
            _;
    }

    modifier hasRestrictedAccess(address _account){
        require (
            msg.sender == currentMaster
            || custodiansList[msg.sender] != 0
            );
            _;
    }

    address[] public mastersList;

    address[] public custodiansList;

    /* TODO: research all types of medical events */
    enum MedicalEventType {operation, vaccine, sickness, checkup}
    MedicalEventType public medicalEventType;

    /* Permissions setup: */
    modifier isMaster {
        require(msg.sender == currentMaster);
        _;
    }

    modifier isCustodian {
        require();
        _;
    }

    struct MedicalEvent {
        MedicalEventType medicalEventType;
        string name;
        string eventType;
        string date;
        bool ended;
        address custodian;
    }

    struct Prize {
        /* EventType eventType; */
        /* IPFS url */
        string eventName;
        string prizeName;
        string eventType;
        string date;
        address masterAtDate;
        bool certified;
    }

    function addMedicalAct(_act) restrictedAccess() {
        medicalHistory.push(_act);
    }

    function changeMaster (newMaster) restrictedAccess {
        require(isCustodian() || msg.sender == currentMaster;
        currentMaster = newMaster;
        mastersList.push(newMaster);
    }

    function addSire(address _sire) restrictedAccess {
        require(isCustodian() || msg.sender == currentMaster);
        sire = _sire;
    }

    /* dam is the female parent */
    function addDam(address _dam) restrictedAccess {
        require(isCustodian() || msg.sender == currentMaster);
        dam = _dam;
    }

    function certifyPrize (uint index) {
        require (isCustodian(msg.sender));
        prizesHistory[index].certified = true;
    }

}
