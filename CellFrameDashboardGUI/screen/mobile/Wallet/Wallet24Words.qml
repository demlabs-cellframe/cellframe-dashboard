import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("24 words")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    QMLClipboard{
        id: clipboard
    }

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
            font: mainFont.dapFont.regular14
            color: "#79FFFA"

            text: qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
            wrapMode: Text.WordWrap
        }

        Text {
            id: words24
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.regular16
            color: "#ffffff"

            text: qsTr("afiaso amalou baltap barari brabec cajari csirka davrey dosimo gbadoa hallen hovden kokele kumisu le fas liloka llorac loholz lukeka maugbi neiafu nemano rebone utiago")
            wrapMode: Text.WordWrap
        }

        Text {
            id: copiedText
            visible: false
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.regular14
            color: "#B3FF00"
            text: qsTr("Recovery words copied to clipboard. Keep them in a safe place before proceeding to the next step.")
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 17 

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 
                implicitHeight: 36 
                radius: currTheme.radiusButton

                textButton: qsTr("Copy")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    next.enabled = true
                    copiedText.visible = true

                    clipboard.setText(words24.text)
                }

            }

            DapButton
            {
                id: next
                Layout.fillWidth: true

                implicitWidth: 132 
                implicitHeight: 36 
                radius: currTheme.radiusButton
                enabled: false

                textButton: qsTr("Next")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
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
