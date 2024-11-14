import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"
import "qrc:/widgets" as Widgets
import "../controls" as Controls

Controls.DapTopPanel {
    property alias dapAddOrderButton: addOrderButton

    Widgets.DapButton
    {
        enabled: false
        id: addOrderButton
        textButton: qsTr("New VPN order")
        anchors.right: parent.right
        anchors.rightMargin: 24 
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 36
        implicitWidth: 164
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter
    }
}
