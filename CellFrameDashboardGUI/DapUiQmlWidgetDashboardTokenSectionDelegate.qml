import QtQuick 2.0

Component {
    Text {
        anchors.fill: parent
        text: qsTr("Wallet address: ") + walletAddressDisplayRole
    }
}
