import QtQuick 2.9


Component {
    id: delegateComponent

    Rectangle {
        //this property need set from root
        anchors.left: parent.left
        anchors.leftMargin: 10 * pt
        anchors.right: parent.right
        anchors.rightMargin: 10 * pt
        height: 40 * pt
        color: "#363A42"
        radius: 16 * pt

        Text {
            id: certificateNameText
            anchors.fill: parent
            anchors.bottomMargin: 2
            anchors.leftMargin: 14 * pt
            verticalAlignment: Text.AlignVCenter
            font.family: "Quicksand"
            font.pixelSize: 16
            text: model.completeBaseName
            color: "#ffffff"
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Rectangle {
            id: bottomLine

            anchors.top: certificateNameText.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * pt
            anchors.rightMargin: 15 * pt
            height: 1 * pt
            color: currTheme.lineSeparatorColor
        }

    }  //

}  //delegateComponent


