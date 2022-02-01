import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
//    width: 600
//    height: 400

    title: qsTr("Wallet")

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        Image {
            Layout.alignment: Qt.AlignHCenter

            source: "qrc:/mobile/Icons/Wallet.png"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("You don’t have any wallets. Create a new wallet or import an existing one.")
            wrapMode: Text.WordWrap
        }

//        Button {
//            Layout.alignment: Qt.AlignHCenter

//            text: qsTr("Get started")
//            onClicked:
//            {
//                print("Button click")
//                mainStackView.push("qrc:/Wallet/WalletName.qml")
//            }
//        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Create a new wallet")
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Import an existing wallet")
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
