import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet

Rectangle
{
//    property var pluginsList:[]
    property string currentPlugin:""

    id:plugins

    anchors.fill: parent
    anchors.margins: 10 * pt
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundMainScreen
    border.width: pt
    border.color: currTheme.lineSeparatorColor

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 10 * pt
        rows: 2
        columns: 4

        rowSpacing: 10 * pt

        Rectangle
        {
            id:rectanglePlug
            Layout.row: 1
            Layout.rowSpan: 1
            Layout.column: 1
            Layout.columnSpan: 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: plugins.radius
            color: currTheme.backgroundElements
            border.width: pt
            border.color: currTheme.lineSeparatorColor

            Component {
                id: highlight

                Rectangle {
                    id:controlHighligh
                    property var isHover
                    width: 180 * pt; height: 40 * pt
                    color: currTheme.buttonColorNormal; radius: 5 * pt

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
                                    position: 0;
                                    color:  controlHighligh.isHover ? currTheme.buttonColorHoverPosition0 :
                                                               currTheme.buttonColorNormalPosition0
                                }
                                GradientStop
                                {
                                    position: 1;
                                    color:  controlHighligh.isHover ? currTheme.buttonColorHoverPosition1 :
                                                                currTheme.buttonColorNormalPosition1
                                }
                            }
                    }
//                        y: listViewPlug.currentItem.y

                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
//                    MouseArea
//                    {
//                        anchors.fill: parent
//                        onEntered: parent.isHover = true
//                        onExited: parent.isHover = false
//                    }
                } 
            }

            ListView
            {
                id:listViewPlug
                anchors.fill: parent
                anchors.margins: 10 * pt

                spacing: 10 * pt
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
                        height: 50 * pt
                        radius: 5 * pt

                        RowLayout
                        {
                            anchors.fill: parent
                            spacing: 5

                            // number plugin
                                Item {
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 30 * pt
                                    Layout.preferredWidth: 30 * pt
                                    Layout.maximumWidth: 30 * pt
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
                                        id:namePlugin
                                        anchors{
                                            topMargin: 5 * pt
                                            top: parent.top
                                            left: parent.left
                                            right: parent.right
                                        }

                                        text: name
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
//                                        wrapMode: Text.WordWrap
                                        elide: Text.ElideMiddle
                                    }

                                    Text{
                                        id:url
                                        anchors{
                                            top: namePlugin.bottom
                                            topMargin: 5 * pt
                                            left: parent.left
                                            right: parent.right
//                                            bottom: parent.bottom
                                        }
                                        elide: Text.ElideMiddle
                                        text: urlPath
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandLight12
//                                        wrapMode: Text.WordWrap
                                        verticalAlignment: Qt.AlignVCenter

                                        ToolTip
                                        {
                                            id: id_tooltip
                                            contentItem: Text{
                                                color: currTheme.textColor
                                                text: urlPath
                                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                            }
                                            background: Rectangle {
                                                border.color: currTheme.lineSeparatorColor
                                                color: currTheme.backgroundElements
                                            }
                                            visible: false
                                            delay: 500
                                        }
                                        MouseArea
                                        {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onEntered: id_tooltip.visible = true;
                                            onExited: id_tooltip.visible = false

                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: { listViewPlug.currentIndex = index}
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
                                    Layout.minimumWidth: 100 * pt
                                    Layout.maximumWidth: 100 * pt
                                    Layout.fillHeight: true
                                    Text{
                                        id: statusPlugin
                                        anchors.centerIn: parent
                                        text: status === "1" ? "Installed":"Not Installed"
                                        color: currTheme.textColor
                                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                    }
                                }
                        }
                    }

                highlight: highlight

                onCurrentIndexChanged:
                {
                    setEnableButtons()
                }
                Component.onCompleted:
                {
                    setEnableButtons()
                }

                function setEnableButtons()
                {
                    if(currentIndex >= 0)
                    {
                        if(listModel.get(listViewPlug.currentIndex).status === "1")
                        {
                            installPlug.enabled = false
                            deletePlug.enabled = true
                            uninstallPlug.enabled = true
                        }
                        else
                        {
                            installPlug.enabled = true
                            deletePlug.enabled = true
                            uninstallPlug.enabled = false
                        }
                    }
                    else
                    {
                        installPlug.enabled = false
                        deletePlug.enabled = false
                        uninstallPlug.enabled = false
                    }
                }

            }
            Component.onCompleted:{
                updatePluginsList()
            }

            Connections{
                target: dapMainWindow
                onModelPluginsUpdated:
                {
                    rectanglePlug.updatePluginsList()
                }
            }

            function updatePluginsList()
            {
                listModel.clear()

                for(var i = 0; i < dapModelPlugins.count; i++ )
                {
                    listModel.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status})
                }

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
                title: qsTr("Please choose a *.qml file")
                folder: "~"
                visible: false
                nameFilters: [qsTr("Plugin files (*.qml)"), "All files (*.*)"]
