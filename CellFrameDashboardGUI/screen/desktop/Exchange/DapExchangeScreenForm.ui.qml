import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"
import "Parts"
import "logic"

Page
{
    //@detalis listHistoryVisible To change the visibility of a story list.
    property alias dapListHistoryVisible: listHistory.visible
    //@detalis dapHistoryButton Extends the scope of the button for signal processing.
    property Button dapHistoryButton: buttonHistry
    //@detalis dapIconHistoryButton Link to the resource of the picture in the history button.
    property alias dapIconHistoryButton: tradeHistoryButtonIcon.source

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    DapRectangleLitAndShaded
    {
        id: mainFrameDashboard
        anchors.fill: parent
//        anchors.topMargin: 24 * pt
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
            {
                anchors.fill: parent


                ///Top panel in tab Exchange
                ExchangeTopPanel
                {
                    id: topPanelExchange
                }

                ///Candlestick chart loader
                Loader
                {
                    id: loaderCandleStick
                    sourceComponent: candleChart
                    anchors.top: topPanelExchange.bottom
                    anchors.left: parent.left
                    anchors.right:parent.right
                    anchors.leftMargin: 24 * pt
                    anchors.rightMargin: 24 * pt
                    anchors.topMargin: 16 * pt
                    height: 282 * pt
                }

                ///Dividing horizontal line
                Rectangle
                {
                    id:horizontalLine
                    anchors.top: loaderCandleStick.bottom
                    anchors.topMargin: 24 * pt
                    height: 1*pt
                    width: parent.width
                    color: currTheme.lineSeparatorColor
                }

                ///Orders panel
                Item
                {
                    id:exchangeBottomPanel
                    anchors.top: horizontalLine.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 24 * pt
                    anchors.rightMargin: 24 * pt

                    ///List of orders
                    ListView
                    {
                        id: orderListView
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        orientation: ListView.Horizontal
                        interactive: false
                        model: orderModel
                        delegate: delegateOrderPanel
                        width: childrenRect.width
                    }
                    ///Dividing vertical line
                    Rectangle
                    {
                        id:verticalLine
                        anchors.left: orderListView.right
                        height: parent.height
                        width: 1 * pt
                        color: currTheme.lineSeparatorColor
                    }

                    ///Frame for the history widget
                    Item
                    {
                        width:430 * pt
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: verticalLine.right
                        anchors.right: parent.right
                        anchors.leftMargin: 20 * pt

                        //Top bar transaction history.
                        Item
                        {
                            id: topHistoryFrame
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: parent.top
                            height: 50 * pt

                            Image
                            {
                                id: tradeHistoryIcon
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.topMargin: 16 * pt
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
                                anchors.topMargin: 16 * pt
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
                                anchors.topMargin: 16 * pt
                                width: 22 * pt
                                height: 22 * pt
                                anchors.verticalCenter: parent.verticalCenter

                                Item
                                {
                                    anchors.fill: parent
        //                                    color: "#FFFFFF"
                                    Image
                                    {
                                        id: tradeHistoryButtonIcon
                                        width: 22 * pt
                                        height: 22 * pt
                                        source: "qrc:/resources/icons/ic_chevron_up.png"
                                    }
                                }
                            }

                        }
                        //Transaction History List.
                        ListView
                        {
                            id: listHistory
                            anchors.top: topHistoryFrame.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
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
                }
            }
    }
}
