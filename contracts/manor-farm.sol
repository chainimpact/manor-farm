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

    address[] public mastersList;
    address[] public custodiansList;

    /* TODO: research all types of medical events */
    enum MedicalEventType {operation, vaccine, sickness, checkup, other}
    MedicalEventType public medicalEventType;

    /* Permissions setup: */
    modifier isMaster {
        require(msg.sender == currentMaster);
        _;
    }

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

    struct MedicalEvent {
        string name;
        string date;
        bool ended;
        address custodian;
        MedicalEventType medicalEventType;
        /* string eventType; */
    }

    struct Prize {
        /* IPFS url */
        string eventName;
        string prizeName;
        string prizeType;
        string date;
        address masterAtDate;
        bool certified;
    }

    function addMedicalAct(_act) hasRestrictedAccess() {
        medicalHistory.push(_act);
    }

    function changeMaster (newMaster) hasRestrictedAccess {
        require(isCustodian() || msg.sender == currentMaster);
        currentMaster = newMaster;
        mastersList.push(newMaster);
    }

    function addSire(address _sire) hasRestrictedAccess {
        require(isCustodian() || msg.sender == currentMaster);
        sire = _sire;
    }

    /* dam is the female parent */
    function addDam(address _dam) hasRestrictedAccess {
        require(isCustodian() || msg.sender == currentMaster);
        dam = _dam;
    }

    function certifyPrize (uint index) {
        require (isCustodian(msg.sender));
        prizesHistory[index].certified = true;
    }

}
