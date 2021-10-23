import QtQuick 2.0

QtObject {
    readonly property color backgroundMainScreen   : "#ffffff" // OK
    readonly property color backgroundPanel   : "#ffffff" // OK

    readonly property color buttonColor  : "#D51F5D" // OK
    readonly property color textColor    : "#000000" // OK

    readonly property int radiusRectangle          : 20*pt

    //Shadow oprions
    readonly property color shadowColor            : "#21232A"
    readonly property color reflection             : "#393945"
    readonly property color reflectionLight        : "#444253"
    readonly property double radiusShadow          : 8.0
    readonly property double radiusShadowSmall     : 3.0
    readonly property int hOffset                  : 5
    readonly property int vOffset                  : 5
}
