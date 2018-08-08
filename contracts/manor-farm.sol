pragma solidity ^0.4.24;

// TODO:
/* Permission: Admin, Veterinaire, Publique, currentMaster */

// functionalities:
/*
- Func changeMaster (newMaster) - Accès restreint au currentMaster, Vet, et Admin

- Ajout de newMaster dans MasterTableHistory
currentMaster = newMaster

- Func addMedicalAct(act) - Accès restreint au currentMaster, vet
- Ajout de act dans medicalTable

- Func addPrize(prize)
    Validate = false

- Func validatePrize - Accès restreint Vel

- Func add_male_parent
- Func add_female_parent */


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
    address public currentMaster;

    // TODO: check sex enum
    /* enum Sex {male, female, hermaphrodite, none} */
    /* Sex public sex; */

    MedicalEvent[] public medicalHistory;
    Prize[] public prizesHistory;

    address[] public mastersList;

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
        /* IPFS url */
        string eventName;
        string prizeName;
        string eventType;
        string date;
        address ownerAtDate;
        bool certified;
    }


    /* constructor () public {
        sex = Sex.male;
    } */



}
