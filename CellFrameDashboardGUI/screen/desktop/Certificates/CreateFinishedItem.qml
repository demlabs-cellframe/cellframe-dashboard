import QtQuick 2.9
import "qrc:/widgets"
import "parts"




Rectangle {
    id: root
    property alias closeButton: closeButton
    property alias doneButton: doneButton
    property alias finishedText: finishedText

    implicitWidth: 100
    implicitHeight: 200

    border.color: "#E2E1E6"
    border.width: 1 * pt
    radius: 8 * pt
    color: "transparent"

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }


    Item {
        id: titleRectangle
        width: parent.width
        height: 40 * pt

        CloseButton {
            id: closeButton
        }  //


        Text {
            id: certificatesTitleText
            anchors{
                left: closeButton.right
                leftMargin: 18 * pt
                verticalCenter: closeButton.verticalCenter
            }
            font: quicksandFonts.bold14
            color: "#3E3853"
            text: qsTr("Create certificate")
        }
    }  //titleRectangle


    Text {
        id: finishedText
        y: 202 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        font: quicksandFonts.medium27
        color: "#070023"
        text: qsTr("Certificate created\nsuccessfully")
        horizontalAlignment: Text.AlignHCenter
    }


    DapButton {
        id: doneButton
        textButton: qsTr("Done")
        y: 468 * pt
        x: (parent.width - width) / 2
        height: 36 * pt
        width: 132 * pt
        colorBackgroundNormal: "#271C4E"
        colorBackgroundHover: "#D2145D"
        colorButtonTextNormal: "#FFFFFF"
        colorButtonTextHover: "#FFFFFF"
        borderColorButton: "#000000"
        borderWidthButton: 0
        radius: 4 * pt
        fontButton: quicksandFonts.regular16
        horizontalAligmentText: Qt.AlignHCenter
    }




}   //root



