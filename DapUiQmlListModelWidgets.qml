import QtQuick 2.0

ListModel {
    id: listModelMenu
    
    ListElement {
        name:  qsTr("Blockchain explorer")
        page: "DapUiQmlWidgetChainBlockExplorer.ui.qml"
    }
    ListElement {
        name:  qsTr("Exchanges")
        page: "DapUiQmlWidgetChainExchanges.ui.qml"
    }
    ListElement {
        name:  qsTr("Services client")
        page: "DapUiQmlWidgetChainServicesClient.ui.qml"
    }
    ListElement {
        name:  qsTr("Services share control")
        page: "DapUiQmlWidgetChainServicesShareControl.ui.qml"
    }
    ListElement {
        name:  qsTr("Settings")
        page: "DapUiQmlWidgetChainSettings.ui.qml"
    }
    ListElement {
        name:  qsTr("Wallet")
        page: "DapUiQmlWidgetChainWallet.ui.qml"
    }
}
