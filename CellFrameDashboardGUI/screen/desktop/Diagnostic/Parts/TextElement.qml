import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"

RowLayout {
    id: root

    property alias title: title
    property alias content: content

    Layout.fillWidth: true
    spacing: 0

    Text {
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        id: title

        font: mainFont.dapFont.regular14
        color: currTheme.gray
        verticalAlignment: Qt.AlignVCenter
    }

    Text{
        Layout.alignment: Qt.AlignLeft
        Layout.fillHeight: true
        Layout.fillWidth: true
        id: content

        font: mainFont.dapFont.regular14
        color: currTheme.white
        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignLeft
        verticalAlignment: Qt.AlignVCenter
    }
}   //
