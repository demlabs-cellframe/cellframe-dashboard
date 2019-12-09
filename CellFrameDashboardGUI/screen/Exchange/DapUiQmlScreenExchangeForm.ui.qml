import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../../"
Page {
    ///Top panel in tab Exchange
    Rectangle{
        id:topPanelExchange
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 24*pt
        anchors.topMargin: 12*pt
        anchors.rightMargin: 24*pt
        height:42 * pt

        ///Token ComboBox
        Rectangle{
            id:leftComboBox
            anchors.top: topPanelExchange.top
            anchors.left: topPanelExchange.left
            width:112 * pt
            height:parent.height

            DapComboBox{
                model: ListModel{
                    id:сonversionList
                    ListElement{text:"TKN1/NGD"}
                    ListElement{text:"TKN2/NGD"}
                    ListElement{text:"NGD/KLVN"}
                    ListElement{text:"KLVN/USD"}
                }
                fontSizeComboBox: 16*pt
                widthPopupComboBoxActive: 144 *pt
                widthPopupComboBoxNormal: 112 *pt
                sidePaddingActive: 16*pt
                sidePaddingNormal: 0
                x:popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
            }

        }

        ///Time ComboBox
        Rectangle{
            id:rightComboBox
            anchors.left: leftComboBox.right
            anchors.leftMargin: 72*pt
            anchors.top: topPanelExchange.top
            width:100 * pt
            height:parent.height
            DapComboBox{
                model: ListModel{
                    ListElement{text:"1 minute"}
                    ListElement{text:"5 minute"}
                    ListElement{text:"15 minute"}
                    ListElement{text:"30 minute"}
                    ListElement{text:"1 hour"}
                    ListElement{text:"4 hour"}
                    ListElement{text:"12 hour"}
                    ListElement{text:"24 hour"}
                }
                fontSizeComboBox: 14*pt
                widthPopupComboBoxActive: 132 *pt
                widthPopupComboBoxNormal: 100 *pt
                sidePaddingActive: 16*pt
                sidePaddingNormal: 0
                x:popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
            }
        }

        ///Value Last price
        Rectangle{
            id: lastPrice
            height: parent.height
            width: 150*pt
            anchors.right: volume24.left
            anchors.rightMargin: 30 * pt

            Text{
                anchors.left: lastPrice.left
                anchors.bottom: value_lastPrice.top
                anchors.bottomMargin: 6 * pt
                color: "#757184"
                font.pixelSize: 10 * pt
                font.family: fontRobotoRegular.name
                text: qsTr("Last price")

            }
            Text {
                id: value_lastPrice
                anchors.left: lastPrice.left
                anchors.bottom: lastPrice.bottom
                color: "#070023"
                font.pixelSize: 12 * pt
                font.family: fontRobotoRegular.name
                text: qsTr("$ 10 807.35 NGD")
            }
            Text {
                anchors.left: value_lastPrice.right
                anchors.bottom: lastPrice.bottom
                anchors.leftMargin: 6 * pt
                color: "#6F9F00"
                font.pixelSize: 10 * pt
                font.family: fontRobotoRegular.name
                text: qsTr("+3.59%")
            }
        }
        ///Value 24h volume
        Rectangle{
            id: volume24

            height: parent.height
            width: 75*pt
            anchors.right: topPanelExchange.right

                Text{
                    anchors.right: volume24.right
                    anchors.bottom: value_valume24.top
                    anchors.bottomMargin: 6 * pt
                    color: "#757184"
                    font.pixelSize: 10 * pt
                    font.family: fontRobotoRegular.name
                    text: qsTr("24h volume")

                }
                Text {
                    id: value_valume24
                    anchors.right: volume24.right
                    anchors.bottom: volume24.bottom
                    color: "#070023"
                    font.pixelSize: 12 * pt
                    font.family: fontRobotoRegular.name
                    text: qsTr("9 800 TKN1")
                }
}
    }
   ///Left down panel
    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 28 * pt
        anchors.bottomMargin: 42 * pt
        spacing: 68 * pt

        DapUiQmlWidgetExchangeOrderForm {
            titleOrder: qsTr("Buy")

        }

        DapUiQmlWidgetExchangeOrderForm {
            titleOrder: qsTr("Sell")
        }
    }
}
