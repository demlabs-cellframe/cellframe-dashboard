import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    title: qsTr("Choose signature type")

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                checked: true
                text: qsTr("Crystal-Dylithium")
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "grey"
            }

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Picnic")
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "grey"
            }

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Bliss")
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "grey"
            }

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Tesla")
            }
        }

        RowLayout
        {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: qsTr("Back")
                onClicked:
                {
                    mainStackView.pop()
                }
            }

            Button {
                Layout.fillWidth: true
                text: qsTr("Next")
                onClicked:
                {
                    mainStackView.push("qrc:/mobile/Wallet/WalletRecovery.qml")
                }
            }
        }


        Item {
            Layout.fillHeight: true
        }

    }
}
