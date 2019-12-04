import QtQuick 2.0

Component {
//    property string walletAddress
//    width: parent.width
//    height: 32 * pt

    Text {
        anchors.fill: parent
        text: qsTr("Wallet address: ") + walletAddressDisplayRole
    }
}
