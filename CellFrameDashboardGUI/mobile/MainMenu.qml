import QtQuick 2.12
import QtQuick.Controls 2.5

Drawer {
    id: drawer

    Column {
        anchors.fill: parent

        ItemDelegate {
            text: qsTr("Cellframe Dashboard")
            icon.source: "qrc:/mobile/Icons/MenuIconLight.png"
            width: parent.width
        }

        ItemDelegate {
            text: qsTr("Wallet")
            icon.source: "qrc:/mobile/Icons/IconWallet.png"
            width: parent.width
            onClicked: {
                mainStackView.setInitialItem("qrc:/mobile/Wallet/MainWallet.qml")
                drawer.close()
            }
        }

        ItemDelegate {
            text: qsTr("Exchange")
            icon.source: "qrc:/mobile/Icons/IconExchange.png"
            width: parent.width
            onClicked: {
                mainStackView.setInitialItem("qrc:/mobile/Page1Form.ui.qml")
                drawer.close()
            }
        }

        ItemDelegate {
            text: qsTr("History")
            icon.source: "qrc:/mobile/Icons/IconHistory.png"
            width: parent.width
            onClicked: {
                mainStackView.setInitialItem("qrc:/mobile/PageComingSoon.qml")
                drawer.close()
            }
        }

        ItemDelegate {
            text: qsTr("Certificates")
            icon.source: "qrc:/mobile/Icons/IconCertificates.png"
            width: parent.width
            onClicked: {
                mainStackView.setInitialItem("qrc:/mobile/Page2Form.ui.qml")
                drawer.close()
            }
        }

    }
}
