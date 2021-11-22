import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "qrc:/widgets"
import "qrc:/screen/controls" as Controls

Page {

    property alias networkComboBox: networkComboBox
    property alias tokensAmmount: tokensAmmount
    property alias tokensComboBox: tokensComboBox
    property alias walletToAddress: walletToAddress

    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 16 * pt
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            color: currTheme.backgroundMainScreen

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                color: currTheme.textColor
                text: qsTr("From")
            }
        }

        Controls.DapComboBox {
            id: networkComboBox
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            color: currTheme.backgroundMainScreen

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                color: currTheme.textColor
                text: qsTr("Ammount")
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Controls.DapTextField {
                id: tokensAmmount
                implicitWidth: 200
                Layout.fillWidth: true
                placeholderText: qsTr("0")
            }

            Controls.DapComboBox {
                id: tokensComboBox
                Layout.fillWidth: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            color: currTheme.backgroundMainScreen

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                color: currTheme.textColor
                text: qsTr("To")
            }
        }

        TextField {
            id: walletToAddress

            Layout.fillWidth: true
            Layout.margins: 20

            color: currTheme.textColor
            placeholderTextColor: currTheme.placeHolderTextColor
            placeholderText: qsTr("Paste here")

            background: Rectangle {
                color: currTheme.backgroundElements

                Rectangle {
                    height: 1
                    color: currTheme.placeHolderTextColor
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }
            }

        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}
