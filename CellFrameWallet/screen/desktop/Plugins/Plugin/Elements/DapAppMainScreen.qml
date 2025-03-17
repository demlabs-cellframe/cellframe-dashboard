import QtQuick 2.4
import QtQuick.Layouts 1.3
import "Windows"

Rectangle {

    property string showWallets        : "./Windows/Wallets/DapShowWallets.qml"
    property string createWallet       : "./Windows/Wallets/DapCreateWallet.qml"
    property string showOrders         : "./Windows/Orders/DapOrdersFrame.qml"
    property string showCertificates   : "./Windows/Certificates/DapShowCertificates.qml"
    property string createCertificates : "./Windows/Certificates/DapCreateCertificate.qml"
    property string showLastActions    : "./Windows/LastActions/DapShowLastActions.qml"
    property string showConsole        : "./Windows/Console/DapShowConsole.qml"

    anchors.fill: parent
    anchors.margins: 30

    color: "#363A42"
    radius: 16 

    GridLayout
    {
        anchors.fill: parent
        anchors.margins: 50

        rows:5
        columns:1

        rowSpacing: 20


        DapAppRow
        {
            Layout.row: 1
            Layout.rowSpan:1
            Layout.fillHeight: true
            Layout.fillWidth: true

            leftButton.textButton: qsTr("Get Wallets")
            rightButton.textButton: qsTr("Create Wallet")

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
        DapAppRow
        {
            Layout.row: 2
            Layout.rowSpan:1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: qsTr("Get Certificates")
            rightButton.textButton: qsTr("Create Certificate")

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
        DapAppRow
        {
            Layout.row: 3
            Layout.rowSpan:1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: qsTr("Open Orders")
            rightButton.visible: false

            leftButton.onClicked: {
                loader.source = showOrders
                loader.open()
            }

        }
        DapAppRow
        {
            Layout.row: 4
            Layout.rowSpan:1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: qsTr("Open Last Actions")
            rightButton.visible: false

            leftButton.onClicked: {
                loader.source = showLastActions
                loader.open()
            }
        }
        DapAppRow
        {
            Layout.row: 5
            Layout.rowSpan:1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftButton.textButton: qsTr("Open Console")
            rightButton.visible: false

            leftButton.onClicked: {
                loader.source = showConsole
                loader.open()
            }
        }
    }

    DapWindowLoader
    {
        id:loader
    }
}
