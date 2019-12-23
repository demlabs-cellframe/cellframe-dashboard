import QtQuick 2.0
import QtQuick.Controls 2.0
import "qrc:/"

Page {
    ///Top panel in tab Exchange
    Rectangle {
        id: topPanelExchange
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 24 * pt
        anchors.topMargin: 12 * pt
        anchors.rightMargin: 24 * pt
        height: 30 * pt

        ///Token ComboBox
        Rectangle {
            id: leftComboBox
            anchors.top: topPanelExchange.top
            anchors.left: topPanelExchange.left
            width: 112 * pt
            height: parent.height

            DapComboBox {
                model: ListModel {
                    id: сonversionList
                    ListElement {
                        text: "TKN1/NGD"
                    }
                    ListElement {
                        text: "TKN2/NGD"
                    }
                    ListElement {
                        text: "NGD/KLVN"
                    }
                    ListElement {
                        text: "KLVN/USD"
                    }
                }
                fontSizeComboBox: 16 * pt
                widthPopupComboBoxActive: 144 * pt
                widthPopupComboBoxNormal: 112 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                topIndentActive: 12 * pt
                bottomIndentActive: 14 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
            }
        }

        ///Time ComboBox
        Rectangle {
            id: rightComboBox
            anchors.left: leftComboBox.right
            anchors.leftMargin: 72 * pt
            anchors.top: topPanelExchange.top
            width: 100 * pt
            height: parent.height
            DapComboBox {
                model: ListModel {
                    ListElement {
                        text: "1 minute"
                    }
                    ListElement {
                        text: "5 minute"
                    }
                    ListElement {
                        text: "15 minute"
                    }
                    ListElement {
                        text: "30 minute"
                    }
                    ListElement {
                        text: "1 hour"
                    }
                    ListElement {
                        text: "4 hour"
                    }
                    ListElement {
                        text: "12 hour"
                    }
                    ListElement {
                        text: "24 hour"
                    }
                }
                fontSizeComboBox: 14 * pt
                widthPopupComboBoxActive: 132 * pt
                widthPopupComboBoxNormal: 100 * pt
                sidePaddingActive: 16 * pt
                sidePaddingNormal: 0
                x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                topIndentActive: 12 * pt
                bottomIndentActive: 14 * pt
                heightComboBoxNormal: 24 * pt
                heightComboBoxActive: 44 * pt
                bottomIntervalListElement: 6 * pt
            }
        }

        ///Value Last price
        Rectangle {
            id: lastPrice
            height: parent.height
            width: 150 * pt
            anchors.right: volume24.left
            anchors.rightMargin: 30 * pt

            Text {
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
        Rectangle {
            id: volume24

            height: parent.height
            width: 75 * pt
            anchors.right: topPanelExchange.right

            Text {
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
    DapChartCandleStick{
    anchors.top: topPanelExchange.bottom
    anchors.bottom: exchangeBottomPanel.top
    anchors.left: parent.left
    anchors.right:parent.right
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt
    anchors.topMargin: 16 * pt
    anchors.bottomMargin: 24 * pt

    ListModel{
        id:candleModel
        ListElement{time:1546543400;minimum:10000;maximum:10550;open:10050;close:10100;}
        ListElement{time:1546543700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546544900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546545800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546400;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546546700;minimum:10300;maximum:10550;open:10450;close:10400;}
        ListElement{time:1546547000;minimum:10200;maximum:10650;open:10350;close:10400;}
        ListElement{time:1546547300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546547600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546547900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546548800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546549100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546549400;minimum:10300;maximum:10650;open:10450;close:10400;}
        ListElement{time:1546549700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546550900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546551200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546551500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546551800;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552100;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552400;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546552700;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553000;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553300;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553600;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546553900;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554200;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554500;minimum:10200;maximum:10450;open:10350;close:10400;}
        ListElement{time:1546554800;minimum:10200;maximum:10450;open:10350;close:10400;}
    }

    }
    ///Left down panel
    Row {
        id:exchangeBottomPanel
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
