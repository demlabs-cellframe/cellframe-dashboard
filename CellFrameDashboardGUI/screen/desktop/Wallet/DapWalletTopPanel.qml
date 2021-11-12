import QtQuick 2.12
import QtQuick.Controls 2.12
import Demlabs 1.0
import QtQuick.Layouts 1.12

import "../../"
import "qrc:/widgets"
import "../../controls" as Controls

Page {
    id: root

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 20

        Text {
            id: pageName
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Wallet name")
            color: currTheme.textColor
        }

        Controls.DapButton {
            id: newPaymentButton
            buttonText: qsTr("New payment")
            Layout.alignment: Qt.AlignRight
        }
    }
}
