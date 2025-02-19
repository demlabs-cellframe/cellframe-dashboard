import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3

import "qrc:/widgets"
import "Menu"
import "controls"

Page {
    id: dapMainWindow
    title: qsTr("Cellframe Wallet")
    background: Rectangle {color: currTheme.mainBackground}
    hoverEnabled: true

    readonly property string walletPage:       "qrc:/walletSkin/forms/Wallets/DapWalletsPage.qml"
//    readonly property string dexPage:          "qrc:/walletSkin/forms/DEX/DEXPage.qml"
    readonly property string dexPage:          "qrc:/walletSkin/forms/UnderConstructions.qml"
    readonly property string txExplorerPage:   "qrc:/walletSkin/forms/History/DapHistoryTab.qml"
    readonly property string dAppsPage:        "qrc:/walletSkin/forms/dApps/DapAppsTab.qml"
    readonly property string settingsPage:     "qrc:/walletSkin/forms/Settings/DapSettingsPage.qml"

    property alias infoItem: popupInfo
    property alias dapBottomPopup: bottomPopup
//    property alias comboBoxCurrentWallet: comboBoxCurrentWallet

    property alias mainViewBottom: shaderBottom

    property alias mainWebPopup: webPopup

    property bool blurBackground: false

    signal modelWalletsUpdated()
    signal changeCurrentWallet()
    signal changeCurrentNetwork()
    signal checkWebRequest()
    signal openRequests()
    signal modelPluginsUpdated()
    signal openHistory()

    ListModel {id: selectedToken}
    ListModel {id: selectedTX}
    ListModel {id: selectedDapps}
    ListModel {id: dapMessageBuffer}
    ListModel {id: dapWebSites}

    ListModel {id: dapModelPlugins}
    ListModel {id: modelAppsTabStates}


    MainApplicationLogic{id: logicMainApp}

    Settings
    {
        id: settingsWallet
        property alias menuTabStates: logicMainApp.menuTabStates
        property string currentWalletName: logicMainApp.currentWalletName
        property string currentNetworkName: logicMainApp.currentNetworkName
        property int currentNetworkIndex: logicMainApp.currentNetwork
        property int currentLanguageIndex: logicMainApp.currentLanguageIndex
        property string currentLanguageName: logicMainApp.currentLanguageName

        Component.onCompleted:
        {
            console.log("Settings", "currentLanguageIndex", currentLanguageIndex)
            console.log("Settings", "currentLanguageName", currentLanguageName)

            logicMainApp.currentLanguageIndex = currentLanguageIndex
            logicMainApp.currentLanguageName = currentLanguageName
        }
    }

        Item
        {
            id: headerItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: stackView.isDappLoad ? 60 : walletModelList.count ? 81 : 60

            ToolBar
            {
                id: headerWindow

                anchors.fill: parent

//                height: dapModelWallets.count ? 81 : 60

        //        contentHeight: 56

                background:
                Item {
                    anchors.fill: parent
                    Rectangle {
                        id: headerRect
                        Rectangle {
                            width: parent.width
                            height: 30
                            anchors.top: parent.top
                            color: currTheme.mainBackground
                        }
                        anchors.fill: parent
                        color: currTheme.mainBackground
                        radius: 30

                        border.width: 1
                        border.color: currTheme.border
                    }
                }

                Item
                {
                    id: contentItem
                    anchors.fill: parent
                    z: 1

                    ColumnLayout
                    {
                        id: contentLayout
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 0
                        anchors.topMargin: 16

                        Rectangle{
                            parent: headerWindow
                            width: headerWindow.width
                            height: headerWindow.height
                            visible: opacity
                            opacity: bottomPopup.stack.depth > 0 ? 0.3 : 0
                            color: currTheme.mainBackground
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: bottomPopup.hide()
                            }
                        }

                        RowLayout
                        {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            HeaderButtonForRightPanels
                            {
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredHeight: 24
                                Layout.preferredWidth: 24
                                id: toolButton
                                normalImage: "qrc:/walletSkin/Resources/BlackTheme/icons/navigation/daps.svg"
                                hoverImage: "qrc:/walletSkin/Resources/BlackTheme/icons/navigation/daps_hover.svg"

            //                    enabled: stackView.depth <= 1
                                onClicked: {
                                    //dappsDrawer.open()
                                }
                            }

                            Label {
                                id: titileLabel
                                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                                Layout.fillWidth: true
                                text: stackView.currentTitle
                                font: mainFont.dapFont.medium18
                                horizontalAlignment: Text.AlignHCenter
                                color: currTheme.white
                            }

                            HeaderButtonForRightPanels
                            {
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredHeight: 24
                                Layout.preferredWidth: 24
                                id: toolButton1
                                normalImage: "qrc:/walletSkin/Resources/BlackTheme/icons/new/icon_network.svg"
                                hoverImage: "qrc:/walletSkin/Resources/BlackTheme/icons/new/icon_networkHover.svg"

            //                    enabled: stackView.depth <= 1
                                onClicked: {
                                    networkDrawer.open()
                                }
                            }
                        }

                        WalletsComboBox
                        {
                            id: comboBoxCurrentWallet

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            visible: 
                            {
                                return stackView.isDappLoad ? false : walletModelList.count ? true : false
                            }
                            
                            Layout.bottomMargin: 11
                            height: 30
                            mainTextRole: "walletName"
                            imageRole: "statusProtected"
                            font: mainFont.dapFont.regular14
                            backgroundColor: "#282A33"

                            model: walletModelList

                            enabledIcon: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_activate.svg"
                            disabledIcon: "qrc:/walletSkin/Resources/BlackTheme/icons/other/icon_deactivate.svg"

                            Component.onCompleted:
                            {
                                comboBoxCurrentWallet.displayText = walletModule.getCurrentWalletName() !== "" ? walletModule.getCurrentWalletName() : defaultText
                            }

                            onItemSelected:
                            {
                                if(walletModule.getCurrentWalletName() !== comboBoxCurrentWallet.currentText)
                                {
                                    console.log(" New current wallet: " + comboBoxCurrentWallet.currentText)
                                    walletModule.setCurrentWallet(comboBoxCurrentWallet.currentText)
                                }
                            }

                            Connections
                            {
                                target: walletModule
                                function onCurrentWalletChanged()
                                {
                                    var currentWallet = walletModule.getCurrentWalletName()
                                    comboBoxCurrentWallet.displayText = currentWallet !== "" ? currentWallet : defaultText
                                }
                            }

                            defaultText: qsTr("Wallets")
                        }
                        Item{
                            Layout.fillHeight: true
                        }
                    }

                }

            }

            FastBlur {
//                z: source.z + 1
                visible: blurBackground
                anchors.fill: headerWindow
                source: headerWindow
                radius: 16
            }
        }

    DapDapsMenu
    {
        id: dappsDrawer
        width: parent.width * 0.73
        height: parent.height - frameMainWindow.header.height
        y: frameMainWindow.header.height

        onOpened:
            blurBackground = true
        onClosed:
            blurBackground = false
    }

    DapNetworkMenu
    {
        id: networkDrawer
        width: parent.width * 0.73
        height: parent.height - frameMainWindow.header.height
        y: frameMainWindow.header.height

        onOpened:
            blurBackground = true
        onClosed:
            blurBackground = false
    }



    MainStackView {
        id: stackView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: mainMenu.pushedPage === 0 ||
                        mainMenu.pushedPage === 1 ?
                            parent.bottom : mainMenu.top
//        anchors.bottom: parent.bottom
        anchors.top: headerItem.bottom

        ShaderEffectSource{
            id: shaderBottom
            sourceItem: stackView
            height: mainMenu.height
            anchors{
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }
            sourceRect: Qt.rect(x,y, width, height)
        }
    }

    FastBlur {
//        z: source.z + 1
        visible: blurBackground
        anchors.fill: stackView
        source: stackView
        radius: 16
    }
    FastBlur {
        z: source.z + 1
        visible: blurBackground
        anchors.fill: mainMenu
        source: mainMenu
        radius: 16
    }

    PopupInfo
    {
        id: popupInfo
    }

    Component.onCompleted:
    {
//        console.log()
        stackView.setInitialItem(walletPage)
//        webPopup.openPopup()
//        webPopup.setDisplayText(false, 5, -1)
//        webPopup.setDisplayText(true, "sdfdsfd", -1)

        //pluginsController.getListPlugins();

        if (logicMainApp.menuTabStates)
            logicMainApp.loadSettingsTab()
    }

    DapWebMessagePopup
    {
        id: webPopup

        onOpened:
            blurBackground = true
        onClosed:
            blurBackground = false
    }

    DapMessagePopup
    {
        id: messagePopup

        onOpened:
            blurBackground = true
        onClosed:
            blurBackground = false
    }

    DapMessagePopup
    {
        id: messagePopupVersion

        signal click()
        onSignalAccept:
        {
            if(dapButtonOk.textButton === qsTr("Update") && accept)
                logicMainApp.updateDashboard()
            click()
        }

        onOpened:
            blurBackground = true
        onClosed:
            blurBackground = false
    }

    Connections
    {
        target: dapServiceController
       
        function onVersionControllerResult(versionResult)
        {
            if(versionResult.hasUpdate && versionResult.message === "Reply version")
                logicMainApp.rcvNewVersion(app.Version, versionResult.lastVersion, versionResult.hasUpdate, versionResult.url, versionResult.message)
            else if(versionResult.message === qsTr("Reply node version"))
            {
                if(logicMainApp.nodeVersion === "" || logicMainApp.nodeVersion !== versionResult.lastVersion)
                logicMainApp.nodeVersion = versionResult.lastVersion
            }
        }

        function onNotifyStateChanged(is_connected)
        {
            logicMainApp.rcvStateNotify(is_connected)
        }
    }

    Connections{
        target: app
        function onRcvWebConenctRequest(site, index)
        {
            var rcvData = [site, index]
            logicMainApp.rcvWebConnectRequest(rcvData)
        }
    }

    Connections{
        target: pluginsController
        function onRcvListPlugins(m_pluginsList)
        {
            console.log("onRcvListPlugins")
            console.log("Plugins count:", m_pluginsList.length)
            logicMainApp.rcvPlugins(m_pluginsList)

            modelPluginsUpdated()
            logicMainApp.updateModelAppsTab()
        }
    }

    DapMainMenu
    {
        id: mainMenu
//        z: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 84

        blurBackground: mainMenu.pushedPage === 0 ||
                        mainMenu.pushedPage === 1
    }

    DapBottomPopup{
        id: bottomPopup
        z: 20
        anchors.fill: parent
//        anchors.bottomMargin: mainMenu.height

        onIsActiveChanged:
            blurBackground = isActive
//        onClosed:
//            blurBackground = false
    }
}
