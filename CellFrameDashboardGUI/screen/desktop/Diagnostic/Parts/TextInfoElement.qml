import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "qrc:/widgets"

RowLayout{
    property alias title: title.text
    property alias content: content.text
    property alias contentColor: content.color
    property alias progress: progress
    property alias _switch: _switch

    Layout.fillWidth: true
    Text{
        id: title
        Layout.minimumWidth: 135
        Layout.maximumWidth: 135
        font: mainFont.dapFont.regular14
        color: currTheme.textColorGray

        verticalAlignment: Text.AlignVCenter
    }
    Text{
        id: content
        Layout.minimumWidth: 35
        Layout.maximumWidth: 35
        font: mainFont.dapFont.regular14
        color: currTheme.textColor
        verticalAlignment: Text.AlignVCenter
    }
    ProgressBarDiagnostic{
        id: progress
        visible: false
    }

    Item{Layout.fillWidth: true; visible: _switch.visible}

    DapSwitch{
        id: _switch
        visible: false
        checked: false
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        Layout.preferredHeight: 26
        Layout.preferredWidth: 46
//        Layout.rightMargin: 16

        backgroundColor: currTheme.backgroundMainScreen
        borderColor: currTheme.reflectionLight
        shadowColor: currTheme.shadowColor

    }
}