//                nameFilters: [qsTr("Plugin files (*.qml)")]
                defaultSuffix: "qml"
                onAccepted:
                {
                    pluginsManager.addPlugin(dapMessageBox.dapContentInput.text, dialogSelectPlug.files[0], 0);
//                    listModel.append({name:dapMessageBox.dapContentInput.text, urlPath: dialogSelectPlug.files[0], status:0})
                    messagePopup.close()
                    console.log("Added plugin. Name: " + dapMessageBox.dapContentInput.text + " URL: " + dialogSelectPlug.files[0])
                }
            }
            onClicked:
            {
                messagePopup.smartOpen(qsTr("Add Plugin"),qsTr("Input name plugin"))
            }
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
                pluginsManager.setStatusPlugin(listViewPlug.currentIndex, 1)
//                listModel.get(listViewPlug.currentIndex).status = "1"
                listViewPlug.setEnableButtons()
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

            id:uninstallPlug
            textButton: "Unistall Plugin"

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                if(currentPlugin === listModel.get(listViewPlug.currentIndex).urlPath){
                    currentPlugin = ""
                    SettingsWallet.activePlugin = ""
                }
                pluginsManager.setStatusPlugin(listViewPlug.currentIndex, 0)
                SettingsWallet.activePlugin = ""

                listViewPlug.setEnableButtons()
            }
        }
        DapButton
        {
            Layout.row: 2
            Layout.rowSpan: 1
            Layout.column: 4
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

                if(currentPlugin === listModel.get(listViewPlug.currentIndex).urlPath){
                    currentPlugin = ""
                    SettingsWallet.activePlugin = ""
                }
//                    listModel.remove(listViewPlug.currentIndex)
                pluginsManager.deletePlugin(listViewPlug.currentIndex)
                SettingsWallet.activePlugin = ""

                listViewPlug.setEnableButtons()
//                console.log(currentPlugin)
            }
        }
    }

    Popup{
        id: messagePopup
        closePolicy: "NoAutoClose"
        padding: 0
        background: Item{}
        width: dapMessageBox.width
        height: dapMessageBox.height
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true

        function smartOpen(title, contentText) {
            dapMessageBox.dapTitleText.text = title
            dapMessageBox.dapContentText.text = contentText
            open()
        }

        DapMessageBox {
            id: dapMessageBox
            width: 240 * pt
            height: 240 * pt
            fontMessage: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16

            dapContentInput.visible: true
            dapButtonOk.enabled: false
            dapContentInput.placeholderText: qsTr("Name plugin")
            dapContentInput.onTextChanged:
            {
                if(dapContentInput.text.replace(/\s/g,"") !== "")
                    dapButtonOk.enabled = true
                else
                    dapButtonOk.enabled = false
            }

            dapButtonOk.onClicked: {
                dialogSelectPlug.visible = true
            }
            dapButtonBack.onClicked:
            {
                messagePopup.close()
            }
        }
    }
}
