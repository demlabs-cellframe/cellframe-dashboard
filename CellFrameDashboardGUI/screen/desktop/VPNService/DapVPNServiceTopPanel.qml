import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"
import "qrc:/widgets" as Widgets
import "../../controls" as Controls

Controls.DapTopPanel {
    property alias dapAddOrderButton: addOrderButton
//    anchors.leftMargin: 4*pt
//    radius: currTheme.radiusRectangle

    Widgets.DapButton
    {
        id: addOrderButton
        textButton: "New VPN order"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
//        normalImageButton: "qrc:/resources/icons/new-wallet_icon_dark.svg"
//        hoverImageButton: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
        implicitHeight: 36 * pt
        implicitWidth: 120 * pt
        widthImageButton: 28 * pt
        heightImageButton: 28 * pt
        indentImageLeftButton: 10 * pt
        colorBackgroundNormal: "#070023"
        colorBackgroundHover: "#D51F5D"
        colorButtonTextNormal: "#FFFFFF"
        colorButtonTextHover: "#FFFFFF"
        indentTextRight: 10 * pt
        fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
        borderColorButton: "#000000"
        borderWidthButton: 0
        horizontalAligmentText:Qt.AlignRight
        colorTextButton: "#FFFFFF"
    }
}
