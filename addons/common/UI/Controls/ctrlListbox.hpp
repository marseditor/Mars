class MARS_gui_ctrlListbox {
    type = CT_LISTBOX;
    style = ST_LEFT + LB_TEXTURES;
    w = 0.3;
    x = 0;
    y = 0;
    access = 0;
    arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
    arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    autoScrollSpeed = -1;
    colorBackground[] = {COLOR_OVERLAY_RGBA};
    colorDisabled[] = {COLOR_OVERLAY_RGB,0.25};
    colorPicture[] = {1,1,1,1};
    colorPictureDisabled[] = {1,1,1,0.25};
    colorPictureRight[] = {1,1,1,1};
    colorPictureRightDisabled[] = {1,1,1,0.25};
    colorPictureRightSelected[] = {1,1,1,1};
    colorPictureSelected[] = {1,1,1,1};
    colorScrollbar[] = {0,0,0,0};
    colorSelect[] = {0,0,0,1};
    colorSelectRight[] = {0,0,0,1};
    colorSelect2[] = {0,0,0,1};
    colorSelect2Right[] = {0,0,0,1};
    colorSelectBackground[] = {1,1,1,0.88};
    colorSelectBackground2[] = {1,1,1,0.88};
    colorShadow[] = {0,0,0,0};
    colorText[] = {COLOR_TEXT_RGBA};
    colorTextRight[] = {COLOR_TEXT_RGBA};
    deletable = 0;
    fade = 0;
    font = FONT_NORMAL;
    h = 0.3;
    maxHistoryDelay = 1;
    blinkingPeriod = 0;
    period = 1.2;
    rowHeight = SIZE_M * GRID_H;
    shadow = 0;
    sizeEx = SIZEEX_PURISTA_M;
    soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1};
    tooltipColorBox[] = {0,0,0,0};
    tooltipColorShade[] = {0,0,0,1};
    tooltipColorText[] = {1,1,1,1};

    class ListScrollBar {
        arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        autoScrollDelay = 5;
        autoScrollEnabled = 1;
        autoScrollRewind = 0;
        autoScrollSpeed = -1;
        border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        color[] = {1,1,1,1};
        colorActive[] = {1,1,1,1};
        colorDisabled[] = {1,1,1,0.3};
        height = 0;
        scrollSpeed = 0.06;
        shadow = 0;
        thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        width = 0;
    };
};

class MARS_gui_ctrlListboxMulti: MARS_gui_ctrlListbox {
    style = ST_LEFT + LB_TEXTURES + LB_MULTI;
};