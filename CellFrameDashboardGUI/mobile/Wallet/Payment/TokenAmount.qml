import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Amount")
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
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            color: "#79FFFA"

            text: qsTr("Keep these words in a safe place. They will be required to restore your wallet in case of loss of access to it.")
            wrapMode: Text.WordWrap
        }

        TextField {
            id: nameWallet
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            width: parent.width

            placeholderText: qsTr("0.0")
            color: "#ffffff"
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18

            background: Rectangle{color:"transparent"}
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

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
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

                textButton: qsTr("Next")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    mainStackView.push("qrc:/mobile/Wallet/Payment/TokenAddress.qml")
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
