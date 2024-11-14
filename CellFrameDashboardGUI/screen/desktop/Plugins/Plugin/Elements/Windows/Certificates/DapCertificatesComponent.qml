import QtQuick 2.9


Component {
    id: delegateComponent

    Rectangle {
        //this property need set from root
        anchors.left: parent.left
        anchors.leftMargin: 10 
        anchors.right: parent.right
        anchors.rightMargin: 10 
        height: 40 
        color: "#363A42"
        radius: 16 

        Text {
            id: certificateNameText
            anchors.fill: parent
            anchors.bottomMargin: 2
            anchors.leftMargin: 14 
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
            anchors.leftMargin: 14 
            anchors.rightMargin: 15 
            height: 1 
            color: "#292929"
        }

    }  //

}  //delegateComponent


