import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"


Item {
    property bool isFakeStateButton: false
    property alias fakeButtonText: fakeButtonText.text
    property string fakeButtonUrlSpinner: "qrc:/Resources/"+ pathTheme +"/icons/other/spinner_network.svg"

    property bool isSynch : false
    property alias textBut: button_caption.text
    property alias button: control

    signal clicked()

    function updateFakeButton(isFake)
    {
        isFakeStateButton = isFake
        fakeButtonText.visible = isFake
        indicatorNetwork.visible = isFake
        button_caption.visible = !isFake
        baseImage.visible = !isFake
    }

    id: control

    onEnabledChanged:
    {
        if(isFakeStateButton)
        {
            animatorIndicator.start()
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: if(control.enabled)mouseEnterAnim.start()
        onExited: if(control.enabled)mouseExitedAnim.start()

        onClicked:
        {
            if(!isFakeStateButton)
            {
                control.clicked()
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: currTheme.mainBackground
        radius: 8
        antialiasing: true
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
                                             currTheme.mainBackground
                }
                GradientStop
                {
                    id: grad2
                    position: 1;
                    color: /*mouseArea.containsMouse ? currTheme.buttonColorNormalPosition1 :*/
                                             currTheme.mainBackground
                }
            }
        }

        Rectangle{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 8
            color: currTheme.mainBackground
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
                        id: grad1_
                        position: 0;
                        color: /*mouseArea.containsMouse ? currTheme.buttonColorNormalPosition0 :*/
                                                 currTheme.mainBackground
                    }
                    GradientStop
                    {
                        id: grad2_
                        position: 1;
                        color: /*mouseArea.containsMouse ? currTheme.buttonColorNormalPosition1 :*/
                                                 currTheme.mainBackground
                    }
                }
            }
        }

        Rectangle{
            id: block
            anchors.top: parent.top
            width: 8
            height: 8
            color: {
                if(control.enabled)
                    return mouseArea.containsMouse && isSynch  ? currTheme.mainButtonColorNormal1 :
                           mouseArea.containsMouse && !isSynch ? currTheme.mainButtonColorNormal0
                                                               : currTheme.mainBackground
                else
                    return currTheme.mainBackground
            }

            Component.onCompleted: {
                if(isSynch)
                    block.anchors.right = parent.right
                else
                    block.anchors.left = parent.left
            }

            Behavior on color{
                PropertyAnimation{duration: 100}
            }
        }

        ParallelAnimation {
            id: mouseEnterAnim
            PropertyAnimation {
                targets: [grad1, grad1_]
                properties: "color"
                to: currTheme.mainButtonColorNormal0
                duration: 100
            }
            PropertyAnimation {
                targets: [grad2, grad2_]
                properties: "color"
                to: currTheme.mainButtonColorNormal1
                duration: 100
            }
        }
        ParallelAnimation {
            id: mouseExitedAnim
            PropertyAnimation {
                targets: [grad1, grad2, grad1_, grad2_]
                properties: "color"
                to: currTheme.mainBackground
                duration: 100
            }
        }
    }

    DropShadow {
        id: shadow
        anchors.fill: background
        source: background
        color: currTheme.shadowMain
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: 0.42
        cached: true
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        Image {
            id: baseImage
            Layout.leftMargin: isSynch ? 23  : 29
            Layout.alignment: Qt.AlignVCenter

            sourceSize: Qt.size(24,24)
            smooth: false
            antialiasing: true
            fillMode: Image.PreserveAspectFit

            source: isSynch ? "qrc:/Resources/"+ pathTheme +"/icons/other/sync.svg" :
                              "qrc:/Resources/"+ pathTheme +"/icons/other/on_off.svg"
        }

        Text {
            id: button_caption
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: isSynch ? 22  : 28
            font: mainFont.dapFont.medium12
            color: currTheme.white
            text: isSynch ? qsTr("Sync network") : qsTr("On network")
        }

        Image {
            id: indicatorNetwork
            Layout.leftMargin: 27
            Layout.alignment: Qt.AlignVCenter
            sourceSize: Qt.size(24,24)
            smooth: true
            antialiasing: true
            fillMode: Image.PreserveAspectFit

            source: fakeButtonUrlSpinner

            RotationAnimator
            {
                id: animatorIndicator
                target: indicatorNetwork
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: isFakeStateButton
            }
        }

        Text {
            id: fakeButtonText
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 27
            font: mainFont.dapFont.medium12
            color: currTheme.white
            text: qsTr("Processing...")
        }
    }
}

