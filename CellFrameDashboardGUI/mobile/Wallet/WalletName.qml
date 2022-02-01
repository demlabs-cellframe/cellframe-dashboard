import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    title: qsTr("Create wallet")

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        TextField {
            Layout.alignment: Qt.AlignHCenter

            placeholderText: qsTr("Enter a new wallet name")
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Next")
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletSignature.qml")
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
