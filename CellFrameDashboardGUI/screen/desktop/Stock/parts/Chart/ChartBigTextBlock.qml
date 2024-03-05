import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

RowLayout {
    property alias label: labelItem.text
    property alias text: textItem.fullNumber
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.textElement.color
    property var fontComponent: mainFont.dapFont.regular12

    spacing: 3
    Text
    {
        id: labelItem
        font: fontComponent
        color: currTheme.gray
    }

    DapBigNumberText
    {
        id: textItem
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true
        height: labelItem.height
        textFont: fontComponent
        textElement.color: currTheme.gray
        outSymbols: 8

        copyButtonVisible: false
    }
    Item {
        Layout.fillWidth: true
    }
}
