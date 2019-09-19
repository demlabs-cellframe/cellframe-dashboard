import QtQuick 2.4
import QtQuick.Controls 2.12

DapUiQmlWidgetSettingsNetworkForm {
    width: parent.width
    height: childrenRect.height

    ComboBox {
        width: 150
        height: 50
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 18 * pt
        anchors.topMargin: 13 * pt
        model: dapSettingsNetworkModel
        textRole: "network"
    }
}
