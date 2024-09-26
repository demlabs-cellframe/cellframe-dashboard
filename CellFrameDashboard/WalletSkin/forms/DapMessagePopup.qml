import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

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

    modal: true

    closePolicy: Popup.NoAutoClose

    background: Rectangle
    {
        border.width: 0
        radius: 16 
        color: currTheme.backgroundElements
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10 

        Text {
            id: dapContentTitle
            Layout.fillWidth: true
//            Layout.margins: 10 
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.topMargin: 5
            font: mainFont.dapFont.medium16
            color: currTheme.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            id: dapContentText
            Layout.fillWidth: true
            Layout.margins: 5 
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
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
