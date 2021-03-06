/*
 * Author: Kingsley
 * Serializes object icon data into the global variable
 * This is executed in a delayed PFH
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call mars_editor_fnc_serializeDrawing;
 *
 * Public: No
 */

#include "script_component.hpp"

if (true) exitWith {};

BEGIN_COUNTER(serializeDrawing);

#define SMALL_ICON_DISTANCE 250

private _camPosASL = GVAR(camPos);
private _outputIcons = [];
private _outputLines = [];

{
    private _objectData = [];
    private _object = _x;
    private _objectClassname = typeOf _object;
    private _objectPosASL = getPosASL _object;
    private _objectDistance = _objectPosASL distance _camPosASL;
    private _cursorScale = linearConversion [0, GVAR(iconDrawDistance), _objectDistance, 0.033, 0, true];
    private _isPerson = _objectClassname call CBA_fnc_isPerson;
    private _iconColor = [
        [COLOR_EMPTY_RGBA],
        [COLOR_WEST_RGBA],
        [COLOR_EAST_RGBA],
        [COLOR_GUER_RGBA],
        [COLOR_CIV_RGBA]
    ] select (([west, east, resistance, civilian] find (side _object)) + 1);
    
    if (!alive _object) then {
        _iconColor = [0,0,0,1];
    };
    
    private _objectIcon = getText (configfile >> "CfgVehicles" >> _objectClassname >> "icon");
    private _objectIconPath = [getText (configFile >> "CfgVehicleIcons" >> _objectIcon), _objectIcon] select ((toLower _objectIcon) find "\" > -1);
    
    if (_isPerson && vehicle _object == _object) then {
        private _playerColor = [0,0,0,0];
        
        if (isPlayer _object && {_object distance _camPosASL <= SMALL_ICON_DISTANCE}) then {
            _playerColor = [
                [0,0,0,1],
                [[1,0,0.5,1], [1,0,0,1]] select (local _object)
            ] select (alive _object);
            
            // Player icon
            _outputIcons pushBack [
                _object,
                "\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa",
                _playerColor,
                nil,
                nil,
                nil,
                SMALL_ICON_DISTANCE,
                nil,
                name _object
            ];
        };
        
        if (count units group _object > 1) then {
            private _leader = leader _object;
            
            if (_leader == _object) then {
                private _groupIcon = [[group _object] call CFUNC(getMarkerType)] call CFUNC(getMarkerTexture);
                
                if (!isNil "_groupIcon" && {_groupIcon != ""}) then {
                    _outputIcons pushBack [
                        _object,
                        _groupIcon,
                        _iconColor,
                        10,
                        0,
                        true,
                        nil,
                        _cursorScale
                    ];
                    
                    _outputLines pushBack [
                        _object,
                        _object,
                        [0,0,0,1],
                        0,
                        10,
                        _isPerson
                    ];
                };
            } else {
                if (!isNull _leader) then {
                    _outputLines pushBack [
                        _object,
                        _leader,
                        _iconColor,
                        1,
                        1,
                        _isPerson
                    ];
                };
            };
        };
        
        if (_object distance _camPosASL <= SMALL_ICON_DISTANCE) then {
            _outputIcons pushBack [
                _object,
                _objectIconPath,
                _iconColor,
                nil,
                nil,
                nil,
                SMALL_ICON_DISTANCE
            ];
        };
    } else {
        private _vehicleIcon = [[group _object] call CFUNC(getMarkerType)] call CFUNC(getMarkerTexture);
        
        if (crew _object isEqualTo []) then {
            _outputIcons pushBack [
                _object,
                _objectIconPath,
                [COLOR_EMPTY_RGBA],
                nil,
                nil,
                nil,
                SMALL_ICON_DISTANCE
            ];
        } else {
            private _vehicleLeader = ((crew _object) select {leader _x == _x}) param [0, objNull];
            private _vehicleGroupLeader = leader group _object;
            
            if (!isNull _vehicleGroupLeader) then {
                if ({_vehicleGroupLeader == _x} count (crew _object) > 0) then {
                    _outputIcons pushBack [
                        _object,
                        _vehicleIcon,
                        _iconColor,
                        10,
                        0,
                        true,
                        nil,
                        _cursorScale
                    ];
                    
                    _outputLines pushBack [
                        _object,
                        _object,
                        [0,0,0,1],
                        0,
                        10
                    ];
                };
                
                _outputLines pushBack [
                    _object,
                    _vehicleGroupLeader,
                    _iconColor,
                    1,
                    1
                ];
            };
            
            if ({isPlayer _x} count (crew _object) > 0) then {
                _playerColor = [[1,0,0.5,1], [1,0,0,1]] select (local _object);
                
                // Player icon
                _outputIcons pushBack [
                    _object,
                    "\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa",
                    _playerColor,
                    nil,
                    nil,
                    nil,
                    SMALL_ICON_DISTANCE
                ];
            };
            
            _outputIcons pushBack [
                _object,
                _objectIconPath,
                _iconColor,
                nil,
                nil,
                nil,
                SMALL_ICON_DISTANCE
            ];
        };
    };
    
    false
} count ((GVAR(capturedEntities) select {
    !(side _x in [sideAmbientLife, sideLogic, sideUnknown]) &&
    !(typeOf _x in ["GroundWeaponHolder","WeaponHolderSimulated"])
}) - (entities "Animal"));

private _outputMarkers = [];

{
    private _icon = (configfile >> "CfgMarkers" >> markerType _x >> "icon");
    private _texture = (configfile >> "CfgMarkers" >> markerType _x >> "texture");
    private _useTexture = if (isNull _texture) then {getText _icon} else {getText _texture};
    private _color = [getArray (configFile >> "CfgMarkerColors" >> markerColor _x >> "color")] call CFUNC(evalColor);

    _outputMarkers pushBack [
        _x,
        _useTexture,
        _color,
        markerPos _x,
        (markerSize _x) select 0,
        (markerSize _x) select 1,
        markerDir _x,
        markerText _x
    ];

    false
} count GVAR(capturedMarkers);

GVAR(serializedIcons) = _outputIcons;
GVAR(serializedLines) = _outputLines;
GVAR(serializedMarkers) = _outputMarkers;

END_COUNTER(serializeDrawing);
