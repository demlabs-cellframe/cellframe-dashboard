import QtQuick 2.0
import QtQml 2.12

QtObject {

    // currTheme.
    readonly property color backgroundMainScreen   : "#ffffff" // OK
    readonly property color backgroundElements     : "#ffffff" // OK
    readonly property color backgroundPanel        : "#ffffff" // OK

    readonly property color buttonColorNormal      : "#D01E67" // OK
    readonly property color buttonColorHover       : "#E62172"
    readonly property color buttonColorNoActive    : "#2E3138"
    //Gradient colors
    readonly property color buttonColorHoverPosition0   : "#E62083" // OK
    readonly property color buttonColorHoverPosition1   : "#E62263" // OK
    readonly property color buttonColorNormalPosition0  : "#C91D73"
    readonly property color buttonColorNormalPosition1  : "#D51F5D"

    readonly property color lineSeparatorColor     : "#292929"

    readonly property color textColor              : "#000000" // OK
    readonly property color placeHolderTextColor   : "#C7C6CE" // OK

    readonly property color borderColor            : "#666E7D" // OK

    readonly property int radiusRectangle          : 20
    readonly property int radiusButton             : 50

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
