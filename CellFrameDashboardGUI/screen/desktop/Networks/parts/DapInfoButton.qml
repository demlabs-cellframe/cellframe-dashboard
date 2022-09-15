import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"


Item {
    property bool isSynch : false
    property alias textBut: button_caption.text
    property alias button: control

    signal clicked()

    id: control

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: if(control.enabled)mouseEnterAnim.start()
        onExited: if(control.enabled)mouseExitedAnim.start()

        onClicked: control.clicked()
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: currTheme.buttonNetworkColorNoActive
        LinearGradient
        {
            anchors.fill: parent
            source: parent
            start: Qt.point(0,parent.height/2)
            end: Qt.point(parent.width,parent.height/2)
            gradient:
                Gradient {
                    GradientStop
                    {
                        id: grad1
                        position: 0;
                        color: /*mouseArea.containsMouse ? currTheme.buttonColorNormalPosition0 :*/
                                                 currTheme.buttonNetworkColorNoActive
                    }
                    GradientStop
                    {
                        id: grad2
                        position: 1;
                        color: /*mouseArea.containsMouse ? currTheme.buttonColorNormalPosition1 :*/
                                                 currTheme.buttonNetworkColorNoActive
                    }
                }
        }

        ParallelAnimation {
            id: mouseEnterAnim
            PropertyAnimation {
                target: grad1
                properties: "color"
                to: currTheme.buttonColorNormalPosition0
                duration: 100
            }
            PropertyAnimation {
                target: grad2
                properties: "color"
                to: currTheme.buttonColorNormalPosition1
                duration: 100
            }
        }
        ParallelAnimation {
            id: mouseExitedAnim
            PropertyAnimation {
                targets: [grad1, grad2]
                properties: "color"
                to: currTheme.buttonNetworkColorNoActive
                duration: 100
            }
        }
    }

    DropShadow {
        id: shadow
        anchors.fill: background
        source: background
        color: currTheme.shadowColor
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
    }
    InnerShadow {
        anchors.fill: background
        source: shadow
        color: currTheme.reflection
        horizontalOffset: 1
        verticalOffset: 0
        radius: 0
        samples: 20
        cached: true
        visible: !isSynch
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        Image {
            Layout.leftMargin: isSynch ? 23  : 29 
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight:  24
            Layout.preferredWidth:  24
            height: 24
            width: 24
            mipmap: true
            antialiasing: true

            source: isSynch ? "qrc:/Resources/"+ pathTheme +"/icons/other/sync.svg" :
                              "qrc:/Resources/"+ pathTheme +"/icons/other/on_off.svg"
        }

        Text {
            id: button_caption
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: isSynch ? 22  : 28 
            font: mainFont.dapFont.medium12
            color: currTheme.textColor
            text: isSynch ? qsTr("Sync network") : qsTr("On network")
        }
    }
}

