import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"
import "qrc:/widgets" as Widgets
import "../controls" as Controls

Controls.DapTopPanel {
    property alias dapAddOrderButton: addOrderButton
//    anchors.leftMargin: 4*pt
//    radius: currTheme.radiusRectangle

    Widgets.DapButton
    {
        enabled: false
        id: addOrderButton
        textButton: "New VPN order"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 38 * pt
        implicitWidth: 163 * pt
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter
    }
}
