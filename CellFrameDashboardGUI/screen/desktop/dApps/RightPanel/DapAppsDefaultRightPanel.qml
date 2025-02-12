import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import "qrc:/widgets"

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
//        anchors.margins: 5 
        anchors.topMargin: 3 
        spacing: 0 

        Text {
            Layout.minimumHeight: 35 
            Layout.maximumHeight: 35 
            Layout.leftMargin: 15 
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Filter")
        }

        ColumnLayout
        {
//            Layout.margins: 3 
            Layout.leftMargin: 2 
            Layout.topMargin: 3 
            spacing: 0

            DapRadioButton
            {
                id: buttonSelectionAllStatuses
                Layout.fillWidth: true
                nameRadioButton: qsTr("Verified")
                indicatorInnerSize: 46 
                spaceIndicatorText: 3 
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Verified")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionPending
                Layout.fillWidth: true
                nameRadioButton: qsTr("Unverified")
                Layout.topMargin: 5 
                indicatorInnerSize: 46 
                spaceIndicatorText: 3 
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Unverified")
                }
            }

            DapRadioButton
            {
                id: buttonSelectionSent
                Layout.fillWidth: true
                nameRadioButton: qsTr("Both")
                Layout.topMargin: 6 
                indicatorInnerSize: 46 
                spaceIndicatorText: 3 
                fontRadioButton: mainFont.dapFont.regular16
                implicitHeight: indicatorInnerSize
                onClicked: {
                    currentStatusSelected("Both")
                }
                checked: true
            }
        }

        Text {
            Layout.topMargin: 24 
            Layout.leftMargin: 15 
            Layout.minimumHeight: 35 
            Layout.maximumHeight: 35 
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Actions")
        }

        // Actions buttons

        ColumnLayout
        {
            Layout.topMargin: 16 
            spacing: 24 

            DapButton
            {

                Layout.preferredWidth: 350 

                implicitHeight: 36 
                implicitWidth: 350 

                id:loadPlug
                textButton: qsTr("Add dApp")

                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Text.AlignHCenter


                FileDialog {
                    id: dialogSelectPlug
                    title: qsTr("Please choose a *.zip file")
                    folder: "~"
                    visible: false
                    nameFilters: [qsTr("Zip files (*.zip)"), qsTr("All files (*.*)")]
                    defaultSuffix: "qml"
                    onAccepted:
                    {
                        //dAppsModule.addPlugin(dialogSelectPlug.files[0], 0, 0);
                        dAppsModule.addLocalPlugin(dialogSelectPlug.files[0]);
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

                DapCustomToolTip{
                    contentText: qsTr("Add dApp")
                }
            }
            DapButton
            {
                Layout.preferredWidth: 350 

                implicitHeight: 36 
                implicitWidth: 350 

                id:installPlug
                textButton: qsTr("Activate dApp")

                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    currentPlugin = dapAppsModel.get(dapListViewApps.currentIndex).urlPath
                    var namePlugin = dapAppsModel.get(dapListViewApps.currentIndex).name
                    //dAppsModule.installPlugin(namePlugin, 1,dapAppsModel.get(dapListViewApps.currentIndex).verifed)
                    dAppsModule.activatePlugin(namePlugin)
                    defaultRightPanel.setEnableButtons()
                    logicMainApp.activePlugin = currentPlugin
                }

                DapCustomToolTip{
                    contentText: qsTr("Activate dApp")
                }
            }
            DapButton
            {
                Layout.preferredWidth: 350 

                implicitHeight: 36 
                implicitWidth: 350 

                id:uninstallPlug
                textButton: qsTr("Deactivate dApp")

                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    if(currentPlugin === dapAppsModel.get(dapListViewApps.currentIndex).urlPath){
                        currentPlugin = ""
                        logicMainApp.activePlugin = ""
                    }
                    var namePlugin = dapAppsModel.get(dapListViewApps.currentIndex).name
                    //dAppsModule.installPlugin(namePlugin, 0, dapAppsModel.get(dapListViewApps.currentIndex).verifed)
                    dAppsModule.deactivatePlugin(namePlugin)
                    logicMainApp.activePlugin = ""

                    defaultRightPanel.setEnableButtons()
                }

                DapCustomToolTip{
                    contentText: qsTr("Deactivate dApp")
                }
            }
            DapButton
            {
                Layout.preferredWidth: 350 

                implicitHeight: 36 
                implicitWidth: 350 

                id:deletePlug
                textButton: qsTr("Delete dApp")

                fontButton: mainFont.dapFont.regular16
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {

                    if(currentPlugin === dapAppsModel.get(dapListViewApps.currentIndex).urlPath){
                        currentPlugin = ""
                        logicMainApp.activePlugin = ""
                    }
    //                    listModel.remove(listViewPlug.currentIndex)
                    //dAppsModule.deletePlugin(dapAppsModel.get(dapListViewApps.currentIndex).urlPath)
                    logicMainApp.activePlugin = ""

                    defaultRightPanel.setEnableButtons()

                    for(var i = 0; i < modelAppsTabStates.count; i++)
                    {
                        if(dapAppsModel.get(dapListViewApps.currentIndex).name === modelAppsTabStates.get(i).name)
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

                DapCustomToolTip{
                    contentText: qsTr("Delete dApp")
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
