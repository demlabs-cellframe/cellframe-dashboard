import QtQuick 2.0
import QtQml 2.12

QtObject {

    // currTheme.

    //Panel and Button options
    readonly property color backgroundMainScreen   : "#2E3138" // OK
    readonly property color backgroundPanel        : "#2D3037" // OK
    readonly property color backgroundElements     : "#363A42" // OK

    readonly property color buttonColorNormal      : "#7930DE" // OK
    readonly property color buttonColorHover       : "#7F65FF"
    readonly property color buttonColorNoActive    : "#373A42"

    readonly property color hilightColorComboBox     : "#DBFF71"
    readonly property color hilightTextColorComboBox : "#2D3037"

    //network buttons
    readonly property color buttonNetworkColorNoActive    : "#2D3037"

    //Gradient colors
    readonly property color buttonColorHoverPosition0   : "#7930DE" // OK
    readonly property color buttonColorHoverPosition1   : "#7F65FF" // OK
    readonly property color buttonColorNormalPosition0    : "#A361FF"
    readonly property color buttonColorNormalPosition1    : "#9580FF"

    readonly property color lineSeparatorColor     : "#292929"

    //Text colors
    readonly property color textColor              : "#ffffff" // OK
    readonly property color textColorGray          : "#B4B1BD" // OK
    readonly property color textColorGrayTwo       : "#B2B2B2" // OK
    readonly property color placeHolderTextColor   : "#C7C6CE" // OK
    readonly property color textColorGreen         : "#84BE00" // OK //STOCK
    readonly property color textColorRed           : "#FF5F5F" // OK //STOCK

    readonly property color borderColor            : "#666E7D" // OK


    readonly property int radiusRectangle          : 16*pt
    readonly property int radiusButton             : 50*pt

    //Shadow options
    readonly property color shadowColor            : "#20222A"
    readonly property color reflection             : "#524D64"
    readonly property color reflectionLight        : "#444253"
    readonly property color networkPanelShadow     : "#08070D6C"
    readonly property double radiusShadow          : 8.0
    readonly property double radiusShadowSmall     : 3.0
    readonly property int hOffset                  : 5
    readonly property int vOffset                  : 5
    readonly property color buttonInnerShadow      : "#E7D6FF"
    readonly property color buttonShadow           : "#2A2C33"
}
