/*
 * Author: Kingsley
 * Handles left mouse button dragging
 *
 * Arguments:
 * 0: Anchor object <OBJECT>
 * 1: Invoke update <BOOL>
 * 2: Cancel <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call mars_editor_fnc_handleLeftDrag;
 *
 * Public: No
 */

#include "script_component.hpp"

params [
    ["_anchorObject", objNull, [objNull]],
    ["_update", false, [false]],
    ["_cancel", false, [false]]
];

if (_update) then {
    GVAR(isDragging) = false;
    [] call FUNC(setCursor);
    
    if ({isPlayer _x} count GVAR(selection) > 0 && {!GVAR(editPlayers)}) exitWith {};

    private _objectUnderCursor = [GVAR(objectDragAnchor)] call FUNC(objectUnderCursor);

    if (!isNull _objectUnderCursor && {!(_objectUnderCursor in GVAR(selection))}) then {
        {
            [QGVAR(moveInAny), [_x, _objectUnderCursor], _x] call CBA_fnc_targetEvent;
            false
        } count GVAR(selection);
    } else {        
        {
            private _newPos = _x getVariable [QGVAR(leftDragFinalPos), []];
            
            if !(_newPos isEqualTo []) then {
                _x setPosATL _newPos;
            };
            
            false
        } count GVAR(selection);
    };
};

if (_cancel) then {
    GVAR(allowDragging) = false;
    GVAR(isDragging) = false;
    [] call FUNC(setCursor);
    
    {
        _x setVariable [QGVAR(leftDragFinalPos), nil];
        false
    } count GVAR(selection);
    
    [{
        GVAR(selection) = GVAR(selection) - GVAR(objectsDragging);
        GVAR(objectDragAnchor) = objNull;
        GVAR(objectsDragging) = [];
        GVAR(allowDragging) = false;
        GVAR(isDragging) = false;
    }, []] call CFUNC(execNextFrame);
};

if (!GVAR(allowDragging) || _cancel) exitWith {};

GVAR(isDragging) = true;

if (isNull _anchorObject) then {
    if (GVAR(selection) isEqualTo []) then {
        GVAR(selection) = [GVAR(objectUnderCursor)];
    };

    private _nearest = [GVAR(selection)] call FUNC(getNearestUnderCursor);

    if (isNull _nearest) exitWith {
        GVAR(selection) = [];
    };

    GVAR(objectDragAnchor) = _nearest;
} else {
    if (GVAR(selection) isEqualTo []) then {
        GVAR(selection) = [GVAR(objectUnderCursor)];
    };

    if ({isPlayer _x} count GVAR(selection) > 0 && {!GVAR(editPlayers)}) exitWith {};
    
    ["select"] call FUNC(setCursor);

    GVAR(objectsDragging) = GVAR(selection);

    private _worldPos = [GVAR(objectDragAnchor)] call FUNC(getSurfaceUnderCursor);
    private _anchorPos = getPosASL GVAR(objectDragAnchor);

    {
        private _object = _x;
        private _positionASL = getPosASL _object;
        private _positionATL = getPosATL _object;
        private _positionAGL = ASLtoAGL _positionASL;
        private _boundingPos = _worldPos vectorDiff _positionASL;
        private _newPos = _worldPos;
        private _offset = [0,0,0];

        if (_x != GVAR(objectDragAnchor)) then {
            _offset = _positionASL vectorDiff _anchorPos;
            _newPos = _worldPos vectorAdd _offset;
            _boundingPos = _boundingPos vectorAdd _offset;
        };
        
        _finalPosATL = ASLtoATL _newPos;
        _boundingPos = ASLtoAGL _boundingPos;
        
        if (((ASLtoAGL _worldPos) select 2) <= 0.1) then {
            _boundingPos set [2, ((ASLtoAGL _worldPos) select 2)];
        };
        
        [_object, [side group _object] call CFUNC(getSideColor), _boundingPos] call FUNC(drawBoundingBox);
        _object setVariable [QGVAR(leftDragFinalPos), _finalPosATL];

        false
    } count GVAR(selection);
};
