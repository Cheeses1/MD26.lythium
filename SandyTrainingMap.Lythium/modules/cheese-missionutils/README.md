# cheese-missionutils

Cheese's Missing Utils is a collection of small functions I have made to help with zues created missions, so for a units training server. Some might be useful for other types of missions as well. 

## Registered functions

- `cheese_missionutils_fnc_arsenal`


# Arsenal Spawner and Configurator (`cheese_missionutils_fnc_arsenal`)

## Summary
This function is used to spawn and configure an arsenal box. It can be used to create a custom arsenal box with specific items, or to spawn a default arsenal box. It will first check if a box is defined in the function, if not, it will use the user's cursor, if not, then it will create a default box at the player's position. For items to be added, it will check if the _items param was fufilled, if not, then it will check if the global "cheese_arsenal_items" variable is defined, if not, then it will spawn a full arsenal box.

While the function does not itself, it should be used to init curators and added as a function to them, and then add it as a curator action on boxes. It can also be used in generic scripting to initialize boxes with specific items, or to spawn boxes.

## Params
- `_box` (Object, optional): The box to spawn or configure. If not provided, the function will attempt to use the user's cursor position. If that is also not available, it will spawn a default box at the player's position.
- `_items` (Array, optional): An array of items to add to the box. If not provided, the function will check for a global variable "cheese_arsenal_items" and use that. If that is also not available, it will spawn a full arsenal box.

Syntax:
```sqf
# Example in SQF scripting
[_box, _items] call cheese_missionutils_fnc_arsenal;


#example using arsenal items global variable

cheese_arsenal_items = ["arifle_MX_F","arifle_MX_SW_F"];
publicVariable "cheese_arsenal_items";

[_box] call cheese_missionutils_fnc_arsenal;

#example using curator action

// In the curator's init
```sqf
_action = ["add_arsenal", "Add Arsenal", "", {cheese_missionutils_fnc_arsenal}, {true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
```

#example using arsenal box init

```sqf
// In the box's init
cheese_missionutils_fnc_arsenal = [_this select 0] call cheese_missionutils_fnc_arsenal;
```

#example using arsenal box init with items

```sqf
// In the box's init
_items = ["arifle_MX_F","arifle_MX_SW_F"];
cheese_missionutils_fnc_arsenal = [_this select 0, _items] call cheese_missionutils_fnc_arsenal;
```
