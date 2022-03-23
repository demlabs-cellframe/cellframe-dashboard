import QtQuick 2.9
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"


Rectangle {
    id: root
//    property alias closeButton: closeButton
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

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        Item
        {
            anchors.fill: parent
//            Item {
//                id: titleRectangle
//                width: parent.width
//                height: 40 * pt

//                CloseButton {
//                    id: closeButton
//                }  //


//                Text {
//                    id: certificatesTitleText
//                    anchors{
//                        left: closeButton.right
//                        leftMargin: 12 * pt
//                        top: parent.top
//                        topMargin: 9 * pt
//                        //verticalCenter: closeButton.verticalCenter
//                    }
//                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
//                    color: currTheme.textColor
//                    text: qsTr("Create certificate")
//                }
//            }  //titleRectangle


            Text {
                id: finishedText
                y: 198 * pt
                //anchors.horizontalCenter: parent.horizontalCenter
                x: 53 * pt
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium28
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

                onClicked: dapRightPanel.clear()
            }
        }
    } //frameRightPanel

}   //root
