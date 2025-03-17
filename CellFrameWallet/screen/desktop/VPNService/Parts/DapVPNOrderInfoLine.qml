import QtQuick 2.7

Item {
    id: control

    property alias name: textName.text
    property alias value: textValue.text

    implicitWidth: textName.implicitWidth + textValue.implicitWidth
    implicitHeight: Math.max(textName.implicitHeight, textValue.implicitHeight)

    Text {
        id: textName
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: Math.max(implicitHeight, parent.height)
        font:  mainFont.dapFont.medium12
        elide: Text.ElideRight
        color: currTheme.white
        text: qsTr("text")
    }

    Text {
        id: textValue
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Math.max(implicitHeight, parent.height)
        font:  mainFont.dapFont.regular12
        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignRight
        color: currTheme.white
        text: qsTr("text")
    }
}
