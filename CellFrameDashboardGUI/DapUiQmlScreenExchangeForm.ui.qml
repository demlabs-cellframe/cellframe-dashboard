import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    Rectangle{
        id:topPanelExchange
        x:8
        y:12
        width:parent.width - x -(24*pt)
        height:42 * pt
        Rectangle{
            id:leftComboBox
            x:0
            y:0
            width:144 * pt
            height:parent.height
            DapUiQmlWidgetExchangeComboBox{

                model: ListModel{
                    id:сonversionList
                    ListElement{text:"TKN1/NGD"}
                    ListElement{text:"TKN2/NGD"}
                    ListElement{text:"NGD/KLVN"}
                    ListElement{text:"KLVN/USD"}
                }
            }
        }

        Rectangle{
            id:rightComboBox
            x:leftComboBox.x+leftComboBox.width+(72*pt)
            y:0
            width:132 * pt
            height:parent.height
            DapUiQmlWidgetExchangeComboBox{
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

                    font.pixelSize: 14*pt

            }
        }

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
                font.pixelSize: 12 * pt
                font.family: fontRobotoRegular.name
                text: qsTr("+3.59%")
            }
        }

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



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
