import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    title: qsTr("24 words")

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
            wrapMode: Text.WordWrap
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("afiaso amalou baltap barari brabec cajari csirka davrey dosimo gbadoa hallen hovden kokele kumisu le fas liloka llorac loholz lukeka maugbi neiafu nemano rebone utiago")
            wrapMode: Text.WordWrap
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: qsTr("Copy")
                onClicked:
                {
                    next.enabled = true
                }
            }

            Button {
                id: next
                Layout.fillWidth: true
                text: qsTr("Next")
                enabled: false
                onClicked:
                {
                    mainStackView.push("qrc:/mobile/Wallet/WalletSuccessfully.qml")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
