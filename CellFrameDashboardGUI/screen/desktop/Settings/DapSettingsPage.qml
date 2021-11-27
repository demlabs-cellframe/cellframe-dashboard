import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/controls" as Controls
import "qrc:/screen/desktop"
import "qrc:/screen"

Controls.DapPage {
    id: root
    title: qsTr("Settings")

    property alias dapWalletsNames: []

    QtObject {
        id: navigator

        function createNewWallet() {
            dapRightPanel.push("qrc:/screen/desktop/Settings/RightPanel/DapCreateWallet.qml")
        }
    }

    dapScreen.initialItem: DapSettingsScreen {
        onCreateWalletSignal: navigator.createNewWallet()
    }

    Component.onCompleted: {
        for(let i = 0; i < _dapWalletsModel.length; i++) {
            dapWalletsNames.push(_dapWalletsModel[i].name)
            console.log("WALLETS NAMES I ->", dapWalletsNames[i])
        }
        console.log("Tab " + title + " opened")
    }

    Component.onDestruction: {
        console.log("Tab " + title + " closed")
    }

}
