import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{

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
            Layout.leftMargin: 10
//            Layout.rightMargin: 10

            spacing: 10

            Text {
                Layout.fillWidth: true
                font.pointSize: 12
                font.bold: true
                color: "white"

                text: qsTr("VPN orders")
            }

            ComboBox
            {
                Layout.minimumWidth: 170
                font.pointSize: 10
                model: [qsTr("Sort by region"), qsTr("Sort by date")]
            }
        }

        ListView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            model: serverModel

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

                        ColumnLayout
                        {
                            anchors.fill: parent
                            spacing: 0

                            RowLayout
                            {
                                id: serverInfoHeader
                                Layout.minimumHeight: 40
                                Layout.fillWidth: true
                                Layout.leftMargin: 10

                                Text
                                {
                                    Layout.fillWidth: true
                                    color: "white"
                                    font.pointSize: 10
                                    text: name
                                }

                                Switch
                                {
                                    checked: server_state
                                }
                            }

                            Rectangle
                            {
                                id : serverInfoMessage
                                Layout.minimumHeight:
                                    message !== "" ? 20 : 0
                                Layout.fillWidth: true
                                Text
                                {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    color: "white"
                                    font.pointSize: 8
                                    text: message
                                }
                                visible: message !== ""
                                color: "dark green"
                            }

                        }

                        color: "dark blue"
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        height: 30

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: qsTr("Units")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: units
                        }
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        height: 30

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: qsTr("Units type")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: units_type
                        }
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        height: 30

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: qsTr("Value")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: value
                        }
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        Layout.bottomMargin: 10
                        height: 30

                        Text
                        {
                            Layout.fillWidth: true
                            color: "white"
                            font.pointSize: 10
                            text: qsTr("Token")
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 10
                            text: token
                        }
                    }
                }
        }
    }


    color: "blue"
}
