import QtQuick 2.4
import QtQuick.Layouts 1.3

RowLayout {
    property alias label: labelItem.text
    property alias text: textItem.text
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.color
    property var textFont: mainFont.dapFont.regular13

    spacing: 3
    Text
    {
        id: labelItem
        font: textFont
        color: currTheme.textColorGray
    }
    Text
    {
        id: textItem
        font: textFont
        color: currTheme.textColorGray
    }
    Item {
        Layout.fillWidth: true
    }
}
