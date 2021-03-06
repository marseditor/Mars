/*
 * Author: Kingsley
 * Handles selecting an object via left click
 *
 * Arguments:
 * 0: Objects to select (optional) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call mars_editor_fnc_selectObject;
 *
 * Public: No
 */

#include "script_component.hpp"

params [["_objects", [], [[]]]];

if (GVAR(isWaitingForLeftClick)) exitWith {};

if (_objects isEqualTo []) then {
    private _target = GVAR(objectUnderCursor);

    if (_target == GVAR(prepSurfaceSphere)) exitWith {};

    if (isNull _target) then {
        if (!GVAR(ctrlKey)) then {
            GVAR(selection) = [];
        };
        
        GVAR(selectedMarkers) = [];
        GVAR(hoveredMarker) = "";
        
        private _selectedMarker = [] call FUNC(getSelectedMarker);

        if (_selectedMarker != "") then {
            if (!GVAR(ctrlKey)) then {
                GVAR(hoveredMarker) = _selectedMarker;
                GVAR(selectedMarkers) = [_selectedMarker];
            } else {
                GVAR(hoveredMarker) = "";
                GVAR(selectedMarkers) pushBackUnique _selectedMarker;
            };
        } else {
            if (!GVAR(ctrlKey)) then {
                GVAR(selection) = [];
            };

            GVAR(selectedMarkers) = [];
            GVAR(hoveredMarker) = "";
        };
    } else {
        [_target, !(vehicle _target == _target)] call FUNC(highlightObject);
    };
} else {
    _objects = _objects apply {vehicle _x};
    _objects = _objects arrayIntersect _objects;

    if (!GVAR(ctrlKey)) then {
        GVAR(selection) = [];
    };

    {[_x, !(vehicle _x == _x), false] call FUNC(highlightObject);false} count _objects;
};
