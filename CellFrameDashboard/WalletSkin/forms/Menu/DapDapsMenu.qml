import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Drawer {
    id: drawer
    edge: Qt.LeftEdge
    dragMargin: 0

    Overlay.modal: Rectangle {
                      color: "#A017171A"
                  }

    background: Rectangle {
        color: currTheme.secondaryBackground
        radius: 16
        Rectangle {
            width: 16
            height: 16
            anchors.top: parent.top
            anchors.left: parent.left
            color: currTheme.secondaryBackground
        }
        Rectangle {
            width: 16
            height: 16
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: currTheme.secondaryBackground
        }
        Rectangle {
            width: 16
            height: 16
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: currTheme.secondaryBackground
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 16

                DapImageRender {
                    source: "qrc:/walletSkin/Resources/BlackTheme/icons/navigation/daps_hover.svg"
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.rightMargin: 40
                    text: qsTr("dApps")
                    color: currTheme.white
                    font: mainFont.dapFont.medium18
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    drawer.close()
            }
        }

        Rectangle {
            implicitHeight: 1
            Layout.fillWidth: true
            color: currTheme.grayDark
        }

        ListView {
            id: mainButtonsList
            Layout.margins: 16
            Layout.bottomMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            spacing: 10
            model: modelAppsTabStates
            delegate: delegateDapps
        }
    }

    Component{
        id: delegateDapps

        Rectangle{
            property var appData: mainButtonsList.model.get(index)
            width: mainButtonsList.width
            height: 56
            radius: 12

            color: area.containsMouse ? currTheme.lime : currTheme.grayDark

            Text{
                anchors.fill: parent
                anchors.leftMargin: 16

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                text: name
                color: area.containsMouse ? currTheme.mainBackground : currTheme.white
                font: mainFont.dapFont.medium14
                elide: Text.ElideRight
            }

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    mainMenu.pushedPage = -1
                    stackView.setInitialItem(path)
                    stackView.isDappLoad = true
                    drawer.close()
                }
            }
        }
    }
}
