import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "../../controls"

Page {
    property alias ipAddress: ipAddress

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
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
            Layout.fillWidth: true
            Layout.fillHeight: true
            DapScreenPage {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            DapScreenPage {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
        DapScreenPage {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
