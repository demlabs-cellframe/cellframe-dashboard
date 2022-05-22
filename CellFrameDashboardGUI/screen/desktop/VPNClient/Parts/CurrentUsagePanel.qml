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
                anchors.margins: 20 * pt
                spacing: 5 * pt

                RowLayout
                {
                    Layout.fillWidth: true

                    spacing: 10 * pt

                    Text {
                        Layout.fillWidth: true
                        font: mainFont.dapFont.medium14
//                        font.bold: true
                        color: currTheme.textColor

                        text: qsTr("Current Usage")
                    }

                    DapComboBox
                    {
                        Layout.minimumWidth: 100 * pt
                        Layout.maximumHeight: 26 * pt
                        indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
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

                        fontComboBox: [mainFont.dapFont.regular14]
                        colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
        //                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                        alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

                        comboBoxTextRole: ["name"]

                        model: dapTokenModel

                        Component.onCompleted:
                        {
                            if (dapTokenModel.count)
                                mainLineText = dapTokenModel.get(0).name
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
                                font: mainFont.dapFont.medium12
                                text: value
                            }
                        }

                }

                RowLayout
                {
                    Layout.fillWidth: true

                    DapButton
                    {
                        id: topUpButton
                        Layout.fillWidth: true
                        Layout.minimumHeight: 26 * pt
//                        font.pointSize: 10
                        horizontalAligmentText: Text.AlignHCenter
                        fontButton: mainFont.dapFont.regular12
                        textButton: qsTr("Top up")
                    }

                    DapButton
                    {
                        id: refundButton
                        Layout.fillWidth: true
                        Layout.minimumHeight: 26 * pt
//                        font.pointSize: 10
                        horizontalAligmentText: Text.AlignHCenter
                        fontButton: mainFont.dapFont.regular12
                        textButton: qsTr("Refund")
                    }
                }

            }
    }
}
