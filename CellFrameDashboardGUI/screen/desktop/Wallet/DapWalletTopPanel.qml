import QtQuick 2.12
import QtQuick.Controls 2.12
import Demlabs 1.0
import QtQuick.Layouts 1.12

import "../../"
import "qrc:/widgets"
import "../../controls" as Controls

Page {
    id: root

    RowLayout {
        anchors.fill: parent

        Text {
            id: pageName
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Wallet name")
        }

        Controls.DapButton {
            Layout.alignment: Qt.AlignRight
        }
    }
}
