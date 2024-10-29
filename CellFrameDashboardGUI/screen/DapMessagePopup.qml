import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "qrc:/widgets"

Popup {
    id: dialog

    signal signalAccept(var accept);
    property alias dapButtonOk: buttonOk
    property alias dapButtonCancel: buttonCancel

    width: 300 
    height: 200 

    parent: Overlay.overlay
    x: (parent.width - width) * 0.5
    y: (parent.height - height) * 0.5

    scale: mainWindow.scale

    modal: true

    closePolicy: Popup.NoAutoClose

    background:
    Item
    {
        Rectangle{
            id: backgroundFrame
            anchors.fill: parent
            border.width: 0
            radius: 16
            color: currTheme.secondaryBackground
        }
        InnerShadow {
            anchors.fill: backgroundFrame
            source: backgroundFrame
            color: currTheme.reflection
            horizontalOffset: 1
            verticalOffset: 1
            radius: 0
            samples: 10
            opacity: backgroundFrame.opacity
            fast: true
            cached: true
        }
        DropShadow {
            anchors.fill: backgroundFrame
            source: backgroundFrame
            color: currTheme.shadowMain
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: backgroundFrame.opacity ? 0.42 : 0
            cached: true
        }
    }
    contentItem:
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 32
        anchors.rightMargin: 32

        Text {
            id: dapContentTitle
            Layout.fillWidth: true
//            Layout.margins: 10 
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.topMargin: 5
            font: mainFont.dapFont.medium16
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            id: dapContentText
            Layout.fillWidth: true
            Layout.margins: 5
            font: mainFont.dapFont.medium14
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            Layout.margins: 10 
            Layout.bottomMargin: 20 
            spacing: 10 

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
                    dialog.close()
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
                    dialog.close()
                    signalAccept(false)
                }
            }
        }
    }

    function smartOpen(title, contentText) {
        dapContentTitle.text = title
        dapContentText.text = contentText
        dialog.open()
    }
}
