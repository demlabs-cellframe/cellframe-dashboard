import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 16 * pt
    }

    property alias testAddButton: testAddButton
    property alias someModel: someModel
    property alias list: list

    ListModel {
        id: someModel
        ListElement {
            name: "Name 1";
            number: "Number 1";
            network: "netwrk 1"
        }
        ListElement {
            name: "Name 2";
            number: "Number 2";
            network: "netwrk 1"
        }
        ListElement {
            name: "Name 3";
            number: "Number 3";
            network: "netwrk 2"
        }

    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: pageTitle
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
            color: currTheme.textColor
            font.bold: true
            text: qsTr("Tokens")
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: someModel

            section.property: "network"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading

            delegate: ItemDelegate {
                width: list.width
                height: 100
                background: Rectangle {
                    color: "gray"
                    border.color: "black"
                }
                contentItem: RowLayout {
                    anchors.fill: parent

                    Text {
                        text: name
                        color: "white"
                    }

                    Text {
                        text: number
                        color: "white"
                    }
                }
            }
        }

        Button {
            id: testAddButton
            text: "TEST ADD"
        }
    }
}
