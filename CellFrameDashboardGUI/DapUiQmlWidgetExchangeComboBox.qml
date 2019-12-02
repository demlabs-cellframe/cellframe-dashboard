import QtQuick 2.0

///This file will be deleted in feature 2708
DapUiQmlWidgetStatusBarComboBox {

    fontSizeDelegateComboBox: 16*pt

    indicator: Image {
        id: imageIndicator
        source: parent.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up_dark_blue.png" : "qrc:/Resources/Icons/ic_arrow_drop_down_dark_blue.png"
        width: 24 * pt
        height: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16 * pt
    }

    contentItem: Text {
        id: headerText

        anchors.fill: parent
        anchors.leftMargin: 16 * pt
        anchors.topMargin: 12 * pt
        text: parent.displayText
        font.family: fontRobotoRegular.name
        font.pixelSize: 16 * pt
        color: hilightColor
        verticalAlignment: Text.AlignTop       
    }
    hilightColor: "#070023"
}
