import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"
import "qrc:/widgets"

DapTopPanel {
    property alias dapAddOrderButton: addOrderButton
    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle

    DapButton
    {
        id: addOrderButton
        enabled: false
        textButton: "New VPN order"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 38 * pt
        implicitWidth: 163 * pt
        fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
        horizontalAligmentText: Text.AlignHCenter
    }
}
