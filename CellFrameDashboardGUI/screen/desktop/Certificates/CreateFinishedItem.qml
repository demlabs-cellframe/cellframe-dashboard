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

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle

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
                leftMargin: 8 * pt
                verticalCenter: closeButton.verticalCenter
            }
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Create certificate")
        }
    }  //titleRectangle


    Text {
        id: finishedText
        y: 202 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium27
        color: currTheme.textColor
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
        fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
        horizontalAligmentText: Qt.AlignHCenter
    }




}   //root



