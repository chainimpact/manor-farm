pragma solidity ^0.4.24;

/**
@title manor farm: domestic animal's traceability
@author chainimpact.io

Tracking history of an animals life and general data.
This can be used for domestic uses such as dog or cats and their vaccines and generic documents as
well as for more specialized animals such as race horses, livestock and/or exotic animals.

As a first version, we will focus on domestic animals and add more functionality for livestock
at a later date.
*/

/*
TODO:
add all feeds and pharmaceuticals used in raising the animal
add location of moements between the animals's origin and place of slaughter (if applicable)
add movement of specific animal products from the processing plant to the retail consumer (if applicable)

TODO: modify birthdate and deathdate from strings to better data types.
ie:
function set(uint256 _birthdate) {
    birthdate = _birthdate;
}
function set(uint256 _deathdate) {
    deathdate = _deathdate;
} */

contract Animal {

    string public name;
    address public currentMaster;
    // small problem in remix when trying to input these values
    // must input hex values
    bytes12 public birthdate;
    bytes12 public deathdate;
    string public species;
    string public breed;
    string public color;
    address public femaleParent;
    address public maleParent;
    string public chipId;
    string public tattooId;

    // all the animal's previous owners as well as the
    // current owner on the last index.
    address[] public mastersList;
    // custodians are pre-approved veterinarians, medics, government
    // appointees and other entities.
    address[] public custodiansList;
    // certified custodians at national or international level
    // TODO: research this subject
    // TODO: fix `call to Animals.certifiedCustodiansList errored: VM error: invalid opcode`
    address[] public certifiedCustodiansList;

    // array with list of all medical events done on this animal
    // ie. a dog has a rabies vaccine injected and this is recorded here
    MedicalEvent[] public medicalHistory;

    // exotic animals might have fringe cases, so other and none were added
    enum Sex {male, female, other, none}
    Sex public sex;

    // all prizes including medals, diplomas, prize money, tropheys, purses,
    Prize[] public prizesHistory;

    PrizeType private prizeType;
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
    MedicalEventType private medicalEventType;

    struct MedicalEvent {
        string name;
        string date;
        bool ended;
        address custodian;
        MedicalEventType medicalEventType;
        /* string eventType; */
    }
    // 0x1115b7d915458ef540ade6068dfe2f44e8fa7111
    // helper string for constructor
    // "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "spotty", "201010011200", "dog", "terrier", "black", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "ab123", "ab123"
    // "spotty","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x323031303130303131323030","0","dog","terrier","black","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","ab123","ab123"
    constructor (
        string _name,
        address _currentMaster,
        bytes12 _birthdate,
        Sex _sex,
        string _species,
        string _breed,
        string _color,
        address _femaleParent,
        address _maleParent,
        string _chipId,
        string _tattooId
        ) public {
        name = _name;
        currentMaster = _currentMaster;
        birthdate = _birthdate;
        sex = _sex;
        species = _species;
        breed = _breed;
        color = _color;
        femaleParent = _femaleParent;
        maleParent = _maleParent;
        chipId = _chipId;
        tattooId = _tattooId;

        mastersList.push(_currentMaster);
    }

    function addMedicalAct(
        string _name,
        string _date,
        bool _ended,
        address _custodian,
        MedicalEventType _medicalEventType
    ) hasRestrictedAccess() public {
            medicalHistory.push(MedicalEvent({
                name: _name,
                date: _date,
                ended: _ended,
                custodian: _custodian,
                medicalEventType: _medicalEventType
            }));
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
        require(_addr == currentMaster, "Must be animal`s current Master to do this action.");
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

    /*
    TODO: get cerrtifiedcustodians from external regitry list or TCR
    */
    // function isCertifiedCustodian(address _addr) public view returns (bool) {
    // }

    // either master or custodian have access
    modifier hasRestrictedAccess(){
        require (
            isMaster(msg.sender) ||
            isCustodian(msg.sender), // ||
            // isCertifiedCustodian(msg.sender),
            "This action has restricted access. Must be either current master, custodian or certifiedcustodian."
        );
        _;
    }

    // Change master can only be done by currentMaster or custodian
    function changeMaster (address newMaster) public hasRestrictedAccess() {
        currentMaster = newMaster;
        mastersList.push(newMaster);
    }

    function addCustodian(address addr) public hasRestrictedAccess() {
        custodiansList.push(addr);
    }

    function addMaleParent(address _maleParent) public hasRestrictedAccess {
        maleParent = _maleParent;
    }

    function addfemaleParent(address _femaleParent) public hasRestrictedAccess {
        femaleParent = _femaleParent;
    }

    function addPrize (
        string _eventName,
        string _prizeName,
        string _prizeType,
        string _date,
        address _masterAtDate,
        bool _certified
    ) public hasRestrictedAccess() {
        prizesHistory.push(Prize({
            eventName: _eventName,
            prizeName: _prizeName,
            prizeType: _prizeType,
            date: _date,
            masterAtDate: _masterAtDate,
            certified: _certified
        }));
    }

    /*
    This function will certify a prize already added to the prizelist
    This can only be done by a certifiedCustodian
    */
    function certifyPrize (uint index) public {
        require (isCustodian(msg.sender), "Prize certification can only be done by official Certified Custodians");
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
