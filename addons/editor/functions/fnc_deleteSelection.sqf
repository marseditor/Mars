/*
 * Author: Kingsley
 * Deletes all objects in selection
 * Does not delete player objects
 *
 * Arguments:
 * None
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

{
    private _crew = crew _x;
    
    if ({isPlayer _x} count _crew == 0 || GVAR(editPlayers)) then {
        {deleteVehicle _x} forEach _crew;
        deleteVehicle _x;
    };
    
    false
} count GVAR(selection);

GVAR(selection) = [];