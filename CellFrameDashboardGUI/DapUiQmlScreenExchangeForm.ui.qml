import QtQuick 2.9
import QtQuick.Controls 2.5

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



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
