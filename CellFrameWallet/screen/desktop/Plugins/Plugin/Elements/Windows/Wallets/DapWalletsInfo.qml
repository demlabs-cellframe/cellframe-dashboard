import QtQuick 2.7

Item {
    id: control

    property alias name: textName.text
    property alias value: textValue.text
    property alias valueObject: textValue
    property alias color: frameInfo.color

    implicitWidth: textName.implicitWidth + textValue.implicitWidth - 50
    implicitHeight: Math.max(textName.implicitHeight, textValue.implicitHeight + 15 )

    Rectangle
    {
        id: frameInfo
        anchors.fill: parent

        Text {
            id: textName
            anchors.left: parent.left
            anchors.leftMargin: 15 
            anchors.right: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Qt.AlignVCenter
            height: Math.max(implicitHeight, parent.height)
            font.family: "Quicksand"
            font.pixelSize: 14
            elide: Text.ElideMiddle
            color: "#ffffff"
            text: qsTr("text")
        }

        Text {
            id: textValue
            anchors.left: parent.horizontalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15 
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Qt.AlignVCenter
            height: Math.max(implicitHeight, parent.height)
            font.family: "Quicksand"
            font.pixelSize: 14
            elide: Text.ElideMiddle
            horizontalAlignment: Qt.AlignRight
            color: "#ffffff"
            text: qsTr("text")
        }
    }
}
