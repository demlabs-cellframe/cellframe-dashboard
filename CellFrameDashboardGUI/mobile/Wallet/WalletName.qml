import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Create wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 16

        Item {
            Layout.fillHeight: true
        }

        TextField {
            id: nameWallet
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            width: parent.width

            placeholderText: qsTr("Enter a new wallet name")
            color: "#ffffff"
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18

            background: Rectangle{color:"transparent"}
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#6B6979"
        }

        CustomRadioButton {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Use on existing wallet")
        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 14 * pt

            implicitWidth: 132 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Next")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                window.createWallet(nameWallet.text);
                mainStackView.push("qrc:/mobile/Wallet/WalletSignature.qml")
            }

        }

        Item {
            Layout.fillHeight: true
        }

    }
}
