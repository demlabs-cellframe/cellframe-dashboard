import QtQuick 2.7
import "qrc:/widgets"

Item {
    id: control

    signal newVPNOrder

    Column {
        anchors.centerIn: control
        spacing: 22 * pt

        Image {
            sourceSize: Qt.size(500 * pt, 261 * pt)
            source: "qrc:/resources/illustrations/illustration_vpn-service.svg"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium26
            text: qsTr("Create your first VPN order")
        }

        DapTextButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 163 * pt
            height: 36 * pt
            text: qsTr("New VPN order")

            onClicked: control.newVPNOrder()
        }
    }

}
