pragma solidity ^0.4.24;


contract Animals {

    string public name;
    unint256 public birthdate;
    unint256 public deathdate;
    string public race;
    string public species;
    string public color;
    address public dam;
    address public sire;
    uint public chipId;
    address public currentMaster;

    /*
    TODO: modify birthdate and deathdate from strings to better data types.
    function set(uint256 _birthdate) {
        birthdate = _birthdate;
    }
    function set(uint256 _deathdate) {
        deathdate = _deathdate;
    } */

    // exotic animals might have fringe cases, so other and none were added
    enum Sex {male, female, other, none}
    Sex public sex;

    // array with list of all medical events done on this animal
    // ie. a dog has a rabies vaccine injected and this is recorded here
    MedicalEvent[] public medicalHistory;
    // all prizes including medals, diplomas, prize money, tropheys, purses,
    Prize[] public prizesHistory;

    address[] public mastersList;
    address[] public custodiansList;

    /* TODO: research all types of medical events.
    categories might be fuzzy in which case a variable string
    might be better suited.*/
    enum MedicalEventType {vaccine, surgery, pharmacology, sickness, checkup, hospitalization, other}
    MedicalEventType public medicalEventType;

    /* TODO: research all types of medical events.
    categories might be fuzzy in which case a variable string
    might be better suited.*/
    enum PrizeType {
        goldMedal,
        silverMedal,
        bronzeMedal,
        otherMedal,
        diploma,
        prizeMoney,
        trophey,
        purse,
        award,
        badge,
    }
    PrizeType public prizeType;

    /* Permissions setup: */
    modifier isMaster {
        require(msg.sender == currentMaster);
        _;
    }

    modifier hasRestrictedAccess(){
        require (
            msg.sender == currentMaster
            || assert(custodiansList[msg.sender] == 0x0);
            );
            _;
    }

    function isCustodian() returns (bool) {
        for (uint i=0; i<custodiansList; i++) {
            return
        }

        require (custodiansList[msg.sender].name != 0);
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
        // TODO: add prizeType enum and check if it works
        // PrizeType prizeType;
        string prizeType;
        string date;
        address masterAtDate;
        bool certified;
    }

    function addMedicalAct(MedicalEvent _act) hasRestrictedAccess() {
        medicalHistory.push(_act);
    }

    function changeMaster (address newMaster) hasRestrictedAccess() {
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
