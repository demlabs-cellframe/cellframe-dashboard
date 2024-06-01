import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"

RowLayout {
    id: root
    property alias label: labelItem.text
    property alias text: textItem.fullText
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.textColor
    property var textFont: mainFont.dapFont.regular13

    spacing: 3

    Item
    {
        Layout.fillWidth: true
    }
    Text
    {
        id: labelItem
        font: textFont
        color: currTheme.lightGray
        Layout.preferredWidth: implicitWidth
    }

    DapBigText
    {
        id: textItem
        Layout.preferredWidth: Math.min(root.width - labelItem.implicitWidth, textElement.implicitWidth)
        Layout.fillHeight: true
        textFont: parent.textFont
        textElement.elide: Text.ElideRight
        textColor: currTheme.gray
    }
}
