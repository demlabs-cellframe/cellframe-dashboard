import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets"

Controls.DapTopPanel {

    Controls.DapLoadingTopPanel
    {
    }

    RowLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 0

        Text{
            Layout.alignment: Qt.AlignLeft
            text: qsTr("Console mode: ")
            font: mainFont.dapFont.medium14
            color: currTheme.white
            Layout.leftMargin: 21
        }

        DapSelectorSwitch{
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 6

            id: modeSelector
            visible: true

            height: 32
            firstName: qsTr("Cli")
            secondName: qsTr("Tool")
            firstColor: currTheme.mainButtonColorNormal0
            secondColor: currTheme.mainButtonColorNormal0
            itemHorisontalBorder: 16
            onToggled: consoleModule.Mode = !consoleModule.Mode

            Component.onCompleted: setSelected(consoleModule.Mode ? "first" : "second")

            DapCustomToolTip{
                contentText: qsTr("Switching between Cli or Tool mode")

            }
        }
        Item{
            Layout.fillWidth: true
        }

        Item{
            Layout.alignment: Qt.AlignRight
            Layout.fillHeight: true
            Layout.rightMargin: 24
            width: 58
            id: wikiButton

            Item {
                height: img.height
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter

                MouseArea{
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Qt.openUrlExternally("https://wiki.cellframe.net/02.+Learn/Cellframe+Node/6.+CLI+Node+Commands")
                }

                DapCustomToolTip{
                    contentText: "wiki.cellframe.net"
                }

                Image{
                    id: img
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    mipmap: true
                    source: "qrc:/Resources/BlackTheme/icons/other/icon_wiki.svg"
                }

                Text{
                    width: 28
                    anchors.left: img.right
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter

                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Wiki")
                    font: mainFont.dapFont.medium14
                    color: area.containsMouse? currTheme.orange : currTheme.white

                }
            }
        }
    }
}
