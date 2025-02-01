import QtQuick 2.7
import QtQuick.Layouts 1.12
import "qrc:/widgets"

RowLayout {
    id: control

    property alias name: textName.text
    property alias value: textValue.fullText
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

    DapBigText
    {
        id: textValue
        Layout.alignment: Qt.AlignRight
        Layout.fillHeight: true
        Layout.maximumWidth: 250
        width: textValue.textElement.implicitWidth
        height: parent.height
        textFont: mainFont.dapFont.regular12
        fullText: name
        textElement.elide: Text.ElideRight
        textElement.horizontalAlignment: Qt.AlignRight
        textElement.color: currTheme.white
    }
}
