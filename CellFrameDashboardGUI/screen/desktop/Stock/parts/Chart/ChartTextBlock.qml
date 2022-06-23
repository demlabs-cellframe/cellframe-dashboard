import QtQuick 2.4
import QtQuick.Layouts 1.3

RowLayout {
    property alias label: label
    property alias text: text
    property alias labelVisible: label.visible

    spacing: 3
    Text
    {
        id: label
        font: mainFont.dapFont.regular13
        color: currTheme.textColorGray
    }
    Text
    {
        id: text
        font: mainFont.dapFont.regular13
        color: currTheme.textColorGreen
    }
    Item {
        Layout.fillWidth: true
    }
}
