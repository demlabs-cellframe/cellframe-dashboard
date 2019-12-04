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

        DapUiQmlWidgetExchangeOrderForm {
            titleOrder: qsTr("Buy")

        }

        DapUiQmlWidgetExchangeOrderForm {
            titleOrder: qsTr("Sell")
        }
    }
}
