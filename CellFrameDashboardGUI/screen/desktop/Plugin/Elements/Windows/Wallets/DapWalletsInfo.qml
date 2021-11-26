import QtQuick 2.7

Item {
    id: control

    property alias name: textName.text
    property alias value: textValue.text
    property alias color: frameInfo.color

    implicitWidth: textName.implicitWidth + textValue.implicitWidth - 50
    implicitHeight: Math.max(textName.implicitHeight, textValue.implicitHeight + 15 * pt)

    Rectangle
    {
        id: frameInfo
        anchors.fill: parent

        Text {
            id: textName
            anchors.left: parent.left
            anchors.leftMargin: 15 * pt
            anchors.right: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Qt.AlignVCenter
            height: Math.max(implicitHeight, parent.height)
            font.family: "Quicksand"
            font.pixelSize: 12
            elide: Text.ElideMiddle
            color: currTheme.textColor
            text: qsTr("text")
        }

        Text {
            id: textValue
            anchors.left: parent.horizontalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15 * pt
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Qt.AlignVCenter
            height: Math.max(implicitHeight, parent.height)
            font.family: "Quicksand"
            font.pixelSize: 12
            elide: Text.ElideMiddle
            horizontalAlignment: Qt.AlignLeft
            color: currTheme.textColor
            text: qsTr("text")
        }
    }
}
