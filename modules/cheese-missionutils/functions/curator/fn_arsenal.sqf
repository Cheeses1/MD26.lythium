
params [["_box", objNull], ["_items", nil]];

if (_box isEqualType "") then {
	_box = missionNamespace getVariable [_box, objNull];
};

if (isNull _box) then {
	_box = getCursorObjectParams;
	_box = _box select 0;
	if (isNull _box) then {
		_pos = screenToWorld [0.5, 0.5];
		_box = "B_CargoNet_01_ammo_f" createVehicle position player;
	};
};
if (isNil "_items") then {
	if (isNil "arsenal_items") then {
		_items = true;
	} else {
		_items = arsenal_items;
	};
};

[_box, _items, true] call ace_arsenal_fnc_initBox;