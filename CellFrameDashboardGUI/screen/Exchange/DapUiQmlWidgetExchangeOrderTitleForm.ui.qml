import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property alias orderText: textOrder.text
    property alias orderFont: textOrder.font.family

    width: childrenRect.width
    height: childrenRect.height

    RowLayout {
        spacing: 8 * pt
        Rectangle {
            width: 32
            height: 32
            border.color: "#000000"
            border.width: 1

            Image {
                anchors.fill: parent
            }
        }

        Text {
            id: textOrder
            color: "#4F5357"
            font.pixelSize: 14 * pt
        }
    }
}
