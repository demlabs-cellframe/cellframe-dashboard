import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/widgets"
import "../Parts"

Page {

    property alias buttonClose: buttonClose
    property alias textHeader: textHeader

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.leftMargin: 10
            DapButton
            {
                id: buttonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"

                onClicked: {
                    navigator.popPage()
                }
            }
            Text
            {
                id: textHeader
                text: qsTr("Order details")
                Layout.fillWidth: true
                verticalAlignment: Qt.AlignLeft

                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
            }
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textUsers
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Users")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        DapOrderPanelButton
        {
            id: textTotalUsers
            Layout.fillWidth: true
            text: qsTr("Total")
            activeBtn: true
        }

        DapOrderPanelButton
        {
            id: textNowUsers
            text: qsTr("Now")
            activeBtn: false
            Layout.fillWidth: true
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textRegion
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Connection history")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        DapOrderPanelButton
        {
            id: textLastConnection
            Layout.fillWidth: true
            text: qsTr("Last connection")
            activeBtn: true
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 * pt

            background: Rectangle {
                color: currTheme.backgroundMainScreen
            }

            RowLayout {
                anchors.fill: parent
                Text
                {
                    id: textUnits
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: currTheme.textColor
                    text: qsTr("Load")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                }
            }
        }

        DapOrderPanelButton
        {
            id: textAverageLoad
            text: qsTr("Average load")
            activeBtn: false
            Layout.fillWidth: true
        }

        DapOrderPanelButton
        {
            id: textAverageReceipt
            text: qsTr("Average receipt")
            activeBtn: false
            Layout.fillWidth: true
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}