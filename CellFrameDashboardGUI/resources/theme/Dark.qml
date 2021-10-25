import QtQuick 2.0

QtObject {

    // currTheme.

    //Panel and Button options
    readonly property color backgroundMainScreen   : "#2E3138" // OK
    readonly property color backgroundPanel        : "#2D3037" // OK
    readonly property color backgroundElements     : "#363A42" // OK

    readonly property color buttonColorNormal      : "#D01E67" // OK
    readonly property color buttonColorHover       : "#E62172"
    readonly property color buttonColorNoActive    : "#2E3138"

    readonly property color lineSeparatorColor     : "#292929"

    readonly property color textColor              : "#ffffff" // OK
    readonly property color placeHolderTextColor   : "#C7C6CE" // OK

    readonly property color borderColor            : "#666E7D" // OK


    readonly property int radiusRectangle          : 20*pt
    readonly property int radiusButton             : 50*pt

    //Shadow oprions
    readonly property color shadowColor            : "#20222A"
    readonly property color reflection             : "#524D64"
    readonly property color reflectionLight        : "#444253"
    readonly property color networkPanelShadow     : "#08070D6C"
    readonly property double radiusShadow          : 8.0
    readonly property double radiusShadowSmall     : 3.0
    readonly property int hOffset                  : 5
    readonly property int vOffset                  : 5
}
