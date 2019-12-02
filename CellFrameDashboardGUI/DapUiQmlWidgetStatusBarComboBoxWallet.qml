import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQml 2.13

///This file will be deleted in feature 2708
DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property Label fieldBalance: Label {}
    model: dapWalletModel.wallets

    indicator: Image {
        id: arrow
        source: parent.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
        width: 24 * pt
        height: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16 * pt
    }

    contentItem: Text {
        id: headerText
        anchors.fill: parent
        anchors.leftMargin: 12 * pt
        anchors.rightMargin: 48 * pt
        anchors.topMargin: 10 * pt
        text: parent.displayText
        font.family: fontRobotoRegular.name
        font.pixelSize: 14 * pt
        color: parent.popup.visible ? "#332F49" : "#FFFFFF"
        verticalAlignment: Text.AlignTop
        elide: Text.ElideRight
    }

    delegate: DapUiQmlWidgetStatusBarComboBoxDelegate {
        delegateContentText: modelData
    }

    onCurrentTextChanged: {
        dapWalletFilterModel.setWalletFilter(currentText);

    }
}
