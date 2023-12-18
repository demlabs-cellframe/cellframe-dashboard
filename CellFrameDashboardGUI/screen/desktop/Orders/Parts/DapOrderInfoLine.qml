import QtQuick 2.7
import QtQuick.Layouts 1.12
RowLayout {
    id: control

    property alias name: textName.text
    property alias value: textValue.text
    height: 15
    Layout.maximumWidth: 296

    Text {
        id: textName
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true

        font:  mainFont.dapFont.regular12
        elide: Text.ElideRight
        color: currTheme.gray
    }

    Item{
        Layout.fillWidth: true
    }

    Text {
        id: textValue

        Layout.alignment: Qt.AlignRight
        Layout.fillHeight: true

        font:  mainFont.dapFont.regular12
        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignRight
        color: currTheme.white
    }
}
