import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Button {
    property alias buttonFont: buttonText.font.family
    property alias buttonText: buttonText.text

    id: buttonBuy
    width: 70 * pt
    height: 30 * pt

    contentItem: Text {
        id: buttonText
        color: "#FFFFFF"
        font.pixelSize: 14 * pt
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: buttonBuy.hovered ? "#A2A4A7" : "#4F5357"
    }
}
