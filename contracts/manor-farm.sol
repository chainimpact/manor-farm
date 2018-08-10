pragma solidity ^0.4.24;

/*
Tracking history of an animals life and general data.
This can be used for domestic uses such as dog or cats and their vaccines and generic documents as
well as for more specialized animals such as race horses, livestock and/or exotic animals.

As a first version, we will focus on domestic animals and add more functionality for livestock
at a later date.
*/
contract Animals {

    string public name;
    bytes12 public birthdate;
    bytes12 public deathdate;
    string public species;
    string public breed;
    string public color;
    address public dam;
    address public sire;
    string public chipId;
    string public tattooId;
    address public currentMaster;

    constructor (
        address _currentMaster,
        string _name,
        bytes12 _birthdate,
        string _species,
        string _breed,
        string _color,
        address _dam,
        address _sire,
        string _chipId,
        string _tattooId
        ) public {
        currentMaster = _currentMaster;
        name = _name;
        birthdate = _birthdate;
        species = _species;
        breed = _breed;
        color = _color;
        dam = _dam;
        sire = _sire;
        chipId = _chipId;
        tattooId = _tattooId;
    }

    /*
    TODO:
    add all feeds and pharmaceuticals used in raising the animal
    add location of moements between the animals's origin and place of slaughter (if applicable)
    add movement of specific animal products from the processing plant to the retail consumer (if applicable)
    */

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

    // all the animal's previous owners as well as the
    // current owner on the last index.
    address[] public mastersList;
    // custodians are pre-approved veterinarians, medics, government
    // appointees and other entities.
    address[] public custodiansList;
    // certified custodians at national or international level
    // TODO: research this subject
    address[] public certifiedCustodiansList;

    // array with list of all medical events done on this animal
    // ie. a dog has a rabies vaccine injected and this is recorded here
    MedicalEvent[] public medicalHistory;

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

    struct MedicalEvent {
        string name;
        string date;
        bool ended;
        address custodian;
        MedicalEventType medicalEventType;
        /* string eventType; */
    }

    function addMedicalAct(string _name, string _date, bool _ended, address _custodian, MedicalEventType _medicalEventType) hasRestrictedAccess() {
        medicalHistory.push({
            name : _name,
            date : _date,
            ended : _ended,
            custodian : _custodian,
            medicalEventType : _medicalEventType
        });
    }

    // all prizes including medals, diplomas, prize money, tropheys, purses,
    Prize[] public prizesHistory;

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

    // commented for now because of the following error:

    /* TypeError: This type is only supported in the new experimental ABI
    encoder. Use "pragma experimental ABIEncoderV2;" to enable the feature. */
    /*
    function getPrizes() public returns (Prize[]) {
        return prizesHistory;
    }
    */

    function getCustodians() public view returns (address[]) {
        return custodiansList;
    }

    function getCertifiedCustodians() public view returns (address[]) {
        return certifiedCustodiansList;
    }
}
