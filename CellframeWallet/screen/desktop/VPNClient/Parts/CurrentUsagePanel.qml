import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    height: 238 * pt

    signal topUpClicked()
    signal refoundClicked()

    ListModel {
        id: infoModel
        ListElement {
            name: qsTr("Escrow payment")
            value: "500.22 KEL"
        }
        ListElement {
            name: qsTr("Escrow spent")
            value: "60 KEL"
        }
        ListElement {
            name: qsTr("Escrow left")
            value: "440.22 KEL for 2m 30d 5h"
        }
        ListElement {
            name: qsTr("Summary spent")
            value: "476 KEL"
        }
        ListElement {
            name: qsTr("Summary left")
            value: "476 KEL for 6m 10d 10h"
        }
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                anchors.bottomMargin: 16 * pt
                spacing: 4

                Item{
                    Layout.fillWidth: true
                    height: 42

                    RowLayout
                    {
                        anchors.fill: parent
//                        spacing: 10 * pt

                        Text {
                            Layout.fillWidth: true
                            font: mainFont.dapFont.medium14
                            color: currTheme.textColor

                            text: qsTr("Current usage")
                        }

                        DapComboBox
                        {
                            Layout.minimumWidth: 100
                            Layout.maximumHeight: 18
                            Layout.alignment: Qt.AlignRight
                            font: mainFont.dapFont.regular16
                            model: vpnClientTokenModel
                            comboBoxVpnOrdersController: vpnOrdersController
                            vpnClientTokens: true
                            defaultText: "   -"
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout{
                        anchors.fill: parent
                        spacing: 12

                        Repeater
                        {
                            model: infoModel

                            delegate:
                                RowLayout
                                {
                                    Layout.fillWidth: true
                                    height: 15 * pt

                                    Text
                                    {
                                        Layout.fillWidth: true
                                        color: currTheme.textColor
                                        font: mainFont.dapFont.regular12
                                        text: name
                                    }
                                    Text
                                    {
                                        Layout.fillWidth: true
                                        horizontalAlignment: Qt.AlignRight
                                        color: currTheme.textColor
                                        font: mainFont.dapFont.regular13
                                        text: value
                                    }
                                }
                        }

                        RowLayout
                        {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
//                            Layout.minimumHeight: 26 * pt
                            spacing: 15

                            DapButton
                            {
                                id: topUpButton
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular12
                                textButton: qsTr("Top up")

                                onClicked: topUpClicked()
                            }

                            DapButton
                            {
                                id: refundButton
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular12
                                textButton: qsTr("Refund")

                                onClicked: refoundClicked()
                            }
                        }
                    }
                }
            }
    }
}
