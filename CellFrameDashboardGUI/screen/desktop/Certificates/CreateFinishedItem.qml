import QtQuick 2.9
import QtGraphicalEffects 1.0
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

    Rectangle
    {
        id:frameRightPanel
        anchors.fill: parent
        color: parent.color
        radius: parent.radius


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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
                text: qsTr("Create certificate")
            }
        }  //titleRectangle


        Text {
            id: finishedText
            y: 202 * pt
            anchors.horizontalCenter: parent.horizontalCenter
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium27
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
            fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }
    } //frameRightPanel
    InnerShadow {
        id: topLeftSadow
        anchors.fill: frameRightPanel
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: frameRightPanel
        visible: frameRightPanel.visible
    }
    InnerShadow {
        anchors.fill: frameRightPanel
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: frameRightPanel.visible
    }




}   //root



