import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import "../../controls"
import "qrc:/widgets"
import "../"
import "../BottomForms"


ColumnLayout
{
    anchors.fill: parent
    property bool sendRequest: false
    property bool isDeactivate: false
    property string popupMode: ""
    property real newScale: 1.0

    ListModel
    {
        id: modelLanguages
        ListElement { tag: "en"
            name: "English"}
        ListElement { tag: "zh"
            name: "Chinese"}
        ListElement { tag: "cs"
            name: "Czech"}
        ListElement { tag: "nl"
            name: "Dutch"}
        ListElement { tag: "pt"
            name: "Portuguese"}
        ListElement { tag: "ru"
            name: "Russian"}
    }

    Flickable{
        id: flickElement
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: mainLay.implicitHeight + walletView.contentHeight
        interactive: true
        clip: true

        MouseArea{
            anchors.fill: parent
            onClicked: {
                comboBoxCurrentNetwork.popupVisible = false
                comboBoxCurrentNetwork.popup.visible = false
            }
        }

        ColumnLayout
        {
            id: mainLay
            anchors.fill: parent
            spacing: 10

            // TEMPORARY HIDE
            // Until dictionary will not filled
            /*
            HeaderSection{
                Layout.fillWidth: true
                height: 30
                text: qsTr("GUI language")
            }

            DefaultComboBox
            {
                id: comboBoxLanguage

                z: popupVisible ? 100 : 0

                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                property bool init: false

                model: modelLanguages

                font: mainFont.dapFont.regular14

                backgroundColor: popupVisible? currTheme.secondaryBackground : "transparent"
                indicatorSource: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_chevronDownNormal.svg"

                Component.onCompleted:
                {
                    init = true

                    console.log("comboBoxLanguage onCompleted",
                                logicMainApp.currentLanguageIndex)
                    setCurrentIndex(logicMainApp.currentLanguageIndex)
                }

                onCurrentIndexChanged:
                {
                    if (init)
                    {
                        console.log("comboBoxLanguage",
                                    currentIndex,
                                    modelLanguages.get(currentIndex).tag)

                        translator.setLanguage(modelLanguages.get(currentIndex).tag)

                        logicMainApp.currentLanguageIndex = currentIndex
                        logicMainApp.currentLanguageName =
                                modelLanguages.get(currentIndex).tag

                        console.log("logicMainApp.currentLanguageIndex",
                                    logicMainApp.currentLanguageIndex)
                    }
                }
            }*/

            Settings
            {
                id: skinSettings
                property string project_skin: ""

                Component.onCompleted:
                {
                    if(project_skin == "wallet")
                    {
                        skinSwitcher.setSelected("second")
                    }
                    else
                    {
                        skinSwitcher.setSelected("first")
                    }
                }
            }

            HeaderSection
            {
                Layout.fillWidth: true
                height: 30
                text: qsTr("Choose a skin")
            }

            DapSelectorSwitch
            {
                id: skinSwitcher
                Layout.leftMargin: 16
                height: 35
                firstName: qsTr("Dashboard")
                secondName: qsTr("Wallet")
                firstColor: currTheme.green
                secondColor: currTheme.red
                itemHorisontalBorder: 16

                onToggled:
                {
                    var walletSkin = secondSelected
                    if (walletSkin)
                    {
                        skinSettings.setValue("project_skin", "wallet")
                        Qt.exit(RESTART_CODE)
                    }
                    else
                    {
                        skinSettings.setValue("project_skin", "dashboard")
                        Qt.exit(RESTART_CODE)
                    }
                }
            }

            HeaderSection{
                Layout.fillWidth: true
                height: 30
                text: qsTr("Choose a wallet")
            }

            ButtonGroup
            {
                id: buttonGroup
            }

            ListView {
                id: walletView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                model: walletModelList
                interactive: false
                clip: true
                spacing: 0

                Behavior on Layout.preferredHeight {
                    NumberAnimation{duration: 200}
                }

                delegate:
                RowLayout
                {
                    id: rowWallets
                    width: walletView.width
                    height: 64

                    Item
                    {
                        id: block
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                radioBut.clicked();
                                comboBoxCurrentNetwork.popupVisible = false
                                comboBoxCurrentNetwork.popup.visible = false
                            }
                        }

                        Item
                        {
                            width: 250
                            height: 16
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 10
                            anchors.leftMargin: 14

                            DapBigText
                            {
                                id: nameText
                                anchors.fill: parent
                                textFont: mainFont.dapFont.regular13
                                fullText: walletName
                            }
                        }

                        Item
                        {
                            id: rowLay
                            width: 107
                            height: 20
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 34
                            anchors.leftMargin: 14
                            visible: statusProtected === "Active" || statusProtected === ""

                            DapText
                            {
                                id: textMetworkAddress
                                width: 77
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter

                                fontDapText: mainFont.dapFont.regular14
                                color: currTheme.gray
                                fullText: ""

                                textElide: Text.ElideMiddle
                                horizontalAlignment: Qt.AlignJustify

                                Component.onCompleted: updateAddress()

                                Connections
                                {
                                    target: walletModule
                                    function onCurrentNetworkChanged()
                                    {
                                        textMetworkAddress.updateAddress()
                                    }
                                }

                                function updateAddress()
                                {
                                    var addr = ""
                                    if(rowLay.visible) addr = walletModule.getAddressNetworkByWallet(walletName)
                                    textMetworkAddress.fullText = addr
                                    textMetworkAddress.checkTextElide()
                                    textMetworkAddress.updateText()
                                }
                            }

                            CopyButton
                            {
                                id: networkAddressCopyButton
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                popupText: qsTr("Address copied")
                                onCopyClicked:
                                    textMetworkAddress.copyFullText()
                            }
                        }

                        DapToolTipInfo
                        {
                            id: activeStatus
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 45
                            visible: model.statusProtected !== ""
                            text.wrapMode: Text.NoWrap

                            toolTip.width: text.implicitWidth + 16
                            toolTip.x: -toolTip.width/2 + 8

                            contentText: model.statusProtected === "Active" ? qsTr("Deactivate wallet") : qsTr("Activate wallet")

                            indicatorSrcNormal: model.statusProtected === "Active" ? "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_activate.svg":
                                                                                     "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                            indicatorSrcHover: model.statusProtected === "Active" ? "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_activateHover.svg":
                                                                                    "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_deactivateHover.svg"

                            onClicked:
                            {
                                comboBoxCurrentNetwork.popupVisible = false
                                comboBoxCurrentNetwork.popup.visible = false

                                model.statusProtected === "Active" ? dapBottomPopup.showDeactivateWallet(walletName):
                                                                     dapBottomPopup.showActivateWallet(walletName, false)

                                isDeactivate = model.statusProtected !== "Active"
                            }

                            Connections
                            {
                                target: dapBottomPopup

                                function onActivatingSignal(nameWallet, statusRequest){
                                    if(nameWallet === walletName && statusRequest)
                                    {
                                        walletModule.setCurrentWallet(walletName)
                                        activeStatus.mouseArea.enabled = false
                                    }
                                }

                                function onDeactivatingSignal(nameWallet, statusRequest){
                                    if(nameWallet === walletName && statusRequest)
                                    {
                                        activeStatus.mouseArea.enabled = false
                                    }
                                }
                            }
                        }

                        Item
                        {
                            width: 20
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 14

                            DapRadioButton
                            {
                                id: radioBut
                                width: 46
                                height: 46
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter

                                ButtonGroup.group: buttonGroup

                                nameRadioButton: qsTr("")
                                indicatorInnerSize: 46
                                spaceIndicatorText: 3
                                fontRadioButton: mainFont.dapFont.regular16
                                implicitHeight: indicatorInnerSize
                                checked: walletName === walletModule.currentWalletName ? true : false

                                onClicked:
                                {
                                    comboBoxCurrentNetwork.popupVisible = false
                                    comboBoxCurrentNetwork.popup.visible = false
                                    if(walletModule.currentWalletName !== walletName) walletModule.setCurrentWallet(walletName)
                                }
                            }
                        }


                        Rectangle
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            color: currTheme.secondaryBackground
                        }
                    }
                }
            }


            HeaderSection{
                Layout.fillWidth: true
                height: 30
                text: qsTr("Networks")
            }

            Item {
                Layout.topMargin: -17
                height: 60
                Layout.fillWidth: true
                z: 1

                DefaultComboBox
                {
                    id: comboBoxCurrentNetwork

                    property bool isInit: false

                    model: networkListModel
                    mainTextRole: "networkName"

                    anchors.fill: parent
                    anchors.bottomMargin: 0
                    anchors.topMargin: 5
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    font: mainFont.dapFont.regular14

                    backgroundColor: popupVisible? currTheme.secondaryBackground : "transparent"
                    indicatorSource: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_chevronDownNormal.svg"

                    defaultText: qsTr("Networks")

                    Component.onCompleted:
                    {
                        isInit = true
                        for(var i=0; i<model.count; ++i)
                        {
                            if(model.get(i).networkName === walletModule.currentNetworkName)
                            {
                                setCurrentIndex(i)
                                break
                            }
                        }
                    }

                    onCurrentIndexChanged:
                    {
                        if(isInit)
                        {
                            if(walletModule.currentNetworkName !== displayText)
                            {
                                walletModule.currentNetworkName = displayText
                            }
                        }
                        dapMainWindow.changeCurrentNetwork()
                    }
                }
            }

            ColumnLayout
            {
                Layout.fillWidth: true
                Layout.topMargin: -17
                visible: !params.isMobile

                HeaderSection{
                    Layout.fillWidth: true
                    height: 30
                    text: qsTr("Window scale")
                }

                Item{
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
//                    Layout.topMargin: -17
                    height: 50

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16

                        Text {
                            Layout.alignment: Qt.AlignLeft
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                            text: qsTr("Scale value")
                            font: mainFont.dapFont.regular14
                            color: currTheme.white
                        }

                        DapDoubleSpinBox
                        {
                            id: scaleSpinbox

                            Layout.alignment: Qt.AlignRight
                            Layout.maximumWidth: 94
                            Layout.minimumWidth: 94

                            Layout.minimumHeight: 18
                            Layout.maximumHeight: 18

                            font: mainFont.dapFont.regular14

                            realFrom: params.minScale
                            realTo: params.maxScale
                            realStep: 0.05
                            decimals: 2

                            maxSym: 4

                            value: Math.round(params.settingsScale*100)
                        }
                    }

                }

                DapMessagePopup
                {
                    id: popup
                    dapButtonCancel.visible: true
                    dapButtonOk.textButton: qsTr("Accept")

                    onSignalAccept:
                    {
                        if (popupMode === "scale")
                        {
                            if (accept)
                                params.setNewScale(newScale)
                        }
                    }
                    onOpened:
                    {
                        dapMainWindow.blurBackground = true
                    }
                    onClosed:
                    {
                        dapMainWindow.blurBackground = false
                    }
                }

                Item {
                    height: 26
                    Layout.fillWidth: true
    //                Layout.topMargin: 20
//                    Layout.topMargin: -17
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16

                    RowLayout
                    {
                        anchors.fill: parent
                        spacing: 10

                        DapButton
                        {
                            id: resetScale

                            focus: false

                            Layout.fillWidth: true

                            Layout.minimumHeight: 26
                            Layout.maximumHeight: 26

                            textButton: qsTr("Reset scale")

                            fontButton: mainFont.dapFont.medium14
                            horizontalAligmentText: Text.AlignHCenter

                            onClicked:
                            {
                                newScale = 1.0

                                popupMode = "scale"

                                popup.smartOpen(qsTr("Confirm reboot"),
                                    qsTr("You must restart the application to apply the new scale. Do you want to restart now?"))
                            }
                        }

                        DapButton
                        {
                            id: applyScale

                            focus: false

                            Layout.fillWidth: true

                            Layout.minimumHeight: 26
                            Layout.maximumHeight: 26

                            textButton: qsTr("Apply scale")

                            fontButton: mainFont.dapFont.medium14
                            horizontalAligmentText: Text.AlignHCenter

                            onClicked:
                            {
                                if (scaleSpinbox.editedValue != scaleSpinbox.realValue)
                                {
                                    console.log("scaleSpinbox.editedValue",
                                                scaleSpinbox.editedValue,
                                                "scaleSpinbox.realValue",
                                                scaleSpinbox.realValue)

                                    newScale = scaleSpinbox.editedValue
                                }
                                else
                                    newScale = scaleSpinbox.realValue

                                console.log("newScale", newScale)

                                popupMode = "scale"

                                popup.smartOpen(qsTr("Confirm reboot"),
                                    qsTr("You must restart the application to apply the new scale. Do you want to restart now?"))
                            }
                        }
                    }
                }
            }

            HeaderSection
            {
                Layout.fillWidth: true
                height: 30
                text: qsTr("Info")
                z: 0
            }

            Item
            {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: -17
                height: 50
                z: 0

                RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Text {
                        Layout.alignment: Qt.AlignLeft
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        text: qsTr( "Wallet version ") + app.Version
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                    }

                    Item{Layout.fillWidth: true}

                    Text {
                        Layout.alignment: Qt.AlignRight
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        text: qsTr("Check update")
                        font: mainFont.dapFont.medium14
                        color: currTheme.lime

                        MouseArea{
                            anchors.fill: parent
                            onClicked:
                            {
                                comboBoxCurrentNetwork.popupVisible = false
                                comboBoxCurrentNetwork.popup.visible = false

                                sendRequest = true
                                logicMainApp.requestToService("DapVersionController", "version")
                            }
                        }
                    }
                }

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.secondaryBackground
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: -17
                height: 50
                z: 0

                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Layout.alignment: Qt.AlignLeft
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr( "Node version ") + settingsModule.nodeVersion
                    font: mainFont.dapFont.regular14
                    color: currTheme.white
                }

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.secondaryBackground
                }
            }

            Item{
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: -17
                height: 50
                z: 0

                RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 5

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        text: qsTr( "Node connection status ")
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                    }

                    Item{Layout.fillWidth: true}

                    DapImageLoader
                    {
                        id: notifyState
                        Layout.preferredHeight: 8
                        Layout.preferredWidth: 8
                        innerWidth: 8
                        innerHeight: 8
                        source: dapServiceController.notifyState ? "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/indicator_online.png":
                                                          "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/indicator_error.png"
                    }

                    Text
                    {
                        Layout.alignment: Qt.AlignRight
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        text: dapServiceController.notifyState ? qsTr("Online") : qsTr("Offline")
                        font: mainFont.dapFont.regular14
                        color: dapServiceController.notifyState ? currTheme.green : currTheme.red
                    }
                }

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.secondaryBackground
                }
            }
            Item
            {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.topMargin: -17
                height: !modulesController.FULL_SCREEN_USE ? 50 : 0
                z: 0

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 10

                    DapButton
                    {
                        Layout.fillWidth: true


                        Layout.minimumHeight: 26
                        Layout.maximumHeight: 26
                        hoverEnabled: true

                        textButton: qsTr("Full screen")

                        implicitHeight: 26
                        fontButton: mainFont.dapFont.medium14
                        horizontalAligmentText: Text.AlignHCenter

                        onClicked:
                        {
                            fullScreen.onClickFullScreen()
                        }
                    }

                    DapButton
                    {
                        Layout.fillWidth: true

                        Layout.minimumHeight: 26
                        Layout.maximumHeight: 26
                        hoverEnabled: true

                        textButton: qsTr("Close")

                        implicitHeight: 26
                        fontButton: mainFont.dapFont.medium14
                        horizontalAligmentText: Text.AlignHCenter

                        onClicked:
                        {
                            fullScreen.onClose()
                        }
                    }
                }

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.secondaryBackground
                }
            }
        }
    }

    Item
    {
        Layout.fillWidth: true
        height: 108

        MouseArea
        {
            anchors.fill: parent
            onClicked: {
                comboBoxCurrentNetwork.popupVisible = false
                comboBoxCurrentNetwork.popup.visible = false
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 81
            anchors.rightMargin: 81
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 12

            DapButton
            {
                Layout.fillWidth: true

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36
                hoverEnabled: true

                textButton: qsTr("Create a new wallet")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    comboBoxCurrentNetwork.popupVisible = false
                    comboBoxCurrentNetwork.popup.visible = false
                    logicMainApp.restoreWalletMode = false
                    dapBottomPopup.show("qrc:/walletSkin/forms/Settings/BottomForms/DapCreateWallet.qml")
                }
            }

            DapButton
            {
                Layout.fillWidth: true

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36
                hoverEnabled: true

                textButton: qsTr("Import an existing wallet")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    comboBoxCurrentNetwork.popupVisible = false
                    comboBoxCurrentNetwork.popup.visible = false
                    logicMainApp.restoreWalletMode = true
                    dapBottomPopup.show("qrc:/walletSkin/forms/Settings/BottomForms/DapCreateWallet.qml")
                }
            }
        }
    }

    Timer
    {
        id: updateSettingsTimer
        interval: 4000; running: false; repeat: true
        onTriggered:
        {
            if(!dapServiceController.notifyState || logicMainApp.nodeVersion === "")
                dapServiceController.requestToService("DapVersionController", "version node")
        }
    }

    Component.onCompleted:
    {
        dapServiceController.requestToService("DapVersionController", "version node")
        updateSettingsTimer.start()
    }

    Component.onDestruction:
        updateSettingsTimer.stop()

    onSendRequestChanged: if(sendRequest) timeout.start()

    Timer
    {
        id: timeout
        interval: 10000; running: false; repeat: false;
        onTriggered: {
            messagePopupVersion.smartOpen(qsTr("Wallet update"), qsTr("Service not found"))
            sendRequest = false
        }
    }

    Connections
    {
        target: dapServiceController
        function onWalletCreated()
        {
//            dapIndexCurrentWallet = settingsScreen.dapGeneralBlock.dapContent.dapCurrentWallet
        } 

    }    

    Connections
    {
        target: app

        function onVersionControllerResult(versionResult)
        {
            if(sendRequest)
            {
                timeout.stop()
                var result = versionResult.result
                if(!result.hasUpdate && result.message === "Reply version")
                    logicMainApp.rcvReplyVersion()
                else if(result.message !== "")
                    messagePopupVersion.smartOpen(qsTr("Wallet update"), qsTr("Current version - ") + app.Version +"\n"+
                                                                         qsTr("Last version - ") + versionResult.lastVersion +"\n" +
                                                                         qsTr("Go to website to download?"))
            }
        }
    }

    Connections
    {
        target: messagePopupVersion
        function onClick() {sendRequest = false}
    }
}

