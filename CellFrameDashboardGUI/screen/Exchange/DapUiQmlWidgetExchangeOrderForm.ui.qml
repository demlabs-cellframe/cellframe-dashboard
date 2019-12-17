import QtQuick 2.0
import QtQuick.Layouts 1.0
import "qrc:/"
Item {
    property alias titleOrder: orderTitle.orderText
    property string currencyName: qsTr("KLVN")
    property string balance: "0"

    width: childrenRect.width
    height: childrenRect.height

    ColumnLayout {

        DapUiQmlWidgetExchangeOrderTitleForm {
            id: orderTitle
            orderFont: "Roboto"

        }

        Text {
            text: qsTr("Balance: ") + balance + " " + currencyName
            color: "#ACACAF"
            font.family: "Roboto"
            font.pixelSize: 12 * pt
        }

        Rectangle {
            width: parent.width
            height: 6 * pt

        }

        DapUiQmlWidgetExchangeOrderContentForm {
            contentFont: "Roboto"
        }

        Rectangle {
            height: 12 * pt
            width: parent.width
        }

        DapButton{
           anchors.right: parent.right
           textButton:titleOrder
           existenceImage: false
           widthButton: 130 * pt
           heightButton: 30 * pt
           fontSizeButton: 14 * pt
           colorBackgroundNormal: "#3E3853"
           colorBackgroundHover: "#A2A4A7"
           horizontalAligmentText:Qt.AlignHCenter
           indentTextRight:0
        }

    }
}
