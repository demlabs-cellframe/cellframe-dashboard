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
        font: quicksandFonts.medium12
        elide: Text.ElideRight
        color: "#211A3A"
        text: qsTr("text")
    }

    Text {
        id: textValue
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Math.max(implicitHeight, parent.height)
        font: quicksandFonts.medium12
        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignRight
        color: "#757184"
        text: qsTr("text")
    }
}
