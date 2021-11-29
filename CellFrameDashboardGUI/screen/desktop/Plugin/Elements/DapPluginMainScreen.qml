import QtQuick 2.4
import QtQuick.Layouts 1.3
import "Windows"

Rectangle {

    property string showWallets : "qrc:/screen/desktop/Plugin/Elements/Windows/Wallets/DapShowWallets.qml"
    property string createWallet : "qrc:/screen/desktop/Plugin/Elements/Windows/Wallets/DapCreateWallet.qml"
    property string showOrders : "qrc:/screen/desktop/Plugin/Elements/Windows/Orders/DapOrdersFrame.qml"
    property string showCertificates : "qrc:/screen/desktop/Plugin/Elements/Windows/Certificates/DapShowCertificates.qml"
    property string createCertificates : "qrc:/screen/desktop/Plugin/Elements/Windows/Certificates/DapCreateCertificate.qml"

    anchors.fill: parent
    anchors.margins: 30

    color: "#363A42"
    radius: 16 * pt

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 50

        rows:5
        columns:1

        rowSpacing: 20

        DapPluginsBlock
        {
            Layout.row: 1
            Layout.rowSpan:1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true

            leftButton.textButton: "Get Wallets"
            rightButton.textButton: "Create Wallet"

            leftButton.onClicked: {
                loader.source = showWallets
                loader.open()
            }
            rightButton.onClicked:
            {
                loader.source = createWallet
                loader.open()
            }
        }
        DapPluginsBlock
        {
            Layout.row: 2
            Layout.rowSpan:1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: "Get Certificates"
            rightButton.textButton: "Create Certificate"

            leftButton.onClicked: {
                loader.source = showCertificates
                loader.open()
            }
            rightButton.onClicked:
            {
                loader.source = createCertificates
                loader.open()
            }
        }
        DapPluginsBlock
        {
            Layout.row: 3
            Layout.rowSpan:1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: "Open Orders"
            rightButton.visible: false

            leftButton.onClicked: {
                loader.source = showOrders
                loader.open()
            }

        }
        DapPluginsBlock
        {
            Layout.row: 4
            Layout.rowSpan:1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: "Open Last Actions"
            rightButton.visible: false
        }
        DapPluginsBlock
        {
            Layout.row: 5
            Layout.rowSpan:1
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: "Open Console"
            rightButton.visible: false
        }
    }

    DapWindowLoader
    {
        id:loader
    }
}
