import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../controls" as Controls
import "Parts"
import "qrc:/widgets"

Controls.DapTopPanel {
    signal showInfo(var flag)

    RowLayout
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: rightPlace.left
        anchors.leftMargin: 40
        anchors.rightMargin: 24


        Text{
            text: qsTr("System information:")
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
        }

        ListView{
            id: topListView
            Layout.leftMargin: 32
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: diagnosticDataModel
            spacing: 0


            interactive: false
            clip: false

            delegate:
            RowLayout{
                width: topListView.width
                height: topListView.height
                spacing: 0

                TextElement{
                    Layout.minimumWidth: 165
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: _nodeUptime
                    title.text: qsTr("Node uptime: ")
                    content.text: process.uptime
                    Layout.alignment: Qt.AlignVCenter
                }
                TextElement{
                    Layout.minimumWidth: 165
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: _memoryUsage
                    title.text: qsTr("Memory usage: ")
                    content.text: system.memory.load + " %"
                    Layout.alignment: Qt.AlignVCenter
                }
                TextElement{
                    Layout.minimumWidth: 165
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: _CPULoad
                    title.text: qsTr("CPU load: ")
                    content.text: system.CPU.load + " %"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        Item{

            id: moreButton
            property bool isShow: false

            Layout.preferredWidth: 66
            Layout.fillHeight: true


            Text{

                anchors.left: parent.left
                anchors.right: image.left
                anchors.rightMargin: 8
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: qsTr("More")
                font: mainFont.dapFont.regular14
                color: currTheme.hilightColorComboBox

                verticalAlignment: Text.AlignVCenter
            }

            Image{
                id: image
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                rotation: moreButton.isShow? 0: 180

                source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_up_green.svg"

                mipmap: true

                Behavior on rotation {NumberAnimation{duration: 200}}

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    moreButton.isShow = !moreButton.isShow
                    showInfo(moreButton.isShow)
                }
            }
        }
    }

    RowLayout{
        id: rightPlace
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
//        anchors.rightMargin: 24
        width: 274
        spacing: 24

        Rectangle{
            width: 1
            Layout.alignment: Qt.AlignLeft
            Layout.fillHeight: true
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            color: currTheme.lineSeparatorColor2
        }

        Text{
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Send System Information")
            font: mainFont.dapFont.medium13
            color: currTheme.textColor
        }

        DapSwitch{
            id: swithSendData
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.preferredHeight: 26
            Layout.preferredWidth: 46

            backgroundColor: currTheme.backgroundMainScreen
            borderColor: currTheme.reflectionLight
            shadowColor: currTheme.shadowColor

            onToggled: diagnostic.flagSendData = swithSendData.checked
            Component.onCompleted: swithSendData.state = diagnostic.flagSendData ? "on" : "off"
        }

        Item{width: 24}
    }
}
