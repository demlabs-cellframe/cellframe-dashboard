import QtQuick 2.7
import "qrc:/widgets"

DapTopPanel {
    id: control

    property bool btnNewVPNOrderVisible: true

    signal newVPNOrder

    // TODO только для теста
    DapTextButton {
        anchors.verticalCenter: parent.verticalCenter
        visible: vpnTest.ordersModel.count > 0
        text: "delete first order"
        onClicked: vpnTest.ordersModel.remove(0, 1)
    }

    DapTextButton {
        visible: control.btnNewVPNOrderVisible

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        width: 163 * pt
        height: 36 * pt

        backgroundColor: "#00000000"
        backgroundColorHover: "#D51F5D"

        borderWidth: hovered ? 0 : pt
        borderColor: "#FFFFFF"
        text: qsTr("New VPN order")

        onClicked: control.newVPNOrder()
    }


}
