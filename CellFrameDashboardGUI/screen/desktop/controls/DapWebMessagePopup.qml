import QtQuick 2.4
import QtQuick.Controls 2.5
import "../../"

DapMessagePopup {
    property int indexUser
    property string webSite

    dapButtonCancel.visible: true
//    closePolicy: Popup.CloseOnPressOutside
//    modal: false

    onSignalAccept: {
        webControl.rcvAccept(accept, indexUser)
        destroy()
    }

    Component.onCompleted:
        smartOpen("Request to work with a wallet", "The site "+ webSite +" requests permission to exchange work with the wallet.")
}
