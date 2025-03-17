import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import qmlclipboard 1.0
import "../controls"

RowLayout {
    id: root

    property alias title: title
    property alias content: content
    property alias copyButton: copyButton
    Layout.fillWidth: true
    spacing: 0
    Layout.preferredHeight: 18


    QMLClipboard{
        id: clipboard
    }

    Text {
        id: title
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        font: mainFont.dapFont.regular14
        color: currTheme.white
        Layout.maximumWidth: 138
        Layout.minimumWidth: 138
        verticalAlignment: Qt.AlignVCenter
    }

    Text{
        Layout.alignment: Qt.AlignRight
        Layout.fillHeight: true
        Layout.fillWidth: true
        verticalAlignment: Qt.AlignVCenter

        id: content

        font: mainFont.dapFont.regular14
        color: currTheme.white

        elide: Text.ElideRight

        horizontalAlignment: Qt.AlignRight
    }

    CopyButton
    {
        id:copyButton
        Layout.leftMargin: 6
        visible: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        popupText: qsTr("Address copied")
        onCopyClicked:
            clipboard.setText(content.text)
    }
}   //
