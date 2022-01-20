import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import "qrc:/widgets"
import "../../SettingsWallet.js" as SettingsWallet

Item
{
    property alias dapAddButton: loadPlug
    property alias dapActiveButton: installPlug
    property alias dapUnactiveButton: uninstallPlug
    property alias dapDeleteButton: deletePlug

    id: defaultRightPanel

    signal currentStatusSelected(string status)

    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    ColumnLayout {
        anchors.fill: parent
//        anchors.margins: 5 * pt
        anchors.topMargin: 3 * pt
        spacing: 0 * pt

        Text {
            Layout.minimumHeight: 35 * pt
            Layout.maximumHeight: 35 * pt
            Layout.leftMargin: 15 * pt
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Filter")
        }

        ColumnLayout
        {
//            Layout.margins: 3 * pt
            Layout.leftMargin: 2 * pt
            Layout.topMargin: 3 * pt
            spacing: 0

            DapRadioButton
            {
                id: buttonSelectionAllStatuses
                nameRadioButton: qsTr("Verified")
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Verified")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionPending
                nameRadioButton: qsTr("Unverified")
                Layout.topMargin: 5 * pt
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Unverified")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionSent
                nameRadioButton: qsTr("Both")
                Layout.topMargin: 6 * pt
                indicatorInnerSize: 46 * pt
                spaceIndicatorText: 3 * pt
                fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Both")
                }
                checked: true
            }
        }

        Text {
            Layout.topMargin: 24 * pt
            Layout.leftMargin: 15 * pt
            Layout.minimumHeight: 35 * pt
            Layout.maximumHeight: 35 * pt
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Actions")
        }

        // Actions buttons

        ColumnLayout
        {
            Layout.topMargin: 16 * pt
            spacing: 24 * pt

            DapButton
            {

                Layout.preferredWidth: 350 * pt

                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                id:loadPlug
                textButton: "Add dApp"

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText: Text.AlignHCenter


                FileDialog {
                    id: dialogSelectPlug
                    title: qsTr("Please choose a *.zip file")
                    folder: "~"
                    visible: false
                    nameFilters: [qsTr("Zip files (*.zip)"), "All files (*.*)"]
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
                Layout.preferredWidth: 350 * pt

                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                id:installPlug
                textButton: "Activate dApp"

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    currentPlugin = dapAppsModel.get(dapListViewApps.currentIndex).urlPath
                    pluginsManager.installPlugin(dapListViewApps.currentIndex, 1,dapAppsModel.get(dapListViewApps.currentIndex).verifed)
                    defaultRightPanel.setEnableButtons()
                    SettingsWallet.activePlugin = currentPlugin
                }
            }
            DapButton
            {
                Layout.preferredWidth: 350 * pt

                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                id:uninstallPlug
                textButton: "Deactivate dApp"

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    if(currentPlugin === dapAppsModel.get(dapListViewApps.currentIndex).urlPath){
                        currentPlugin = ""
                        SettingsWallet.activePlugin = ""
                    }
                    pluginsManager.installPlugin(dapListViewApps.currentIndex, 0, dapAppsModel.get(dapListViewApps.currentIndex).verifed)
                    SettingsWallet.activePlugin = ""

                    defaultRightPanel.setEnableButtons()
                }
            }
            DapButton
            {
                Layout.preferredWidth: 350 * pt

                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                id:deletePlug
                textButton: "Delete dApp"

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {

                    if(currentPlugin === dapAppsModel.get(dapListViewApps.currentIndex).urlPath){
                        currentPlugin = ""
                        SettingsWallet.activePlugin = ""
                    }
    //                    listModel.remove(listViewPlug.currentIndex)
                    pluginsManager.deletePlugin(dapListViewApps.currentIndex)
                    SettingsWallet.activePlugin = ""

                    defaultRightPanel.setEnableButtons()

                    for(var i = 0; i < modelAppsTabStates.count; i++)
                    {
                        if(dapModelPlugins.get(dapListViewApps.currentIndex).name === modelAppsTabStates.get(i).name)
                        {
                            var name = modelAppsTabStates.get(i).name

                            for(var j = 0; j < modelMenuTab.count; j++)
                            {

                                if(modelMenuTab.get(j).name === name)
                                {
                                    modelMenuTab.remove(j);
                                    break;
                                }
                            }

                            modelAppsTabStates.remove(i);
                            break;
                        }
                    }
                }
            }
        }

        Rectangle
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }

    function setEnableButtons()
    {
        if(listViewApps.currentIndex >= 0 && listModelApps.count)
        {
            if(dapAppsModel.get(listViewApps.currentIndex).status === "1")
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
                var path = dapAppsModel.get(listViewApps.currentIndex).urlPath;
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
