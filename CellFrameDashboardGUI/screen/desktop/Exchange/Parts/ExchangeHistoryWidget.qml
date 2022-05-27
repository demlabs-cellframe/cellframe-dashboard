import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../logic"

/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                      ExchangeHistory
************************************************************************************************/

///Frame for the history widget
Item
{
    ExchangeHistoryDelegate
    {
        id: delegateExchangeHistory
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        //Top bar transaction history.
        RowLayout
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 30 * pt
            Layout.alignment: Qt.AlignTop
            spacing: 10 * pt

            Image
            {
                id: tradeHistoryIcon
                Layout.maximumWidth: 22 * pt
                Layout.maximumHeight: 22 * pt
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/icons/trade-history_icon.png"
            }

            Text
            {
                id: tradeHistoryText
                Layout.fillWidth: true
                text: qsTr("Trade History")
                verticalAlignment: Text.AlignVCenter
                color: currTheme.textColor
                font: mainFont.dapFont.regular16
            }

            Button
            {
                id: buttonHistory
                Layout.maximumWidth: 22 * pt
                Layout.maximumHeight: 22 * pt

                Image
                {
                    anchors.fill: parent
                    id: tradeHistoryButtonIcon
//                    width: 22 * pt
//                    height: 22 * pt
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/icons/ic_chevron_up.png"
                }
            }
        }

        //Transaction History List.
        ListView
        {
            id: listHistory
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: true
            model: modelExchangeHistory
            delegate: delegateExchangeHistory
            clip: true
            //Made to turn off the backlight on a click.
            MouseArea
            {
                anchors.fill: parent
            }
            header:
                Item
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 19 * pt

                    Text
                    {
                        id: timeExchangeHeader
                        text: qsTr("Time")
                        color: currTheme.textColor
                        font.family: mainFont.dapFont.regular10
                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: 149 * pt
                    }

                    Text
                    {
                        id: priceExchangeHeader
                        text: qsTr("Price,NGD")
                        color: currTheme.textColor
                        font.family: mainFont.dapFont.regular10
                        anchors.top: parent.top
                        anchors.left: timeExchangeHeader.right
                        anchors.leftMargin: 20 * pt
                        width: 104 * pt
                    }

                    Text
                    {
                        id: tokenExchangeHeader
                        text: qsTr("TKN1")
                        color: currTheme.textColor
                        font.family: mainFont.dapFont.regular10
                        anchors.top: parent.top
                        anchors.left: priceExchangeHeader.right
                        anchors.leftMargin: 20 * pt
                        width: 117 * pt
                    }
                }
        }
    }


/*    Item
    {
        id: topHistoryFrame
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        height: 30 * pt

        Image
        {
            id: tradeHistoryIcon
            anchors.left: parent.left
            anchors.top: parent.top
//            anchors.topMargin: 16 * pt
            width: 22 * pt
            height: 22 * pt
            source: "qrc:/resources/icons/trade-history_icon.png"
            anchors.verticalCenter: parent.verticalCenter

        }

        Text
        {
            id: tradeHistoryText
            text: qsTr("Trade History")
            verticalAlignment: Text.AlignVCenter
            anchors.left:  tradeHistoryIcon.right
            anchors.leftMargin: 8 * pt
            anchors.top: parent.top
//            anchors.topMargin: 16 * pt
            width: 336 * pt
            color: currTheme.textColor
            font: mainFont.dapFont.regular16
            anchors.verticalCenter: parent.verticalCenter
        }

        Button
        {
            id: buttonHistry
            anchors.right: parent.right
            anchors.top: parent.top
//            anchors.topMargin: 16 * pt
            width: 22 * pt
            height: 22 * pt
            anchors.verticalCenter: parent.verticalCenter

            Image
            {
                anchors.fill: parent
                id: tradeHistoryButtonIcon
                width: 22 * pt
                height: 22 * pt
                source: "qrc:/resources/icons/ic_chevron_up.png"
            }
        }

    }*/


    Connections
    {
        target: buttonHistory
        onClicked:
        {
            if(listHistory.visible)
            {
                listHistory.visible = false
                tradeHistoryButtonIcon.source = "qrc:/resources/icons/ic_chevron_down.png"
            }
            else
            {
                listHistory.visible = true
                tradeHistoryButtonIcon.source = "qrc:/resources/icons/ic_chevron_up.png"
            }
        }
    }
}
