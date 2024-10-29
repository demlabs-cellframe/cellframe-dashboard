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
        font.family: "Quicksand"
        font.pixelSize: 12
        elide: Text.ElideRight
        color: "#ffffff"
        text: qsTr("text")
    }

    Text {
        id: textValue
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Math.max(implicitHeight, parent.height)
        font.family: "Quicksand"
        font.pixelSize: 12
        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignRight
        color: "#ffffff"
        text: qsTr("text")
    }
}
