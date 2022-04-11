import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Transaction overview")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 50 * pt
        width: parent.width
        spacing: 10 * pt

        Item {
            Layout.fillHeight: true
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            Text {
                color: currTheme.textColor
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Network: ")
            }

            Text {

                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: qsTr(walletModel.get(currentWallet).networks.get(currentNetwork).name)
            }
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            Text {
                color: currTheme.textColor
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Amount: ")
            }

            Text {

                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: qsTr( sendAmount + " " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
            }
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            Text {
                Layout.alignment: Qt.AlignTop
                color: currTheme.textColor
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("To: ")
            }

            Text {
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap

                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: sendAddress

            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 17 * pt

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Back")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {

                    mainStackView.pop()
                }

            }

            DapButton
            {
                id: next
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton
                enabled: true

                textButton: qsTr("Next")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    mainStackView.push("TransactionSuccessfully.qml")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
