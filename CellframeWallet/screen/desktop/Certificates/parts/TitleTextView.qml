import QtQuick 2.9
import QtQuick.Layouts 1.3



ColumnLayout {
    id: root

    property alias title: title
    property alias content: content

    spacing: 5

    Text {
        id: title
        Layout.fillWidth: true
        font: mainFont.dapFont.regular12
        color: "#B4B1BD"
        width: parent.width
        wrapMode: Text.Wrap
        height: 15
    }

    Text {
        id: content
        Layout.fillWidth: true
        font: mainFont.dapFont.regular14
        color: currTheme.white
        width: parent.width
        wrapMode: Text.Wrap
        height: 18
    }
}   //
