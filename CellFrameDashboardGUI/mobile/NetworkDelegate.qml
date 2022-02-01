import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ItemDelegate {
    id: deleagte
    property string networkName: "name"

    contentItem:
    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 10

        RowLayout {
            Layout.fillWidth: true

            Image {
                source: "qrc:/mobile/Icons/indicator_online.png"
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: networkName
                font: deleagte.font
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
                Layout.alignment: Qt.AlignHCenter

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Reload.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
            Button {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Reload.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "State:"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: "ONLINE"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Target state:"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: "ONLINE"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Active links:"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: "2 from 3"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: "Address:"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "1234...0002"
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20

                contentItem:
                    Image {
                        anchors.fill: parent
                        source: "qrc:/mobile/Icons/Copy.png"
                        fillMode: Image.PreserveAspectFit
                    }
            }
        }

    }

}
