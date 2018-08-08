pragma solidity ^0.4.24;

// TODO:
/* Permission: Admin, Veterinaire, Publique, currentMaster

*/


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

    // TODO: check sex enum
    /* enum Sex {male, female, hermaphrodite, none} */
    /* Sex public sex; */

    MedicalEvent[] public medicalHistory;
    Prize[] public prizesHistory;

    modifier restrictedAccess(address _account){
        require (
            /* msg.sender in careTakersList or msg.sender == currentMaster*/
            )
            _;
    }

    function addMedicalAct(_act) restrictedAccess() {
        medicalHistory.push(_act);
    }

    address[] public mastersList;

    address[] public careTakersList;

    /* TODO: research all types of medical events */
    /* enum EventType {operation, vaccine, maladie} */

    /* Permissions setup: */
    modifier isMaster {
        require(msg.sender == currentMaster);
        _;
    }

    modifier isCareTaker {
        require();
        _;
    }

    struct MedicalEvent {
        /* EventType eventType; */
        string name;
        string eventType;
        string date;
        bool ended;
        address careTaker;
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

    function changeMaster (newMaster) restrictedAccess {
        require(is_careTaker() or msg.sender == currentMaster());
        currentMaster = newMaster;
        mastersList.push(newMaster);
    }

    /* to be accurate, "sire" in this context is used as the male parent,
    although not all animals are 4 legged
    same goes for "dam"
    but hey, we don't know the word for generic animal parent. if you do, PR */
    function add_sire(addr) restrictedAccess {

    }

    /* dam is the female parent */
    function add_sire(_dam) restrictedAccess {
        require(is_careTaker() or currentMaster());
        dam = _dam
    }

    function certifyPrize (uint index) {
        require (msg.sender is_careTaker());
        prizesHistory[index].certified = true;
    }



}
