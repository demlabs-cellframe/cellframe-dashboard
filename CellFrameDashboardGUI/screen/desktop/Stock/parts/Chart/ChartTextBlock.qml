import QtQuick 2.4
import QtQuick.Layouts 1.3

Item {
    property alias text1:text1
    property alias text2:text2

    Text
    {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        id: text1
        font: mainFont.dapFont.medium13
        color: currTheme.textColorGray
    }
    Text
    {
        anchors.left: text2.right
        anchors.verticalCenter: parent.verticalCenter
        id: text2
        font: mainFont.dapFont.medium13
        color: currTheme.textColorGreen
    }
}
