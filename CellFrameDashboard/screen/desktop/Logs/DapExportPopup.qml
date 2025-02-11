import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

import "qrc:/widgets"
import "../../"
import "../controls"

DapMessagePopup {

    ///@detalis filterFileArray Array with filters for the file saving window.
    property var filterFileArray:["Text files (*.txt)", "Log files (*.log)"]

    property alias buttonExport: buttonExport
    property string currentPeriod: qsTr("24h")

    id: root

    width: 328
    height: 356 - 76 // 76 - hide buttons period

    ListModel{
        id: logsModel
        ListElement{name: qsTr("Cellframe node logs")}
        ListElement{name: qsTr("Dashboard logs")}
    }

    contentItem: Item{
        anchors.fill: parent
        id: content

        HeaderButtonForRightPanels{
            anchors.top: parent.top
            anchors.topMargin: 9
            anchors.right: parent.right
            anchors.rightMargin: 10

            id: itemButtonClose
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20

            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

            onClicked: root.close()
        }

        Text {
            id: title
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 24

            font: mainFont.dapFont.bold14
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Export logs")


        }

        ColumnLayout{
            id: layout
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonExport.top

            anchors.topMargin: 24
            anchors.bottomMargin: 44
            spacing: 20

            Rectangle{
                Layout.fillWidth: true
                height: 30
                color: currTheme.mainBackground

                Text{
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft

                    text: qsTr("Select type of logs")
                    font: mainFont.dapFont.medium12
                    color: currTheme.white
                }
            }

            Rectangle
            {
                height: 40
                color: "transparent"
                Layout.fillWidth: true

                DapCustomComboBox
                {
                    id: comboboxLogs

                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    model: logsModel
//                    backgroundColorShow: currTheme.secondaryBackground

                    font: mainFont.dapFont.regular16

                    defaultText: qsTr("Cellframe node logs")
                }
            }

            Rectangle{
                visible: false
                Layout.fillWidth: true
                height: 30
                color: currTheme.mainBackground

                Text{
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft

                    text: qsTr("Select a time period")
                    font: mainFont.dapFont.medium12
                    color: currTheme.white
                }
            }

            RowLayout
            {
                visible: false
                Layout.fillWidth: true
                Layout.rightMargin: 24
                Layout.leftMargin: 24

                DapButton
                {
                    id: button1h
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("1h")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        button1h.selected = true
                        button12h.selected = false
                        button24h.selected = false
                        buttonWeek.selected = false

                        currentPeriod = textButton
                    }
                }

                DapButton
                {
                    id: button12h
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("12h")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        button1h.selected = false
                        button12h.selected = true
                        button24h.selected = false
                        buttonWeek.selected = false

                        currentPeriod = textButton
                    }
                }

                DapButton
                {
                    id: button24h
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("24h")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: true
                    onClicked:
                    {
                        button1h.selected = false
                        button12h.selected = false
                        button24h.selected = true
                        buttonWeek.selected = false

                        currentPeriod = textButton
                    }
                }

                DapButton
                {
                    id: buttonWeek
                    Layout.fillWidth: true
                    implicitHeight: 26
                    textButton: qsTr("Week")
                    horizontalAligmentText: Text.AlignHCenter
                    indentTextRight: 0
                    fontButton: mainFont.dapFont.medium12
                    selected: false
                    onClicked:
                    {
                        button1h.selected = false
                        button12h.selected = false
                        button24h.selected = false
                        buttonWeek.selected = true

                        currentPeriod = textButton
                    }
                }
            }

            Item{Layout.fillHeight: true}
        }

        DapButton
        {
            id: buttonExport

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.rightMargin: 24
            anchors.leftMargin: 24

            Layout.fillWidth: true

            Layout.minimumHeight: 36
            Layout.maximumHeight: 36

            textButton: qsTr("Export logs")

            implicitHeight: 36
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:
            {
                exportDialog.open()
//                root.close() //todo
//                signalAccept(true)
            }
        }
    }

    FileDialog
    {
        id: exportDialog
        title: qsTr("Export ") + comboboxLogs.displayText
        fileMode: FileDialog.SaveFile
        nameFilters: filterFileArray
        selectedNameFilter.index: 0
        modality: Qt.WindowModal


        onFileChanged:
        {
            var resultAddres = String(currentFile).replace(/file:\/\//,"");
            resultAddres = resultAddres.replace(/\.([$A-Za-z0-9]{2,4})/,"");
            resultAddres += "." + selectedNameFilter.extensions[0];

            logsModule.exportLog(resultAddres, comboboxLogs.currentIndex, currentPeriod)
        }
    }

    Connections{
        target: logsModule
        function onLogsExported(status)
        {
            console.log("export log status = ", status)

            if(status)
                dapMainWindow.infoItem.showInfo(
                            0,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Logs exported"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")

            else
                dapMainWindow.infoItem.showInfo(
                            196,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Fail exported logs"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")

            root.close();
        }
    }
}
