import QtQuick 2.9
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import qmlclipboard 1.0

RowLayout {
    id: root

    property alias title: title
    property alias content: content
    property alias copyButton: copyButton
    Layout.fillWidth: true
    spacing: 0

    QMLClipboard{
        id: clipboard
    }



    Text {
        id: title
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        font: mainFont.dapFont.regular12
        color: currTheme.textColor
        Layout.maximumWidth: 138
        Layout.minimumWidth: 138
    }

    DapBigText
    {
        Layout.alignment: Qt.AlignRight
        Layout.fillHeight: true
        Layout.maximumWidth: copyButton.visible ? 158 : 180
        Layout.minimumWidth: copyButton.visible ? 158 : 180
        id: content

//        width: textElement.implicitWidth
        height: textElement.implicitHeight
        textFont: mainFont.dapFont.regular13

        textElement.elide: Text.ElideRight

        horizontalAlign: Qt.AlignRight
    }

    DapCopyButton{
        id: copyButton
        Layout.leftMargin: 6
        visible: false
        popupText: qsTr("Address copied")
        onCopyClicked:
            clipboard.setText(content.fullText)

    }
}   //
