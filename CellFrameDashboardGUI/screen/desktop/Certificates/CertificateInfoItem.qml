import QtQuick 2.9
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"




Rectangle {
    id: root
    property alias closeButton: closeButton
    property alias certificateDataListView: certificateDataListView

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
                        leftMargin: 12 * pt
                        verticalCenter: closeButton.verticalCenter
                    }
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                    color: currTheme.textColor
                    text: qsTr("Info about certificate")
                }
            }  //titleRectangle


            ListView {
                id: certificateDataListView
                y: titleRectangle.y + titleRectangle.height + 11 * pt
                width: parent.width
                height: contentHeight
                spacing: 22 * pt
                clip: true

                delegate: TitleTextView {
                    x: 18 * pt
                    title.text: model.keyView
                    content.text: model.value
                    title.color: currTheme.textColorGray
                }
            }
        }
    } //frameRightPanel

}   //root



