import QtQuick 2.7

Item {
    id: control

    property string name
    property string networkState
    property color textColor

    Row {
        id: row1

        anchors.centerIn: parent
        spacing: 8 * pt
        leftPadding: spacing
        rightPadding: spacing

        Text {
            id: textName

            width: Math.min(implicitWidth, control.width - indicator.width - row1.spacing - row1.rightPadding - row1.leftPadding)
            height: Math.min(implicitHeight, control.height)

            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
            elide: Text.ElideRight
            color: control.textColor
            text: control.name
        }

        Rectangle {
            id: indicator

            anchors.verticalCenter: parent.verticalCenter
            width: 8 * pt
            height: width
            radius: width * 0.5

            color: {
                switch (control.networkState) {
                case "NET_STATE_ONLINE":
                    return "#9DD51F";
                case "NET_STATE_OFFLINE":
                    return "#FFC527";
                default:
                    if (control.state.length > 0)
                        console.warn("Unknown network state: " + control.networkState);
                    return "#000000";
                }
            }
        }
    }

}
