pragma solidity ^0.4.24;

// TODO:
/* Permission: Admin, Veterinaire, Publique, currentMaster */

contract Animals {

    string public name;
    string public birthdate;
    string public deathdate;
    string public race;
    string public species;
    string public color;
    address public father;
    address public mother;
    uint public chipId;

    MedicalEvent[] public medicalHistory;
    Prize[] public prizesHistory;

    /* TODO: research all types of medical events */
    /* enum EventType {operation, vaccin, maladie} */

    struct MedicalEvent{
        /* EventType eventType; */
        string name;
        string eventType;
        string date;
        bool ended;
        address careTaker;
    }

    struct Prize{
        /* EventType eventType; */
        string eventName;
        string prizeName;
        string eventType;
        string date;
        address ownerAtDate;
        bool certified;
    }

    // TODO: check sex enum
    /* enum Sex {male, female, hermaphrodite, none} */
    /* Sex public sex; */

    constructor () public {
        sex = Sex.male;
    }

}
