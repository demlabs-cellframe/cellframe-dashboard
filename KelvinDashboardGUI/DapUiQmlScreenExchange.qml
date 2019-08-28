import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {

    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 28 * pt
        anchors.bottomMargin: 42 * pt
        spacing: 68 * pt

        DapUiQmlWidgetExchangeOrder {
            titleOrder: qsTr("Buy")

        }

        DapUiQmlWidgetExchangeOrder {
            titleOrder: qsTr("Sell")
        }
    }


//    FontLoader {
//        id: fontExchange
//        source: "qrc:/Resources/Fonts/roboto_regular.ttf"
//    }

//    ColumnLayout {
//        anchors.left: parent.left
//        anchors.bottom: parent.bottom
//        anchors.leftMargin: 28 * pt
//        anchors.bottomMargin: 42 * pt

//        RowLayout {
//            spacing: 8 * pt
//            Rectangle {
//                width: 32
//                height: 32
//                border.color: "#000000"
//                border.width: 1

//                Image {
//                    anchors.fill: parent
//                }
//            }

//            Text {
//                text: qsTr("Buy")
//                color: "#4F5357"
//                font.family: fontExchange.name
//                font.pixelSize: 14 * pt
//            }
//        }

//        Text {
//            text: "Balance: 92231.567213234214148 TKNT"
//            color: "#ACACAF"
//            font.family: fontExchange.name
//            font.pixelSize: 12 * pt
//        }

//        Rectangle {
//            width: parent.width
//            height: 6 * pt

//        }


//        ColumnLayout {
//            spacing: 16 * pt

//            Repeater {
//                model: [qsTr("Ammount"), qsTr("Price"), qsTr("Total"), qsTr("Fee (0.2%)"), qsTr("Total+Fee")]
//                RowLayout {
//                    spacing: 62 * pt
//                    Text {
//                        text: modelData
//                        color: "#ACACAF"
//                        font.family: fontExchange.name
//                        font.pixelSize: 12 * pt
//                    }

//                    Rectangle {
//                        width: 130 * pt
//                        height: 22 * pt
//                        border.width: 1 * pt
//                        border.color: "#B0B1B5"

//                        TextInput {
//                            id: currencyTextInput
//                            anchors.left: parent.left
//                            anchors.top: parent.top
//                            anchors.bottom: parent.bottom
//                            anchors.right: textCurrency.left
//                            anchors.leftMargin: 6 * pt
//                            anchors.rightMargin: 6 * pt
//                            color: readOnly ? "#ACACAF" : "#737880"
//                            font.family: fontExchange.name
//                            font.pixelSize: 12 * pt
//                            verticalAlignment: Qt.AlignVCenter
//                            inputMethodHints: Qt.ImhDigitsOnly
//                            clip: true
//                            readOnly: index === 3 || index === 4
//                            text: readOnly ? "0" : ""
//                        }

//                        Text {
//                            id: textCurrency
//                            anchors.right: parent.right
//                            anchors.top: parent.top
//                            anchors.bottom: parent.bottom
//                            anchors.rightMargin: 6 * pt
//                            verticalAlignment: Text.AlignVCenter
//                            horizontalAlignment: Text.AlignRight
//                            color: currencyTextInput.readOnly ? "#ACACAF" : "#737880"
//                            font.family: fontExchange.name
//                            font.pixelSize: 12 * pt
//                            text: "USD"
//                        }
//                    }
//                }
//            }
//        }



//        Rectangle {
//            height: 12 * pt
//            width: parent.width
//        }

//        Button {
//            id: buttonBuy
//            width: 70 * pt
//            height: 30 * pt

//            contentItem: Text {
//                text: qsTr("Buy")
//                color: "#FFFFFF"
//                font.family: fontExchange.name
//                font.pixelSize: 14 * pt
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//            }

//            background: Rectangle {
//                implicitWidth: parent.width
//                implicitHeight: parent.height
//                color: buttonBuy.hovered ? "#A2A4A7" : "#4F5357"
//            }
//        }
//    }
}
