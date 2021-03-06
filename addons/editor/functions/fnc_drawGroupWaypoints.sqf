/*
 * Author: Kingsley
 * Draws group waypoints for any one group in editor selection
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call mars_editor_fnc_drawGroupWaypoints;
 *
 * Public: No
 */

#include "script_component.hpp"

if (GVAR(selection) isEqualTo []) exitWith {};

private _groups = GVAR(selection) apply {group vehicle _x};
_groups = _groups arrayIntersect _groups;

{
    private _group = _x;
    private _waypoints = waypoints _group;
    private _previousPos = getPosVisual leader _group;
    _waypoints deleteAt 0;

    {
        private _waypoint = _x;
        private _pos = waypointPosition _waypoint;

        _pos set [2, 0.25];

        // drawLine3D [_previousPos, _pos, [0,0,0,1]];

        drawIcon3D [
            QPATHTOF(data\Waypoint\background_ca.paa),
            [0,0,0,0.5],
            _pos,
            1,
            1,
            0,
            "",
            0,
            0.032,
            "PuristaBold",
            "center"
        ];

        drawIcon3D [
            QPATHTOF(data\Waypoint\move_ca.paa),
            [1,1,1,1],
            _pos,
            0.75,
            0.75,
            0,
            str (_forEachIndex + 1),
            0,
            0.032,
            "PuristaBold",
            "center"
        ];

        _previousPos = _pos;
    } forEach _waypoints;

    false
} count _groups;
