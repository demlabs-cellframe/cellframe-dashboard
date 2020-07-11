import QtQuick 2.9
import "qrc:/widgets"
import "parts"




Rectangle {
    id: root
    property alias closeButton: closeButton
    property alias certificateDataListView: certificateDataListView

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
            x: 16 * pt
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
            text: qsTr("Info about certificate")
        }
    }  //titleRectangle


    ListView {
        id: certificateDataListView
        y: titleRectangle.y + titleRectangle.height + 26 * pt
        width: parent.width
        height: contentHeight
        spacing: 22 * pt
        clip: true

        delegate: TitleTextView {
            x: 20 * pt
            title.text: model.keyView
            content.text: model.value
        }
    }





}   //root



