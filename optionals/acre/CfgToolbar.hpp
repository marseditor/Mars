class GVARMAIN(toolbar) {
    class ADDON {
        class Spectator {
            default = QGVAR(spectatorOn);
            tooltipText = "Spectator Chat";
            iconOn = QPATHTOF(data\spectator_on_ca.paa);
            iconOff = QPATHTOF(data\spectator_off_ca.paa);
            action = QFUNC(toggleSpectator);
        };
    };
};
