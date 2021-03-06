/*
 * Author: Kingsley
 * Places any selected object from the asset browser
 *
 * Arguments:
 * 0: Ctrl key held <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * N/A
 *
 * Public: No
 */

#include "script_component.hpp"

params [["_ctrlKeyHeld", false, [false]]];

if (GVAR(abSelectedObject) isEqualTo []) exitWith {};

GVAR(abSelectedObject) params ["_type", "_classname", "_iconPath", "_color", "_side", ["_groupConfigStr", ""]];

private _worldPos = [] call FUNC(getSurfaceUnderCursor);

switch (_type) do {
    case "module": {
        private _config = call compile _groupConfigStr;
        private _action = getText (_config >> "action");
        
        if (isNil _action) then {
            [_worldPos] call compile _action;
        } else {
            [_worldPos] call compile format ["_this call %1", _action];
        };
    };
    case "marker": {
        private _config = (configFile >> "CfgMarkers" >> _classname);
        [QADDON, "Marker", [100, 100], [0.2, 0.8], [
            format ["Create %1 Marker", getText (_config >> "name")],
            _worldPos,
            _classname
        ]] call AFUNC(openAttributes);
    };
    default {
        private _spawnMachine = [] call CFUNC(getSpawnMachine);
        private _args = [_worldPos, player, GVAR(abSelectedObject), GVAR(placeVehiclesWithCrew)];

        if (_spawnMachine isEqualTo REMOTE_SERVER || {
            // If a static/empty object, spawn on server
            _type == "object"
        }) then {
            [QGVAR(spawnObject), _args] call CBA_fnc_serverEvent;
        } else {
            [QGVAR(spawnObject), _args, _spawnMachine] call CBA_fnc_targetEvent;
        };
    };
};

// Don't reset selected object if control key is held (for multiple creations)
if (!_ctrlKeyHeld) then {
    GVAR(abSelectedObject) = [];
    [] call FUNC(clearABSelection);
};

// Cleanup helper object and variables
deleteVehicle GVAR(prepSurfaceSphere);
GVAR(prepSurfaceSphere) = objNull;
GVAR(allowDragging) = false;
GVAR(allowDirection) = false;
GVAR(selection) = [];
