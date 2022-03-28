import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "qrc:/screen/controls"

Page {
    id: root
    property alias ipAddress: ipAddress

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors.rightMargin: 10
        anchors.fill: parent

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            rows: 2
            columns: 3

            Text {
                text: qsTr("Connected to:")
                color: currTheme.textColor
            }
            Item {
                Layout.fillWidth: true
                Layout.rowSpan: 2
            }
            DapButton {
                Layout.rowSpan: 2
                buttonText: qsTr("Disconnect")
            }
            Text {
                id: ipAddress
                text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
                color: currTheme.textColor
            }
        }

        RowLayout {
            id: upperRow
            Layout.fillWidth: true
            Layout.fillHeight: true
            DapScreenPage {
                id: leftCell

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "white"
                }
//                Layout.fillWidth: true
//                Layout.fillHeight: true

                Layout.preferredWidth: root.width * 0.5
                Layout.preferredHeight: root.height * 0.4
                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    rows: 7

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "red"
                    }

                    // row 1
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Current usage")
                        font.bold: true
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                    }
                    DapComboBox {
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredWidth: leftCell.width * 0.5
                    }

                    // row 2
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Escrow payment")
                        Layout.leftMargin: 10
                    }
                    Text {
                        id: paymentValue
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        color: currTheme.textColorGray
                        text: "500.22" + qsTr(" KEL")
                    }

                    // row 3
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Escrow spent")
                        Layout.leftMargin: 10
                    }
                    Text {
                        id: spentValue
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        color: currTheme.textColorGray
                        text: "500.22" + qsTr(" KEL")
                    }

                    // row 4
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Escrow left")
                        Layout.leftMargin: 10
                    }
                    Text {
                        id: leftValue
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        color: currTheme.textColorGray
                        text: "500.22" + qsTr(" KEL")
                    }

                    // row 5
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Summary spent")
                        Layout.leftMargin: 10
                    }
                    Text {
                        id: summarySpentValue
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        color: currTheme.textColorGray
                        text: "500.22" + qsTr(" KEL")
                    }

                    // row 6
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Summary left")
                        Layout.leftMargin: 10
                    }
                    Text {
                        id: summaryLeftValue
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        color: currTheme.textColorGray
                        text: "500.22" + qsTr(" KEL")
                    }

                    // row 7
                    DapButton {
                        buttonText: qsTr("Escrow")
                        Layout.leftMargin: 10
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: leftCell.width * 0.4
                    }
                    DapButton {
                        buttonText: qsTr("Refund")
                        Layout.rightMargin: 10
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: leftCell.width * 0.4
                    }
                }
            }
            DapScreenPage {
                id: rightCell
//                Layout.fillWidth: true
//                Layout.fillHeight: true
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "white"
                }

                Layout.preferredWidth: root.width * 0.5
                Layout.preferredHeight: root.height * 0.4

                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    rows: 6

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "red"
                    }

                    // row 1
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Download speed")
                    }
                    Text {
                        id: downloadSpeed
                        color: currTheme.textColorGray
                        text: "10205" + qsTr(" Mbps")
                    }

                    // row 2
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Upload speed")
                    }
                    Text {
                        id: uploadSpeed
                        color: currTheme.textColorGray
                        text: "10205" + qsTr(" Mbps")
                    }

                    // row 3
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Download")
                    }
                    Text {
                        id: downloadValue
                        color: currTheme.textColorGray
                        text: "20 004" + qsTr(" Mb")
                    }

                    // row 4
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Upload")
                    }
                    Text {
                        id: uploadValue
                        color: currTheme.textColorGray
                        text: "7 993" + qsTr(" Mb")
                    }

                    // row 5
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Packages recieved")
                    }
                    Text {
                        id: packagesRecieved
                        color: currTheme.textColorGray
                        text: "4087"
                    }

                    // row 6
                    Text {
                        color: currTheme.textColorGray
                        text: qsTr("Packages sent")
                    }
                    Text {
                        id: packagesSent
                        color: currTheme.textColorGray
                        text: "1059"
                    }
                }
            }
        }
        DapScreenPage {
            Layout.fillWidth: true
            Layout.fillHeight: true

//            Layout.preferredWidth: 600
//            Layout.preferredHeight: 300
        }
    }
}
