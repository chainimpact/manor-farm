pragma solidity ^0.4.24;


contract Animals {

    string public name;
    uint256 public birthdate;
    uint256 public deathdate;
    string public race;
    string public species;
    string public color;
    address public dam;
    address public sire;
    uint public chipId;
    address public currentMaster;

    constructor (
        string _name,
        uint256 _birthdate,
        uint256 _deathdate,
        string _race,
        string _species,
        string _color,
        address _dam,
        address _sire,
        uint _chipId,
        address _currentMaster
        ) public {
        name = _name;
        birthdate = _birthdate;
        deathdate = _deathdate;
        race = _race;
        species = _species;
        color = _color;
        dam = _dam;
        sire = _sire;
        chipId = _chipId;
        currentMaster = _currentMaster;
    }

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

    // all the animal's previous owners as well as the
    // current owner on the last index.
    address[] public mastersList;
    // custodians are pre-approved veterinarians, medics, government
    // appointees and other entities.
    address[] public custodiansList;
    // certified custodians at national or international level
    // TODO: research this subject
    address[] public certifiedCustodiansList;

    /* TODO: research all types of medical events.
    categories might be fuzzy in which case a variable string
    might be better suited.*/
    enum MedicalEventType {
        vaccine,
        surgery,
        pharmacology,
        sickness,
        checkup,
        hospitalization,
        other
    }
    MedicalEventType public medicalEventType;

    /* TODO: research all types of prize types.
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
        other
    }
    PrizeType public prizeType;

    /*
    Permissions setup:
    isMaster: actions that only the owner of the animal should
    be able to modify
    isCustodian: usually for official actions such as vaccination or prize validation.
    hasRestrictedAccess: generic isMaster or isCustodian restriction.
    */
    // Only current master should have access to some features.
    // ie. only master can change dog's custodiansList
    function isMaster(address _addr) public view returns (bool) {
        require(_addr == currentMaster);
        return true;
    }

    /*
    Only custodians have access to some functions/attributes.
    for example only veterinarians would be able to add medical
    interventions to an animal's medicalHistory list.
    Another example would be prize validation. In which only competition
    organizers can have access.
    */
    function isCustodian(address _addr) public view returns (bool) {
        for (uint i=0; i < custodiansList.length; i++) {
            if (_addr == custodiansList[i]) {
                return true;
            }
            return false;
        }
    }

    // either master or custodian have access
    modifier hasRestrictedAccess(){
        require (isMaster(msg.sender) || isCustodian(msg.sender));
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
        // TODO: add prizeType enum and check if it works
        // PrizeType prizeType;
        string prizeType;
        string date;
        address masterAtDate;
        bool certified;
    }

    // commented for now because of the following error:

    /* TypeError: This type is only supported in the new experimental ABI
    encoder. Use "pragma experimental ABIEncoderV2;" to enable the feature. */
    /* function addMedicalAct(MedicalEvent _act) hasRestrictedAccess() {
        medicalHistory.push(_act);
    } */

    // Change master can only be done by currentMaster or custodian
    function changeMaster (address newMaster) internal hasRestrictedAccess() {
        require(isCustodian(msg.sender) || msg.sender == currentMaster);
        currentMaster = newMaster;
        mastersList.push(newMaster);
    }

    function addcustodian(address addr) internal hasRestrictedAccess() {
        custodiansList.push(addr);
    }

    // dam is the male parent
    function addSire(address _sire) internal hasRestrictedAccess {
        sire = _sire;
    }

    // dam is the female parent
    function addDam(address _dam) internal hasRestrictedAccess {
        dam = _dam;
    }

    /*
    This function will certify a prize already added to the prizelist
    This can only be done by a certifiedCustodian
    */
    function certifyPrize (uint index) internal {
        require (isCustodian(msg.sender));
        prizesHistory[index].certified = true;
    }
}
