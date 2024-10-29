import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item {
    property alias label: labelItem.text
    property alias text: textItem.fullText
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.textElement.color
    property var fontComponent: mainFont.dapFont.regular12

    Text
    {
        id: labelItem
        font: fontComponent
        color: currTheme.gray
    }

    DapBigText
    {
        id: textItem
        anchors.left: labelItem.right
        anchors.right: parent.right
        height: labelItem.height
        textFont: fontComponent
        textColor: currTheme.gray
        textElement.elide: Text.ElideRight
    }
}
