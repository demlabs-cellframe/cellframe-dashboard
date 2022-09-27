import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout {
    id: root

    property alias title: title
    property alias content: content
    Layout.fillWidth: true
    spacing: 8


    Text {
        id: title
        Layout.fillWidth: true
        font: mainFont.dapFont.regular12
        color: currTheme.textColor
        width: parent.width
    }

    DapBigText
    {
        id: content
        Layout.fillWidth: true
        Layout.maximumWidth: 318
        Layout.minimumWidth: 318
        height: textElement.implicitHeight
        textFont: mainFont.dapFont.regular14
    }
}   //
