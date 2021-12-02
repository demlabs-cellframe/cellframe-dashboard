import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "qrc:/screen/controls"

Page {
    ColumnLayout {
        anchors.fill: parent
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
