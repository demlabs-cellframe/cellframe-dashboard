import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ColumnLayout
{
    anchors.fill: parent
    spacing: 0

    Item{Layout.fillHeight: true}

    Image
    {
        Layout.alignment: Qt.AlignHCenter

        source: "qrc:/Resources/" + pathTheme + "/Illustratons/wallet_illustration.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Text
    {
        id:textTitle
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 24

        font: mainFont.dapFont.medium24
        color: currTheme.white
        text: logicWallet.restoreWalletMode ? qsTr("Importing wallet in process...") : qsTr("Creating wallet in process...")
    }

    Item{Layout.fillHeight: true}
}
