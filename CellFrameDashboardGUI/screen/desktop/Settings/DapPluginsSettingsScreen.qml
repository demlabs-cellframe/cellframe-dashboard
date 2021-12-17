import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12
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

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10 * pt
//        rows: 3
//        columns: 4

//        rowSpacing: 10 * pt

        Rectangle
        {
            id:rectanglePlug
//            Layout.row: 1
//            Layout.rowSpan: 1
//            Layout.column: 1
//            Layout.columnSpan: 4
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
                                            bottom: parent.bottom
                                            bottomMargin: 8 * pt
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
                            // verifed plugin
                                Item {
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 100 * pt
                                    Layout.maximumWidth: 100 * pt
                                    Layout.fillHeight: true

                                    RowLayout
                                    {
                                        anchors.fill: parent
                                        Rectangle
                                        {
                                            Layout.maximumHeight: 30
                                            Layout.maximumWidth: 10
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            radius: 5 * pt
//                                            color: verifed === "1" ? "green" : "red"
                                            color: verifed === "1" ? "green" : currTheme.backgroundMainScreen
                                        }
                                        Text{
//                                            Layout.fillHeight: true
//                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignCenter
                                            id: verifedPlugin
//                                            anchors.centerIn: parent
                                            text: verifed === "1" ? "Verifed":"Not Verifed"
                                            color: currTheme.textColor
                                            font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                        }
                                        Rectangle
                                        {
                                            Layout.fillHeight: true
//                                            anchors.right: parent.right
//                                            anchors.top: parent.top
//                                            anchors.bottom: parent.bottom
                                            width: 2 * pt
                                            color: currTheme.lineSeparatorColor
                                        }
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

                        if(deletePlug.enabled === true)
                        {
                            var path = listModel.get(listViewPlug.currentIndex).urlPath;
                            if((path[0] + path[1] + path[2]) === "htt")
                            {
                                deletePlug.enabled = false
                            }
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
            Connections{
                target:pluginsManager
                onRcvProgressDownload:
                {
                    if(!completed)
                    {
                        if(!messagePopup.isOpen)
                        {
                            messagePopup.openProgress();
                            messagePopup.progress_text.text = progress + " %";
                            messagePopup.progress_bar.currentValue = progress;
                            messagePopup.name = name;
                            messagePopup.download = "Download: " + download;
                            messagePopup.total =  "Total: " + total;
                            messagePopup.time = "Time remain: " + time;
                            messagePopup.speed = "Speed: " + speed;
                            messagePopup.errors.text = error;

                        }
                        else
                        {
                            messagePopup.progress_text.text = progress + " %";
                            messagePopup.progress_bar.currentValue = progress;
                            messagePopup.name = name;
                            messagePopup.download = "Download: " + download;
                            messagePopup.total =  "Total: " + total;
                            messagePopup.time = "Time remain: " + time;
                            messagePopup.speed = "Speed: " + speed;
                            messagePopup.errors.text = error;
                        }
                        if(error === "Connected")
                        {
                            messagePopup.errors.color = "#B3FF00"
                        }
                        else
                        {
                             messagePopup.errors.color = currTheme.buttonColorNormal
                        }
                    }
                    else
                    {
                        messagePopup.close();
                        messagePopup.progress_text.text = "";
                    }
                }
                onRcvAbort:
                {
                    messagePopup.close()
                    messagePopup.isOpen = false
                    messagePopup.progress_text.text = "";
                }

            }

            function updatePluginsList()
            {
                listModel.clear()

                for(var i = 0; i < dapModelPlugins.count; i++ )
                {
                    listModel.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
                }
                listViewPlug.setEnableButtons()

            }
        }

        RowLayout
        {
            DapButton
            {
//                Layout.row: 2
//                Layout.rowSpan: 1
//                Layout.column: 1
//                Layout.columnSpan: 1
                Layout.fillWidth: true

                implicitHeight: 36 * pt
                implicitWidth: 163 * pt

                id:loadPlug
                textButton: "Add Plugin"

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter


                FileDialog {
                    id: dialogSelectPlug
                    title: qsTr("Please choose a *.zip file")
                    folder: "~"
                    visible: false
                    nameFilters: [qsTr("Zip files (*.zip)"), "All files (*.*)"]
    //                nameFilters: [qsTr("Plugin files (*.qml)")]
                    defaultSuffix: "qml"
                    onAccepted:
                    {
                        pluginsManager.addPlugin(dialogSelectPlug.files[0], 0, 0);
    //                    listModel.append({name:dapMessageBox.dapContentInput.text, urlPath: dialogSelectPlug.files[0], status:0})
    //                    messagePopup.close()
    //                    console.log("Added plugin. Name: " + dapMessageBox.dapContentInput.text + " URL: " + dialogSelectPlug.files[0])
                    }
                }
                onClicked:
                {
                    dialogSelectPlug.open()
    //                messagePopup.smartOpen(qsTr("Add Plugin"),qsTr("Input name plugin"))
                }
            }
            DapButton
            {
//                Layout.row: 2
//                Layout.rowSpan: 1
//                Layout.column: 2
//                Layout.columnSpan: 1
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
                    pluginsManager.installPlugin(listViewPlug.currentIndex, 1,listModel.get(listViewPlug.currentIndex).verifed)
    //                listModel.get(listViewPlug.currentIndex).status = "1"
                    listViewPlug.setEnableButtons()
                    SettingsWallet.activePlugin = currentPlugin
                }
            }
            DapButton
            {
//                Layout.row: 2
//                Layout.rowSpan: 1
//                Layout.column: 3
//                Layout.columnSpan: 1
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
                    pluginsManager.installPlugin(listViewPlug.currentIndex, 0, listModel.get(listViewPlug.currentIndex).verifed)
                    SettingsWallet.activePlugin = ""

                    listViewPlug.setEnableButtons()
                }
            }
            DapButton
            {
//                Layout.row: 2
//                Layout.rowSpan: 1
//                Layout.column: 4
//                Layout.columnSpan: 1
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
    }

    Popup{

        property alias progress_text: bar_progress
        property alias progress_bar: bar_progress

        property alias name: _name.text
        property alias total: _total.text
        property alias download: _download.text
        property alias speed: _speed.text
        property alias time: _time.text
        property alias errors: _errors

        property alias frame:framePopup

        property bool isOpen: false

        id: messagePopup
        closePolicy: "NoAutoClose"
        parent: plugins

        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        //        padding: 0
        //        background: Item{}
        //        width: dapMessageBox.width
        //        height: dapMessageBox.height
        //        x: (parent.width - width) / 2
        //        y: (parent.height - height) / 2
        modal: false

        padding: 100

        contentItem:
            Rectangle
            {
                anchors.fill: parent
                color:"#bf363A42"
                radius: 16*pt

                Rectangle
                {
                    id:framePopup
                    anchors.fill: parent
                    anchors.margins: 50 * pt
                    anchors.leftMargin: 80 * pt
                    anchors.rightMargin: 80 * pt
                    anchors.centerIn: parent
                    radius: 16*pt
                    color:currTheme.backgroundMainScreen

                    GridLayout
                    {
                        rows: 7
                        columns: 2
                        anchors.fill: parent

                        Text{
                            Layout.row:1
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 1

                            Layout.fillWidth: true

                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
                            Layout.leftMargin: 10 * pt

                            id:_name

                            color: currTheme.textColor;
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            Layout.row:2
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 1

                            Layout.fillWidth: true

                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
                            Layout.leftMargin: 10 * pt

                            id:_total

                            color: currTheme.textColor;
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            horizontalAlignment: Text.AlignLeft
                        }
                        Text{
                            Layout.row:3
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 1

                            Layout.fillWidth: true

                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
                            Layout.leftMargin: 10 * pt

                            id:_download

                            color: currTheme.textColor;
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            horizontalAlignment: Text.AlignLeft
                        }
                        Text{
                            Layout.row:4
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 1

                            Layout.fillWidth: true

                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
                            Layout.leftMargin: 10 * pt

                            id:_speed

                            color: currTheme.textColor;
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            horizontalAlignment: Text.AlignLeft
                        }
                        Text{
                            Layout.row:5
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 1

                            Layout.fillWidth: true

                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
                            Layout.leftMargin: 10 * pt

                            id:_time

                            color: currTheme.textColor;
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                            horizontalAlignment: Text.AlignLeft
                        }

                        DapPluginsProgressBar
                        {
                            Layout.row:1
                            Layout.rowSpan: 5
                            Layout.column:2
                            Layout.columnSpan: 1
                            id: bar_progress
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            Layout.minimumWidth: 130
                            Layout.maximumWidth: 130
    //                        width: 200
    //                        height: 200

                        }
                        Text{
                            Layout.row:6
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 2

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter


                            id:_errors

//                            color: currTheme.textColor
                            color: "#B3FF00"
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
    //                        horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignHCenter
                        }

                        DapButton
                        {
                            Layout.row:7
                            Layout.rowSpan: 1
                            Layout.column:1
                            Layout.columnSpan: 2
                            Layout.alignment: Qt.AlignHCenter

                            Layout.minimumHeight: 36 * pt
                            Layout.maximumHeight: 36 * pt

                            Layout.minimumWidth: 163 * pt
                            Layout.maximumWidth: 163 * pt

//                            implicitHeight: 36 * pt
//                            implicitWidth: 163 * pt

                            id:canceledDownload
                            textButton: "Cancel"

                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                            horizontalAligmentText: Text.AlignHCenter
                            onClicked:
                            {
                                pluginsManager.cancelDownload();
                            }
                        }

//                        DapButton
//                        {
//                            Layout.row:1
//                            Layout.rowSpan: 4
//                            Layout.column:3
//                            Layout.columnSpan: 1
//                            Layout.alignment: Qt.AlignHCenter

//                            Layout.fillWidth: true

//                            implicitHeight: 36 * pt
//                            implicitWidth: 163 * pt
//                            Layout.minimumWidth: 130
//                            Layout.maximumWidth: 130

//                            id:reloadDownload
//                            textButton: "Reload"
//                            enabled: false
//                            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
//                            horizontalAligmentText: Text.AlignHCenter
//                        }
                    }

                }

                DropShadow {
                        anchors.fill: framePopup
                        horizontalOffset: currTheme.hOffset
                        verticalOffset: currTheme.vOffset
                        radius: currTheme.radiusShadow
                        color: currTheme.shadowColor
                        source: framePopup
                        spread: 0.1
                        smooth: true
                    }
            }
        background: Item{}


        function openProgress()
        {
            isOpen = true;
            open()
        }




//        function smartOpen(title, contentText) {
//            dapMessageBox.dapTitleText.text = title
//            dapMessageBox.dapContentText.text = contentText
//            open()
//        }

//        DapMessageBox {
//            id: dapMessageBox
//            width: 240 * pt
//            height: 240 * pt
//            fontMessage: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16

////            dapContentInput.visible: false
//            dapButtonOk.enabled: false
//            dapButtonBack.text: qsTr("Cancel")
////            dapContentInput.placeholderText: qsTr("Name plugin")
////            dapContentInput.onTextChanged:
////            {
////                if(dapContentInput.text.replace(/\s/g,"") !== "")
////                    dapButtonOk.enabled = true
////                else
////                    dapButtonOk.enabled = false
////            }

//            dapButtonBack.onClicked:
//            {
//                messagePopup.close()
//            }
//        }
    }
}
