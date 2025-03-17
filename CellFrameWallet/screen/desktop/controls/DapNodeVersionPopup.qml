import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../"

DapMessagePopup {

//    property alias currentVersion: currentVersion
//    property alias lastVersion: lastVersion
    property bool isCheckLayout: true
    property alias dapButtonOk: buttonOk
    property alias dapButtonCancel: buttonCancel

    property alias textMessage: otherText
    property alias titleText: title

    id: root

    width: 298
    height: 234

    contentItem: Item{
        anchors.fill: parent
        id: content

        HeaderButtonForRightPanels
        {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 9
            anchors.rightMargin: 10
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            onClicked:
            {
                root.close()
                signalAccept(false)
            }
        }

        Text {
            id: title
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
//            anchors.verticalCenter: parent.verticalCenter
            anchors.topMargin: 32
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            font: mainFont.dapFont.medium16
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            id: otherText

            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonLayout.top
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            anchors.topMargin: 12
            anchors.bottomMargin: 24

            font: mainFont.dapFont.medium14
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            id: checkLayout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.rightMargin: 32
            anchors.leftMargin: 32
            spacing: 10
            visible: isCheckLayout && !settingsModule.isNodeUrlUpdated

            Item {
                Layout.fillWidth: true
            }
            Image
            {
                id: loadImage
                mipmap: true
                source: "qrc:/Resources/" + pathTheme + "/icons/other/loader_orange.svg"
                width: 24
                height: 24

                RotationAnimator
                {
                    target: loadImage
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: true

                    onStopped: {
                        loadImage.rotation = 0;
                    }
                }
            }

            Text
            {
                text: qsTr("Checking the node link.")
                color: currTheme.white
                font: mainFont.dapFont.regular14
                verticalAlignment: Text.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }
        }

        RowLayout
        {
            id: buttonLayout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.rightMargin: 32
            anchors.leftMargin: 32
            spacing: 10
            visible: isCheckLayout && settingsModule.isNodeUrlUpdated

            DapButton
            {
                id:buttonOk

                Layout.fillWidth: true

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Ok")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    root.close()
                    signalAccept(true)
                }
            }

            DapButton
            {
                id:buttonCancel

                visible: false
                Layout.fillWidth: true

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Cancel")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    root.close()
                    signalAccept(false)
                }
            }
        }
    }

    function smartOpenVersion(_title, _currentVersion, _lastVersion, _otherText)
    {

//        console.log(_title, _currentVersion, _lastVersion, _otherText)

        title.text = _title

        if(_otherText === "")
        {
            content.state = "HAS_UPDATE"
            currentVersion.text = _currentVersion
            lastVersion.text = _lastVersion
        }
        else
        {
            content.state = "OTHER"
            otherText.text = _otherText
        }

        root.open()
    }
}
