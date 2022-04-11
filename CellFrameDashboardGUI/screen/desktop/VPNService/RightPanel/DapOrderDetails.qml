import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
//import "../../"
import "../Parts"

Page {

    property alias dapOrderIndex: textTotalUsers
    property alias buttonClose: itemButtonClose
    property alias textHeader: textHeader

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt
            DapButton
            {
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 9 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

                onClicked: navigator.popPage()

            }

            Text
            {
                id: textHeader
                text: qsTr("Order details")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }
        Rectangle
        {
            id:frameUsers
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Text
            {
                id: textUsers
                color: currTheme.textColor
                text: qsTr("Users")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15 * pt
                anchors.topMargin: 8
                anchors.bottomMargin: 7
            }
        }
        Rectangle
        {
            id: frameTotalUsers
            height: 41 * pt
            color: "transparent"
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            DapOrderPanelButton
            {
                id: textTotalUsers
                text: qsTr("Total")
                activeBtn: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle
        {
            id: frameNowUsers
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            height: 41 * pt
            color: "transparent"
            DapOrderPanelButton
            {
                id: textNowUsers
                text: qsTr("Now")
                activeBtn: false
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle
        {
            id: frameConnectionHistory
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Text
            {
                id: textRegion
                color: currTheme.textColor
                text: qsTr("Connection history")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15 * pt
                anchors.topMargin: 8
                anchors.bottomMargin: 7
            }
        }
        Rectangle
        {
            id: frameLastConnection
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            height: 50 * pt
            color: "transparent"

            DapOrderPanelButton
            {
                id: textLastConnection
                text: qsTr("Last connection")
                anchors.verticalCenter: parent.verticalCenter
                activeBtn: true
            }
        }
        Rectangle
        {
            id: frameLoad
            Layout.fillWidth: true
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Text
            {
                id: textUnits
                color: currTheme.textColor
                text: qsTr("Load")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15 * pt
                anchors.topMargin: 8
                anchors.bottomMargin: 7
            }
        }
        Rectangle
        {
            id: frameAverageLoad
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            height: 41 * pt
            color: "transparent"

            DapOrderPanelButton
            {
                id: textAverageLoad
                text: qsTr("Average load")
                anchors.verticalCenter: parent.verticalCenter
                activeBtn: false
            }
        }
        Rectangle
        {
            id: frameAverageReceipt
            Layout.fillWidth: true
            Layout.bottomMargin: 10
            height: 41 * pt
            color: "transparent"

            DapOrderPanelButton
            {
                id: textAverageReceipt
                text: qsTr("Average receipt")
                anchors.verticalCenter: parent.verticalCenter
                activeBtn: false
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
