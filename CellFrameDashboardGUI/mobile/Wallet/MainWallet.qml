import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
//    width: 600
//    height: 400

    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

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
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            color: currTheme.textColorGrayTwo
            wrapMode: Text.WordWrap
        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 165 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Get started")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }

        }

//        DapButton
//        {
//            Layout.alignment: Qt.AlignHCenter

//            implicitWidth: 165 * pt
//            implicitHeight: 36 * pt
//            radius: currTheme.radiusButton

//            textButton: qsTr("Import an existing wallet")

//            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
//            horizontalAligmentText:Qt.AlignCenter
//            colorTextButton: "#FFFFFF"
//            onClicked:
//            {
//                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
//            }

//        }

        Item {
            Layout.fillHeight: true
        }

    }
}
