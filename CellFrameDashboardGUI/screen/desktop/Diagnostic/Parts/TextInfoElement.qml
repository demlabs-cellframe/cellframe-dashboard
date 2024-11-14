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

    property int widthTitle: 135

    Layout.fillWidth: true
    Text{
        id: title
        Layout.minimumWidth: widthTitle
        Layout.maximumWidth: widthTitle
        font: mainFont.dapFont.regular14
        color: currTheme.gray

        verticalAlignment: Text.AlignVCenter
    }
    Text{
        id: content
        Layout.minimumWidth: 35
        Layout.maximumWidth: 35
        font: mainFont.dapFont.regular14
        color: currTheme.white
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
        indicatorSize: 30
//        Layout.rightMargin: 16

        backgroundColor: currTheme.mainBackground
        borderColor: currTheme.reflectionLight
        shadowColor: currTheme.shadowColor

    }
}
