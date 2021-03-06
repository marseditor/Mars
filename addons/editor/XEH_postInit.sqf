#include "script_component.hpp"

if (isServer) then {
    [QADDON, "whitelisted", []] call CFUNC(getServerSetting);
    [QADDON, "blacklisted", []] call CFUNC(getServerSetting);

    [{  // Server FPS
        GVAR(fps_server) = diag_fps;
        publicVariable QGVAR(fps_server);
    }, 5, []] call CBA_fnc_addPerFrameHandler;
};

if (isNil QGVAR(initialLoginPlayer)) then {
    GVAR(initialLoginPlayer) = objNull;
    publicVariable QGVAR(initialLoginPlayer);
};

[QMODNAME, "OpenMissionEditor", ["Open Mission Editor", "Press to open the mission editor interface"], {
    if (GVAR(isRemoteControl)) then {
        [false] call FUNC(exitRemoteControl);
    };
    
    [] call FUNC(openEditor);
}, ""] call CBA_fnc_addKeybind;

// Object creation handler
[QGVAR(spawnObject), {
    _this spawn FUNC(spawnObject);
}] call CBA_fnc_addEventHandler;

// Is this needed?
createCenter west;
createCenter east;
createCenter resistance;
createCenter civilian;

[QGVAR(setDir), {
    params ["_unit", "_dir"];
    _unit doWatch objNull;
    _unit setFormDir _dir;
    _unit setDir _dir;
}] call CBA_fnc_addEventHandler;

[QGVAR(moveInAny), {
    params ["_unit", "_vehicle"];
    _unit moveInAny _vehicle;
}] call CBA_fnc_addEventHandler;

[QGVAR(spawnArsenal), {
    _this call FUNC(spawnArsenal);
}] call CBA_fnc_addEventHandler;

[QGVAR(serializeIconsForObjects), {
    params ["_objects"];
    [GETUVAR(GVAR(interface), displayNull), _objects] call FUNC(serializeIcons);
}] call CBA_fnc_addEventHandler;

[QGVAR(endMission), {
    _this call FUNC(endMission);
}] call CBA_fnc_addEventHandler;

["Selected", {count _this}] call FUNC(addToDebugPanel);
["In Serializer", {_this in GVAR(capturedEntities)}, true] call FUNC(addToDebugPanel);
["Icon Control", {
    private _idc = _this getVariable [format ["%1_unit_idc", QADDON], -1];
    if (_idc == -1) exitWith {controlNull};
    ((GETUVAR(GVAR(interface), displayNull) displayCtrl IDC_MOUSEHANDLER) controlsGroupCtrl _idc)
}, true] call FUNC(addToDebugPanel);
