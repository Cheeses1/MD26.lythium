# Credit to Belhun and Cutup from 4th ARMCO for creating the script.

if (hasInterface && not isServer) then { 

  [format ["Friendly Fire Script: Player joining %1", name player]] remoteExec ["diag_log", 2];

  player addEventHandler ["Hit", {

    params ["_unit", "_source", "_damage", "_instigator"];

    
      if (!isPlayer _instigator) exitWith {};
      if (!isPlayer _unit) exitWith {};
      if (_instigator isEqualTo _unit) exitWith {
        [format ["%1 Shot Them Self %2", name _unit, name _instigator]] remoteExec ["diag_log", 2];
      };

      if (!isNull (getAssignedCuratorLogic _unit)) exitWith {
        if (isNull (getAssignedCuratorLogic _instigator)) then {
        [format ["Friendly Fire Script Zues: Zues %1 was hit by Player %2", name _unit, name _instigator]] remoteExec ["diag_log", 2];
        };
      };

      if (!isNull (getAssignedCuratorLogic _instigator)) exitWith {
        if (isNull (getAssignedCuratorLogic _unit)) then {
        [format ["Friendly Fire Script Zues: Player %1 hit Zues %2", name _unit, name _instigator]] remoteExec ["diag_log", 2];
        };
      };

      [_instigator] remoteExec ["crowsZA_fnc_addEntryPingBoxHUD", curatorPlayers];
      [module_curator, _instigator] remoteExecCall ["BIS_fnc_curatorPinged", curatorPlayers];
      [format ["Friendly Fire Script Players: %2 was hit by %1", name _instigator, name _unit]] remoteExec ["diag_log", 2];
      ["WARNING!! WARNING!! WARNING!! Your shooting friendlies! Watch your fire!"] remoteExec ["systemChat", _instigator];
      ["WARNING!! Your getting shot by friendlies! Call your leader to let them know!"] remoteExec ["systemChat", _unit];
      [format ["WARNING WARNING!!!!!! %2 was hit by %1",name _instigator, name _unit]] remoteExec ["systemChat", curatorPlayers];

    }];

  ["Friendly Fire Script: Hit Event handler assigned"] remoteExec ["diag_log", 2];

  curatorUpdateEvent = ["zen_curatorDisplayLoaded", {
  
    ["zen_curatorDisplayLoaded", curatorUpdateEvent] call CBA_fnc_removeEventHandler;
    ["Friendly Fire Script: curatorUpdateEvent Fired"] remoteExec ["diag_log", 2];
    _allPlayers = allPlayers - entities "HeadlessClient_F";
    curatorPlayers = [];
    
    {
      if (!isNull (getAssignedCuratorLogic _x)) then {
        curatorPlayers pushBack _x;
      };
    } forEach _allPlayers;

    ["Friendly Fire Script: curatorPlayers Array Updated"] remoteExec ["diag_log", 2];

    publicVariable "curatorPlayers";

    }] call CBA_fnc_addEventHandler;

  ["Friendly Fire Script: Zues Event handler assigned"] remoteExec ["diag_log", 2];


}; 