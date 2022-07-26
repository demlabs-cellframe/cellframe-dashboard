import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as Styles
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item {

    property var receiptsModel: [{"date" : "Today", "transactions" : []},
        {"date" : "July, 22", "transactions" : [{"time" : "12:05", "value" : "12.767 KLVN"},
                                                {"time" : "18:55", "value" : "455.11 TKN"},
                                                {"time" : "19:11", "value" : "8 TKN"},
                                                {"time" : "22:30", "value" : "666 KLVN"}]},

        {"date" : "July, 21", "transactions" : [{"time" : "09:12", "value" : "54.22 TKN"},
                                                {"time" : "11:16", "value" : "29.90876 TKN"},
                                                {"time" : "13:02", "value" : "117.659 KLVN"}]},

        {"date" : "July, 20", "transactions" : [{"time" : "14:33", "value" : "7834.9909 TKN"},
                                                {"time" : "15:01", "value" : "400.348 TKN"},
                                                {"time" : "23:59", "value" : "308.719 KLVN"}]}]
    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10 * pt
            Layout.minimumHeight: 30 * pt

            spacing: 10

            DapButton
            {
                Layout.maximumWidth: 20 * pt
                Layout.maximumHeight: 20 * pt
                Layout.topMargin: 10 * pt

                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
                onClicked: vpnClientNavigator.openVpnOrders()
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 8
                verticalAlignment: Qt.AlignVCenter
                font: mainFont.dapFont.medium14
                color: currTheme.textColor

                text: qsTr("Receipts")
            }
        }

        Repeater
        {
            Layout.fillWidth: true
            model: receiptsModel

            Column
            {
                width: parent.width
            Rectangle
            {
                width: parent.width
                height: 30 * pt
                color: "transparent"

                Text
                {
                    color: "white"
                    anchors.centerIn: parent
                    text: modelData.date
                }
            }

            Repeater
            {
                width: parent.width
                model: modelData.transactions

                Rectangle
                {
                    width: parent.width
                    height: 30 * pt
                    color: "#363A42"

                    Text
                    {
                        color: "white"
                        text: modelData.time
                    }
                }
            }
            }
        }
    }
}
