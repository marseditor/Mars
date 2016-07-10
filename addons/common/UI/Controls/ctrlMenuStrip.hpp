class MARS_gui_ctrlMenuStripFake: MARS_gui_ctrlMenu {
    type = CT_STATIC;
    colorStripBackground[] = {0,0,0,1};
    colorStripText[] = {COLOR_TEXT_RGBA};
    colorStripSelect[] = {0,0,0,1};
    colorStripSelectBackground[] = {COLOR_ACTIVE_RGBA};
    colorStripDisabled[] = {COLOR_TEXT_RGB,0.25};
};

class MARS_gui_ctrlMenuStrip: MARS_gui_ctrlMenu {
    type = CT_MENU_STRIP;
    colorStripBackground[] = {0,0,0,1};
    colorStripText[] = {COLOR_TEXT_RGBA};
    colorStripSelect[] = {0,0,0,1};
    colorStripSelectBackground[] = {COLOR_ACTIVE_RGBA};
    colorStripDisabled[] = {COLOR_TEXT_RGB,0.25};
    
    class Items {
        items[] = {};
    };
};
