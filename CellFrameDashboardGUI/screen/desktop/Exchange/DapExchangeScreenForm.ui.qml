import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    //@detalis listHistoryVisible To change the visibility of a story list.
    property alias dapListHistoryVisible: listHistory.visible
    //@detalis dapHistoryButton Extends the scope of the button for signal processing.
    property Button dapHistoryButton: buttonHistry
    //@detalis dapIconHistoryButton Link to the resource of the picture in the history button.
    property alias dapIconHistoryButton: tradeHistoryButtonIcon.source

    ///Top panel in tab Exchange
    Rectangle
    {
        id: topPanelExchange
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 24 * pt
        anchors.topMargin: 12 * pt
        anchors.rightMargin: 24 * pt
        height: 30 * pt

        ///Token ComboBox
        Rectangle
        {
            id: leftComboBox
            anchors.top: topPanelExchange.top
            anchors.left: topPanelExchange.left
            width: 112 * pt
            height: parent.height


            /*DapComboBox
            {
                model: conversionList
                comboBoxTextRole: ["text"]
                widthPopupComboBoxActive: 144 * pt
                widthPopupComboBoxNormal: 112 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
                indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark_blue.png"
                indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up_dark_blue.png"
                fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
                colorMainTextComboBox: [["#070023", "#070023"]]
                colorTextComboBox: [["#070023", "#FFFFFF"]]
                normalColor: "#FFFFFF"
                hilightColor: "#330F54"
                normalTopColor: "#FFFFFF"
                hilightTopColor: normalTopColor
                normalColorText: "#070023"
                hilightColorText: "#FFFFFF"
                normalColorTopText: "#070023"
                hilightColorTopText: "#070023"
                paddingTopItemDelegate: 8 * pt
                heightListElement: 32 * pt
                intervalListElement: 10 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                indicatorLeftInterval: 8 * pt
                colorTopNormalDropShadow: "#00000000"
                colorDropShadow: "#40ABABAB"
                topEffect: true
            }*/


            DapOneRoleComboBox
            {
                model: conversionList
                widthPopupComboBoxActive: 144 * pt
                widthPopupComboBoxNormal: 112 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
                indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark_blue.png"
                indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up_dark_blue.png"
                normalColor: "#FFFFFF"
                hilightColor: "#330F54"
                normalTopColor: "#FFFFFF"
                hilightTopColor: normalTopColor
                paddingTopItemDelegate: 8 * pt
                heightListElement: 32 * pt
                intervalListElement: 10 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                indicatorLeftInterval: 8 * pt
                colorTopNormalDropShadow: "#00000000"
                colorDropShadow: "#40ABABAB"
                topEffect: true
                normalColorText: "#070023"
                hilightColorText: "#FFFFFF"
                normalColorTopText: "#070023"
                hilightColorTopText: "#070023"
                textFont: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                //currentIndex: 0
                oneTextRole: "text"
                defaultMainLineText: "POINTS OF BIG DATA"
            }

        }

        ///Time ComboBox
        Rectangle
        {
            id: rightComboBox
            anchors.left: leftComboBox.right
            anchors.leftMargin: 72 * pt
            anchors.top: topPanelExchange.top
            width: 100 * pt
            height: parent.height
            DapComboBox
            {
                model:timeModel
                comboBoxTextRole: ["text"]
                widthPopupComboBoxActive: 132 * pt
                widthPopupComboBoxNormal: 100 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
                indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark_blue.png"
                indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up_dark_blue.png"
                fontComboBox: [dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14]
                colorMainTextComboBox: [["#070023", "#070023"]]
                colorTextComboBox: [["#070023", "#FFFFFF"]]
                normalColor: "#FFFFFF"
                hilightColor: "#330F54"
                normalTopColor: "#FFFFFF"
                hilightTopColor: normalTopColor
                normalColorText: "#070023"
                hilightColorText: "#FFFFFF"
                normalColorTopText: "#070023"
                hilightColorTopText: "#070023"
                paddingTopItemDelegate: 8 * pt
                heightListElement: 32 * pt
                intervalListElement: 10 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                indicatorLeftInterval: 8 * pt
                colorTopNormalDropShadow: "#00000000"
                colorDropShadow: "#40ABABAB"
                topEffect: true
            }
        }

        ///Value Last price
        Rectangle
        {
            id: lastPrice
            height: parent.height
            width: 150 * pt
            anchors.right: volume24.left
            anchors.rightMargin: 30 * pt

            Text
            {
                anchors.left: lastPrice.left
                anchors.bottom: value_lastPrice.top
                anchors.bottomMargin: 6 * pt
                color: "#757184"
                font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
                font.pixelSize: 10 * pt
                text: qsTr("Last price")
            }
            Text
            {
                id: value_lastPrice
                anchors.left: lastPrice.left
                anchors.bottom: lastPrice.bottom
                color: "#070023"
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                text: qsTr("$ 10 807.35 NGD")
            }
            Text
            {
                anchors.left: value_lastPrice.right
                anchors.bottom: lastPrice.bottom
                anchors.leftMargin: 6 * pt
                color: "#6F9F00"
                font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
                font.pixelSize: 10 * pt
                text: qsTr("+3.59%")
            }
        }
        ///Value 24h volume
        Rectangle
        {
            id: volume24

            height: parent.height
            width: 75 * pt
            anchors.right: topPanelExchange.right

            Text
            {
                anchors.right: volume24.right
                anchors.bottom: value_valume24.top
                anchors.bottomMargin: 6 * pt
                color: "#757184"
                font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
                font.pixelSize: 10 * pt
                text: qsTr("24h volume")
            }
            Text
            {
                id: value_valume24
                anchors.right: volume24.right
                anchors.bottom: volume24.bottom
                color: "#070023"
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                text: qsTr("9 800 TKN1")
            }
        }
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
        color: "#E3E2E6"
    }

    ///Orders panel
    Rectangle
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
            color: "#E3E2E6"
        }

        ///Frame for the history widget
        Rectangle
        {
            width:430 * pt
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: verticalLine.right
            anchors.right: parent.right
            anchors.leftMargin: 20 * pt

            //Top bar transaction history.
            Rectangle
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
                    color: "#070023"
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular16
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

                    Rectangle
                    {
                        anchors.fill: parent
                        color: "#FFFFFF"
                        Image
                        {
                            id: tradeHistoryButtonIcon
                            width: 22 * pt
                            height: 22 * pt
                            source: "qrc:/resources/icons/ic_chevron_down.png"
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
                visible: false
                model: modelExchangeHistory
                delegate: delegateExchangeHistory
                clip: true
                //Made to turn off the backlight on a click.
                MouseArea
                {
                    anchors.fill: parent
                }
                header:
                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 19 * pt

                        Text
                        {
                            id: timeExchangeHeader
                            text: qsTr("Time")
                            color: "#757184"
                            font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular10
                            anchors.top: parent.top
                            anchors.left: parent.left
                            width: 149 * pt
                        }

                        Text
                        {
                            id: priceExchangeHeader
                            text: qsTr("Price,NGD")
                            color: "#757184"
                            font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular10
                            anchors.top: parent.top
                            anchors.left: timeExchangeHeader.right
                            anchors.leftMargin: 20 * pt
                            width: 104 * pt
                        }

                        Text
                        {
                            id: tokenExchangeHeader
                            text: qsTr("TKN1")
                            color: "#757184"
                            font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular10
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
