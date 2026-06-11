#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY modules
#endif

class KPCF {
    class main {
        file = MODULES_DIRECTORY\kp_cratefiller\KPCF\fnc;

        class init {
            postInit = 1;
        };

        class addEquipment {};
        class createEquipmentList {};
        class createSubList {};
        class deleteCrate {};
        class deletePreset {};
        class export {};
        class getConfigPath {};
        class getInventory {};
        class getItems {};
        class getNearStorages {};
        class import {};
        class manageActions {};
        class manageAceActions {};
        class openDialog {};
        class removeEquipment {};
        class setActiveStorage {};
        class setInventory {};
        class showInventory {};
        class showPresets {};
        class sortList {};
        class spawnCrate {};
    };
};
