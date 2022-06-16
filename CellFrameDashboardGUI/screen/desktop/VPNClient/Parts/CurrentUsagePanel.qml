import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    height: 238 * pt

    property alias dapTopUpButton: topUpButton
    property alias dapRefundButton: refundButton

    ListModel {
        id: infoModel
        ListElement {
            name: "Escrow payment"
            value: "500.22 KEL"
        }
        ListElement {
            name: "Escrow spent"
            value: "60 KEL"
        }
        ListElement {
            name: "Escrow left"
            value: "440.22 KEL for 2m 30d 5h"
        }
        ListElement {
            name: "Summary spent"
            value: "476 KEL"
        }
        ListElement {
            name: "Summary left"
            value: "476 KEL for 6m 10d 10h"
        }
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 7 * pt
                anchors.rightMargin: 20 * pt
                anchors.bottomMargin: 18 * pt
                spacing: 12 * pt

                RowLayout
                {
                    Layout.fillWidth: true

                    spacing: 10 * pt

                    Text {
                        Layout.fillWidth: true
                        font: mainFont.dapFont.medium16
//                        font.bold: true
                        color: currTheme.textColor

                        text: qsTr("Current Usage")
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 100 * pt
                        Layout.maximumHeight: 26 * pt
                    DapComboBox
                    {
                        height: parent.height
                        width: 80 * pt
                        x: parent.width - width + 10 * pt
                        /*indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                        indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                        sidePaddingNormal: 10 * pt
                        sidePaddingActive: 10 * pt
        //                            hilightColor: currTheme.buttonColorNormal

                        widthPopupComboBoxNormal: 100 * pt
                        widthPopupComboBoxActive: 100 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 42 * pt
                        topEffect: false

                        normalColor: currTheme.backgroundMainScreen
                        normalTopColor: currTheme.backgroundElements
                        hilightTopColor: currTheme.backgroundMainScreen

                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 42 * pt
                        indicatorWidth: 24 * pt
                        indicatorHeight: indicatorWidth
                        colorDropShadow: currTheme.shadowColor
                        roleInterval: 15
                        endRowPadding: 37

                        fontComboBox: [mainFont.dapFont.regular18]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
        //                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]*/

                        //comboBoxTextRole: ["name"]

                        model: tokenModel//vpnClientTokenModel

                        Component.onCompleted:
                        {
                            if (tokenModel.count)
                                mainLineText = tokenModel.get(0).name
                        }
                    }
                }
                }

                ListView
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: infoModel
                    delegate:
                        RowLayout
                        {
                            width: parent.width
                            height: 26 * pt

                            Text
                            {
                                Layout.fillWidth: true
                                color: currTheme.textColor
                                font: mainFont.dapFont.medium12
                                text: name
                            }
                            Text
                            {
                                Layout.fillWidth: true
                                horizontalAlignment: Qt.AlignRight
                                color: currTheme.textColor
                                font: mainFont.dapFont.medium14
                                text: value
                            }
                        }

                }

                Item
                {
                    Layout.fillWidth: true
                    height: 26 * pt

                    DapButton
                    {
                        id: topUpButton
                        height: 26 * pt
                        width: 141 * pt
                        horizontalAligmentText: Text.AlignHCenter
                        fontButton: mainFont.dapFont.regular12
                        textButton: qsTr("Top up")
                    }

                    DapButton
                    {
                        id: refundButton
                        height: 26 * pt
                        width: 141 * pt
                        x: parent.width - width
                        horizontalAligmentText: Text.AlignHCenter
                        fontButton: mainFont.dapFont.regular12
                        textButton: qsTr("Refund")
                    }
                }

            }
    }
}
