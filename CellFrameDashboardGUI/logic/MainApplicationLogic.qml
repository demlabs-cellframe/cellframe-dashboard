import QtQuick 2.12
import QtQml 2.12

QtObject {
    property var  currentIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    //wallets create param
    property bool restoreWalletMode: false
    property string currentTab
    property string walletRecoveryType: "Nothing"
    //

    property var networkArray: ""

    readonly property int autoUpdateInterval: 3000
}
