import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property alias titleOrder: orderTitle.orderText
    property string currencyName: "KLVN"
    property string balance: "0"

    width: childrenRect.width
    height: childrenRect.height

    FontLoader {
        id: fontExchange
        source: "qrc:/Resources/Fonts/roboto_regular.ttf"
    }

    ColumnLayout {

        DapUiQmlWidgetExchangeOrderTitle {
            id: orderTitle
            orderFont: fontExchange.name
        }

        Text {
            text: "Balance: " + balance + " " + currencyName
            color: "#ACACAF"
            font.family: fontExchange.name
            font.pixelSize: 12 * pt
        }

        Rectangle {
            width: parent.width
            height: 6 * pt

        }

        DapUiQmlWidgetExchangeOrderContent {
            contentFont: fontExchange.name
        }

        Rectangle {
            height: 12 * pt
            width: parent.width
        }

        DapUiQmlWidgetExchangeOrderButton {
            buttonFont: fontExchange.name
            buttonText: titleOrder
        }
    }
}
