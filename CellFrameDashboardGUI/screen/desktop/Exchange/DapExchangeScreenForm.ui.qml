import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
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

            DapComboBox
            {
                model:
                    ListModel
                    {
                        id: conversionList
                        ListElement
                        {
                            text: "TKN1/NGD"
                        }
                        ListElement
                        {
                            text: "TKN2/NGD"
                        }
                        ListElement
                        {
                            text: "NGD/KLVN"
                        }
                        ListElement
                        {
                            text: "KLVN/USD"
                        }
                    }
                comboBoxTextRole: ["text"]
                widthPopupComboBoxActive: 144 * pt
                widthPopupComboBoxNormal: 112 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
                indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down_dark_blue.png"
                indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up_dark_blue.png"
                //it's font example, it needed in mainWindow fontLoader font
                fontComboBox: [value_lastPrice.font]
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
                model:
                    ListModel
                    {
                        ListElement
                        {
                            text: "1 minute"
                        }
                        ListElement
                        {
                            text: "5 minute"
                        }
                        ListElement
                        {
                            text: "15 minute"
                        }
                        ListElement
                        {
                            text: "30 minute"
                        }
                        ListElement {
                            text: "1 hour"
                        }
                        ListElement
                        {
                            text: "4 hour"
                        }
                        ListElement
                        {
                            text: "12 hour"
                        }
                        ListElement
                        {
                            text: "24 hour"
                        }
                    }
                comboBoxTextRole: ["text"]
                widthPopupComboBoxActive: 132 * pt
                widthPopupComboBoxNormal: 100 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
                indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down_dark_blue.png"
                indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up_dark_blue.png"
                //it's font example, it needed in mainWindow fontLoader font
                fontComboBox: [value_lastPrice.font]
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
                font.pixelSize: 10 * pt
                font.family: "Roboto"
                text: qsTr("Last price")
            }
            Text
            {
                id: value_lastPrice
                anchors.left: lastPrice.left
                anchors.bottom: lastPrice.bottom
                color: "#070023"
                font.pixelSize: 12 * pt
                font.family: "Roboto"
                text: qsTr("$ 10 807.35 NGD")
            }
            Text
            {
                anchors.left: value_lastPrice.right
                anchors.bottom: lastPrice.bottom
                anchors.leftMargin: 6 * pt
                color: "#6F9F00"
                font.pixelSize: 10 * pt
                font.family: "Roboto"
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
                font.pixelSize: 10 * pt
                font.family: "Roboto"
                text: qsTr("24h volume")
            }
            Text
            {
                id: value_valume24
                anchors.right: volume24.right
                anchors.bottom: volume24.bottom
                color: "#070023"
                font.pixelSize: 12 * pt
                font.family: "Roboto"
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
    ///Model with a list of orders
    ListModel
    {
        id: orderModel
        ListElement{titleOrder:"Buy"; path:"qrc:/res/icons/buy_icon.png"}
        ListElement{titleOrder:"Sell"; path:"qrc:/res/icons/sell_icon.png"}
    }
    ///Left down panel
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
        ///frame for the history widget
        Rectangle
        {
            width:430 * pt
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: verticalLine.right
            anchors.right: parent.right
        }
    }
}
