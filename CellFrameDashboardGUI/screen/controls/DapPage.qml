import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    header: root.header

    property Item dapScreen
    property Item dapRightPanel

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        id: rootPageRow
        anchors.fill: parent

        Item {
            id: mainScreen
            Layout.fillHeight: true
            Layout.preferredWidth: rootPageRow.width * 0.7
            data: dapScreen
        }

        Item {
            id: rightPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            data: dapRightPanel
        }
    }

}
