import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Drawer {
    id: drawer
    edge: Qt.RightEdge

    ScrollView {
        anchors.fill: parent

        Column {
            id: column
            anchors.fill: parent

            ItemDelegate {
                id: headerDelegate
                text: qsTr("Networks")
                icon.source: "qrc:/mobile/Icons/NetIconLight.png"
                width: column.width

                contentItem:
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 10

                        Text {
                            Layout.fillWidth: true
                            text: headerDelegate.text
                            font: headerDelegate.font
                        }
                        Image {
                            source: headerDelegate.icon.source
                            Layout.preferredWidth: 25
                            Layout.preferredHeight: 25
                        }
                    }
            }

            NetworkDelegate
            {
                width: column.width
            }

            NetworkDelegate
            {
                width: column.width
            }

            NetworkDelegate
            {
                width: column.width
            }

            NetworkDelegate
            {
                width: column.width
            }

            NetworkDelegate
            {
                width: column.width
            }

            NetworkDelegate
            {
                width: column.width
            }
        }
    }

}
