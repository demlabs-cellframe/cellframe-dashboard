import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{

    Component.onCompleted:
    {
        if (!vpnOrdersController.getIsError())
        {
            var doc = vpnOrdersController.getOrdersModel()
            var json = JSON.parse(doc)
            ordersListView.model = json
            vpnOrdersLayout.visible = true
            connectingText.visible = false
            errorItem.visible = false
        }
        else
        {
            vpnOrdersLayout.visible = false
            connectingText.visible = false
            errorItem.visible = true
        }
    }

    Connections
    {
        target: vpnOrdersController

        function onVpnOrdersReceived(doc)
        {
            var json = JSON.parse(doc)
            ordersListView.model = json
            vpnOrdersLayout.visible = true
            connectingText.visible = false
            errorItem.visible = false
        }

        function onConnectionError()
        {
            vpnOrdersLayout.visible = false
            connectingText.visible = false
            errorItem.visible = true
        }
    }

    Text
    {
        id: connectingText
        anchors.centerIn: parent
        color: currTheme.textColor
        font: mainFont.dapFont.medium16
        text: qsTr("Connecting...")
    }

    Item
    {
        id: errorItem
        anchors.fill: parent
        visible: false

        Text
        {
            id: errorText
            anchors.centerIn: parent
            color: currTheme.textColor
            font: mainFont.dapFont.medium16
            text: qsTr("Connection error")
        }

        DapButton {
            textButton: qsTr("Retry")

            Layout.preferredHeight: 36 * pt

            x: parent.width * 0.5 - width * 0.5
            y: errorText.y + errorText.height + 16 * pt
            implicitHeight: 36 * pt
            implicitWidth: 100 * pt

            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.regular16

            onClicked:
            {
                vpnOrdersController.retryConnection()
                connectingText.visible = true
                errorItem.visible = false
            }
        }
    }


    ColumnLayout
    {
        id: vpnOrdersLayout
        anchors.fill: parent
        visible: false

        RowLayout
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 30 * pt
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

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 170 * pt
                Layout.maximumHeight: 26 * pt
            DapComboBox
            {
                height: parent.height
                width: 150 * pt
                x: parent.width - width + 10 * pt
                font: mainFont.dapFont.regular14

                model:
                    ListModel {
                    ListElement {
                        name: qsTr("Sort by region")
                    }
                    ListElement {
                        name: qsTr("Sort by date")
                    }
                }
            }
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

            delegate:
                ColumnLayout
            {
                width: parent.width - x * 2
                x: 2 * pt

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
                                text: modelData.Name
                            }

                            DapSwitch
                            {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.preferredHeight: 26 * pt
                                Layout.preferredWidth: 46 * pt
                                Layout.rightMargin: 10 * pt
                                indicatorSize: 30

                                backgroundColor: currTheme.backgroundMainScreen
                                borderColor: currTheme.reflectionLight
                                shadowColor: currTheme.shadowColor

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

                property var unitsType: ["UNDEFINED", "megabytes", "seconds", "days", "kilobytes", "bytes", "pieces"]

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * pt
                    Layout.rightMargin: 10 * pt
                    Layout.minimumHeight: 25 * pt
                    Layout.maximumHeight: 25 * pt

                    Text
                    {
                        Layout.fillWidth: true
                        color: currTheme.textColor
                        font: mainFont.dapFont.regular12
                        text: qsTr("Units")
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        color: currTheme.textColor
                        font: mainFont.dapFont.medium12
                        text: modelData.Price
                    }
                }

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * pt
                    Layout.rightMargin: 10 * pt
                    Layout.minimumHeight: 25 * pt
                    Layout.maximumHeight: 25 * pt

                    Text
                    {
                        Layout.fillWidth: true
                        color: currTheme.textColor
                        font: mainFont.dapFont.regular12
                        text: qsTr("Units type")
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        color: currTheme.textColor
                        font: mainFont.dapFont.medium12
                        text: unitsType[modelData.PriceUnits]
                    }
                }

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * pt
                    Layout.rightMargin: 10 * pt
                    Layout.minimumHeight: 25 * pt
                    Layout.maximumHeight: 25 * pt

                    Text
                    {
                        Layout.fillWidth: true
                        color: currTheme.textColor
                        font: mainFont.dapFont.regular12
                        text: qsTr("Value")
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        color: currTheme.textColor
                        font: mainFont.dapFont.medium12
                        text: "0"
                    }
                }

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * pt
                    Layout.rightMargin: 10 * pt
                    Layout.bottomMargin: 10 * pt
                    Layout.minimumHeight: 25 * pt
                    Layout.maximumHeight: 25 * pt

                    Text
                    {
                        Layout.fillWidth: true
                        color: currTheme.textColor
                        font: mainFont.dapFont.regular12
                        text: qsTr("Token")
                    }
                    Text
                    {
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        color: currTheme.textColor
                        font: mainFont.dapFont.medium12
                        text: modelData.PriceToken
                    }
                }
            }
        }
    }
}
