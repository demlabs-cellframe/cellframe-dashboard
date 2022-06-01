import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import VPNOrdersController 1.0

Item
{

    VPNOrdersController
    {
        id: vpnOrdersController

        onVpnOrdersReceived:
        {
            console.log("kkkkkkkkkkkkkkkkkkkkk", doc)
            ordersListView.model = doc
        }
    }

    ListModel {
        id: serverModel
        ListElement {
            name: "Auto server"
            server_state: true
            units: 3600
            units_type: "seconds"
            value: 0.1
            token: "KELT"
            message: ""
        }
        ListElement {
            name: "Auto server"
            server_state: false
            units: 3600
            units_type: "seconds"
            value: 0.1
            token: "KELT"
            message: ""
        }
        ListElement {
            name: "Auto server"
            server_state: true
            units: 3600
            units_type: "seconds"
            value: 0.1
            token: "KELT"
            message: "Potentially unsafe connection for your personal data"
        }
        ListElement {
            name: "Auto server"
            server_state: true
            units: 3600
            units_type: "seconds"
            value: 0.1
            token: "KELT"
            message: "Promo with speed limit 30 Mb"
        }
        ListElement {
            name: "Auto server"
            server_state: true
            units: 3600
            units_type: "seconds"
            value: 0.1
            token: "KELT"
            message: ""
        }
    }

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 26 * pt
            Layout.topMargin: 5 * pt
            Layout.leftMargin: 15 * pt
            Layout.rightMargin: 5 * pt

            spacing: 10 * pt

            Text {
                Layout.fillWidth: true
                font: mainFont.dapFont.medium14
//                font.bold: true
                color: currTheme.textColor

                text: qsTr("VPN orders")
            }

            DapComboBox
            {
                Layout.minimumWidth: 170 * pt
                Layout.maximumHeight: 26 * pt
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 10 * pt
                sidePaddingActive: 10 * pt
//                            hilightColor: currTheme.buttonColorNormal

                widthPopupComboBoxNormal: 170 * pt
                widthPopupComboBoxActive: 170 * pt
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

                model:
                ListModel {
                    ListElement {
                        name: qsTr("Sort by region")
                    }
                    ListElement {
                        name: qsTr("Sort by date")
                    }
                }

                mainLineText: model.get(0).name
            }
        }

        ListView
        {
            id: ordersListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            //model: vpnOrders//serverModel

            delegate:
                ColumnLayout
                {
                    width: parent.width

                    Rectangle
                    {
                        Layout.fillWidth: true
                        Layout.minimumHeight:
                            serverInfoHeader.Layout.minimumHeight +
                            serverInfoMessage.Layout.minimumHeight
                        color: currTheme.backgroundMainScreen

                        ColumnLayout
                        {
                            anchors.fill: parent
                            spacing: 0

                            RowLayout
                            {
                                id: serverInfoHeader
                                Layout.minimumHeight: 30 * pt
                                Layout.fillWidth: true
                                Layout.leftMargin: 10 * pt

                                Text
                                {
                                    Layout.fillWidth: true
                                    color: currTheme.textColor
                                    font: mainFont.dapFont.medium12
                                    text: name
                                }

//                                Switch
//                                {
//                                    checked: server_state
//                                }

                                DapSwitch
                                {
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    Layout.preferredHeight: 26 * pt
                                    Layout.preferredWidth: 46 * pt
                                    Layout.rightMargin: 10 * pt

                                    backgroundColor: currTheme.backgroundMainScreen
                                    borderColor: currTheme.reflectionLight
                                    shadowColor: currTheme.shadowColor

//                                    checked: show
                                    onToggled: {
                                    }
                                }
                            }

                            Rectangle
                            {
                                id : serverInfoMessage
                                Layout.minimumHeight:
                                    message !== "" ? 20 * pt : 0
                                Layout.fillWidth: true

                                visible: message !== ""

                                color: currTheme.backgroundMainScreen

                                Text
                                {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10 * pt
                                    color: "yellow"
                                    font: mainFont.dapFont.medium10
                                    text: message
                                }
                            }

                        }

                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10 * pt
                        Layout.rightMargin: 10 * pt
                        height: 30 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: qsTr("Units")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: units
                        }
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10 * pt
                        Layout.rightMargin: 10 * pt
                        height: 30 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: qsTr("Units type")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: units_type
                        }
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10 * pt
                        Layout.rightMargin: 10 * pt
                        height: 30 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: qsTr("Value")
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

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10 * pt
                        Layout.rightMargin: 10 * pt
                        Layout.bottomMargin: 10 * pt
                        height: 30 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: qsTr("Token")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: token
                        }
                    }
                }
        }
    }
}
