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
    property alias dapButtonOk: buttonOk
    property alias dapButtonCancel: buttonCancel

//    property alias otherText: otherText
//    property alias title: title

    id: root

    width: 298
    height: content.state === "HAS_UPDATE" ? 210 : 200

    contentItem: Item{
        anchors.fill: parent
        id: content
        state: "HAS_UPDATE"
        states:
        [
            State
            {
                name: "HAS_UPDATE"
                PropertyChanges
                {
                    target: layout
                    visible: true
                }
                PropertyChanges
                {
                    target: otherText
                    visible: false
                }
            },
            State
            {
                name: "OTHER"
                PropertyChanges
                {
                    target: layout
                    visible: false
                }
                PropertyChanges
                {
                    target: otherText
                    visible: true
                }
            }
        ]

        Text {
            id: title
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 24

            font: mainFont.dapFont.medium16
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        ColumnLayout{
            id: layout
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonLayout.top

            anchors.topMargin: 16
            anchors.bottomMargin: 24
            spacing: 8

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Text {
                    font: mainFont.dapFont.medium14
                    color: currTheme.gray
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Current version: ")
                }
                Text {
                    id: currentVersion
                    font: mainFont.dapFont.medium14
                    color: currTheme.white
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Text {
                    font: mainFont.dapFont.medium14
                    color: currTheme.gray
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Last version: ")
                }
                Text {
                    id: lastVersion
                    font: mainFont.dapFont.medium14
                    color: currTheme.white
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
            }
            Text {
                Layout.fillWidth: true
                font: mainFont.dapFont.medium14
                color: currTheme.white
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Go to website to download?")
            }

            Item{Layout.fillHeight: true}
        }


        Text {
            id: otherText

            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonLayout.top
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            anchors.topMargin: 16
            anchors.bottomMargin: 24

            font: mainFont.dapFont.medium14
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            id: buttonLayout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.rightMargin: 32
            anchors.leftMargin: 32
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
