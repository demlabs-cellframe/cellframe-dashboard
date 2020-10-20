import QtQuick 2.7

Item {
    id: control

    property string name
    property string state
    property color textColor

    Row {
        id: row1

        x: Math.floor((parent.width - width) / 2)
        y: Math.floor((parent.height - height) / 2)
        spacing: 8 * pt
        leftPadding: spacing
        rightPadding: spacing

        Text {
            id: textName

            width: Math.min(implicitWidth, control.width - indicator.width - row1.spacing - row1.rightPadding - row1.leftPadding)
            height: Math.min(implicitHeight, control.height)

            font: quicksandFonts.medium12
            elide: Text.ElideRight
            color: control.textColor
            text: control.name
        }

        Rectangle {
            id: indicator

            y: Math.floor((parent.height - height) / 2)
            width: Math.floor(textName.height * 0.5)
            height: width
            radius: width * 0.5

            color: {
                switch (control.state) {
                case "NET_STATE_ONLINE":
                    return "#9DD51F";
                case "NET_STATE_OFFLINE":
                    return "#FFC527";
                default:
                    if (control.state.length > 0)
                        console.warn("Unknown network state: " + control.state);
                    return "#000000";
                }
            }
        }
    }

}
