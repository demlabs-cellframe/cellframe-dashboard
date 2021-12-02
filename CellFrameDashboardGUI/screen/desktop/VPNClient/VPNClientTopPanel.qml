import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {

    background: Rectangle {
        color: "transparent"
    }

    RowLayout {
        anchors.fill: parent

        Text {
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Time connected: ") + "1d 16h 34m 18s"
        }

        Item {
            width: 24
            height: 24
            Layout.alignment: Qt.AlignRight
            Image {
                anchors.fill: parent
                source: "qrc:/resources/icons/vpn_sheet.png"
            }
        }
    }

}
