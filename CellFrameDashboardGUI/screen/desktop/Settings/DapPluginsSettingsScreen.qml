import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet

Rectangle
{
//    property var pluginsList:[]
    property string currentPlugin:""

    id:plugins

    anchors.fill: parent
    anchors.margins: 10
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundMainScreen
    border.width: pt
    border.color: currTheme.lineSeparatorColor

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10 * pt
        rows: 2
        columns: 3

        rowSpacing: 10 * pt

        Rectangle
        {
            id:rectanglePlug
            Layout.row: 1
            Layout.rowSpan: 1
            Layout.column: 1
            Layout.columnSpan: 3
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: plugins.radius
            color: currTheme.backgroundElements
            border.width: pt
            border.color: currTheme.lineSeparatorColor

            Component {
                id: highlight
                Rectangle {
                    width: 180; height: 40
                    color: currTheme.buttonColorNormal; radius: 5
//                        y: listViewPlug.currentItem.y

                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
            }

            ListView
            {
                id:listViewPlug
                anchors.fill: parent
                anchors.margins: 10

                spacing: 10
                clip: true
                focus: true

                model: ListModel{
                    id: listModel
                }

                delegate:
                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.right: parent.right
//                        anchors.margins: 10
                        border.width: 2 * pt
                        border.color: currTheme.lineSeparatorColor
                        color: "transparent"
                        height: 60
                        radius: 5 * pt

                        RowLayout
                        {
                            anchors.fill: parent
                            spacing: 5

                            // number plugin
                                Item {
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 30
                                    Layout.preferredWidth: 30
                                    Layout.maximumWidth: 30
                                    Layout.fillHeight: true

                                    Text{
                                        anchors.centerIn: parent
                                        text: model.index + 1
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                    }
                                    Rectangle
                                    {
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: 2 * pt
                                        color: currTheme.lineSeparatorColor
                                    }
                                }
                            // path plugin
                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    Text{
                                        id:url
                                        anchors.fill: parent
                                        text: urlPath
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                        wrapMode: Text.WordWrap
                                        verticalAlignment: Qt.AlignVCenter
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: { listViewPlug.currentIndex = index}
                                        }
                                    }
                                    Rectangle
                                    {
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: 2 * pt
                                        color: currTheme.lineSeparatorColor
                                    }
                                }
                            // status plugin
                                Item {
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 100
                                    Layout.maximumWidth: 100
                                    Layout.fillHeight: true
                                    Text{
                                        id: statusPlugin
                                        anchors.centerIn: parent
                                        text: status
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                    }
                                }
                        }
                    }

                highlight: highlight

            }
        }

        DapButton
        {
            Layout.row: 2
            Layout.rowSpan: 1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillWidth: true

            implicitHeight: 36 * pt
            implicitWidth: 163 * pt

            id:loadPlug
            textButton: "Add Plugin"

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter


            FileDialog {
                id: dialogSelectPlug
                title: qsTr("Please choose a *.so ui library file")
                folder: "~"
                visible: false
                onAccepted:
                {
                    listModel.append({urlPath: dialogSelectPlug.fileUrls[0], status:"Not Installed"})

//                    pluginsList.push(dialogSelectPlug.fileUrls[0])
                }
            }
            onClicked: dialogSelectPlug.visible = true
        }
        DapButton
        {
            Layout.row: 2
            Layout.rowSpan: 1
            Layout.column: 2
            Layout.columnSpan: 1
            Layout.fillWidth: true

            implicitHeight: 36 * pt
            implicitWidth: 163 * pt

            id:installPlug
            textButton: "Install Plugin"

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                currentPlugin = listModel.get(listViewPlug.currentIndex).urlPath
                listModel.get(listViewPlug.currentIndex).status = "Install"
                SettingsWallet.activePlugin = currentPlugin

            }
        }
        DapButton
        {
            Layout.row: 2
            Layout.rowSpan: 1
            Layout.column: 3
            Layout.columnSpan: 1
            Layout.fillWidth: true

            implicitHeight: 36 * pt
            implicitWidth: 163 * pt

            id:deletePlug
            textButton: "Delete Plugin"

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                if(listModel.count > 0)
                {
                    if(currentPlugin === listModel.get(listViewPlug.currentIndex).urlPath){
                        currentPlugin = ""
                        SettingsWallet.activePlugin = ""
                    }
                    listModel.remove(listViewPlug.currentIndex)
                    SettingsWallet.activePlugin = ""
                }
//                console.log(currentPlugin)
            }
        }
    }
}
