import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

WalletPageForm {
    id: root

    property bool active: false
    property string title: qsTr("Wallet")

    Component.onCompleted: {
        console.log("Форма '" + title + "'" + " открыта")
    }

    Component.onDestruction: {
        console.log("Форма '" + title + "'" + " закрыта")
    }
}
