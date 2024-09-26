import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"

RowLayout {
    property alias label: labelItem.text
    property alias text: textItem.text
    property alias textColor: textItem.color
    property var textFont: mainFont.dapFont.regular13

    spacing: 3

    Text
    {
        id: labelItem
        font: textFont
        color: currTheme.gray
//        Layout.preferredWidth: implicitWidth
        Layout.fillWidth: true
    }

    Text
    {
        id: textItem
        font: textFont
        color: currTheme.gray
//        Layout.preferredWidth: implicitWidth
//        Layout.fillWidth: stretch
    }

}
