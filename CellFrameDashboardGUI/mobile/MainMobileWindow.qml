import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../resources/theme"
import "qrc:/widgets/"
import "qrc:/resources/QML"

ApplicationWindow {
    id: window
    visible: true
    width: 320
    height: 480

    property alias dapQuicksandFonts: quicksandFonts
    DapFontQuicksand {
        id: quicksandFonts
    }
    Dark { id: darkTheme }
    Light { id: lightTheme }

    property string pathTheme: "BlackTheme"

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme


    property int currentWallet: 0
    property int currentNetwork: 0
    property int currentToken: 0

    ListModel {
        id: walletsModel
    }

    ListModel {
        id: networksModel
    }


    property alias mainWalletsModel: walletsModel

    property alias mainNetworkModel: networksModel

    Component.onCompleted:
    {
        initModel()

        updateNetworksModel()
    }

    property alias mainStackView: stackView

    title: qsTr("Cellframe Dashboard")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    header: ToolBar {
//        contentHeight: 56 * pt

        background:
            Item {
                anchors.fill: parent
                Rectangle {
                    id: headerRect
                    Rectangle {
                        width: parent.width
                        height: 30
                        anchors.top: parent.top
                        color: "#282A33"
                    }
                    anchors.fill: parent
                    color: "#282A33"
                    radius: 20
                }
                InnerShadow {
                    anchors.fill: headerRect
                    radius: 3.0
                    samples: 10
                    cached: true
                    horizontalOffset: 0
                    verticalOffset: -1
                    color: "#858585"
                    source: headerRect
                }
        }



        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt

            DapButton
            {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10 * pt
                Layout.bottomMargin: 15 * pt

                Layout.preferredHeight: 24 * pt
                Layout.preferredWidth: 24 * pt
                id: toolButton
                normalImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
                hoverImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
//                height: 40 * pt
//                width: 40 * pt
                widthImageButton: 24 * pt
                heightImageButton: 24 * pt
                indentImageLeftButton: 0 * pt
                transColor: true

                onClicked: {
                    if (stackView.depth > 1) {
//                        stackView.pop()
                        stackView.clearAll()
                    } else {
                        mainDrawer.open()
                    }
                }
            }

            ColumnLayout
            {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10 * pt
                Layout.bottomMargin: 5 * pt
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    text: stackView.currentItem.title
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                    horizontalAlignment: Text.AlignHCenter
                    color: currTheme.textColor
                }

                Label {
                    visible: true
                    Layout.fillWidth: true
                    text: "MyWallet"
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    horizontalAlignment: Text.AlignHCenter
                    color: currTheme.textColor
                }
            }

            DapButton
            {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10 * pt
                Layout.bottomMargin: 15 * pt

                Layout.preferredHeight: 24 * pt
                Layout.preferredWidth: 24 * pt
                id: toolButton1
                normalImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
                hoverImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
//                height: 40 * pt
//                width: 40 * pt
                widthImageButton: 24 * pt
                heightImageButton: 24 * pt
                indentImageLeftButton: 0 * pt
                transColor: true
                enabled: stackView.depth <= 1
                onClicked: {
                    networkDrawer.open()
                }
            }
        }

    }

    MainMenu
    {
        id: mainDrawer
        width: parent.width * 0.66
        height: parent.height
    }

    NetworkMenu
    {
        id: networkDrawer
        width: parent.width * 0.66
        height: parent.height
    }

    MainStackView {
        id: stackView
        anchors.fill: parent
//        initialItem: "qrc:/mobile/Wallet/MainWallet.qml"
        initialItem: "qrc:/mobile/Wallet/TokenWallet.qml"
    }

    function initModel()
    {
        walletsModel.append(
                    { "name" : "MyWallet",
                      "networks" : [] })

        // NETWORKS
        walletsModel.get(0).networks.append(
                    { "name" : "CORE-T",
                      "address" : "RpiDC8c1T1Phj39nZxX36V9bzq1XtZYVsGW6FwfsF3zxdGWdaBgRLRUr53pWDYxGWpBS9E1zza1wfNAJVkaSEsXvqS6C7fvgB8SutDyz",
                      "state" : "ONLINE",
                      "target state" : "ONLINE",
                      "active links" : 1,
                      "tokens" : []})
        walletsModel.get(0).networks.append(
                    { "name" : "KELVIN-TESTNET",
                      "address" : "RvHrfKqLPYy2uCKx1YtaiYvu62qBAPuPEaA32noX6pMnpwxovghxKiHjToD2PvovVsQCu9sQWX6d5HmpXrxSv46Pmbdvc1v7huo8Q5yM",
                      "state" : "ONLINE",
                      "target state" : "ONLINE",
                      "active links" : 1,
                      "tokens" : []})
        walletsModel.get(0).networks.append(
                    { "name" : "PRIVATE",
                      "address" : "RpiDC8c1T1Phj39nYaFWBGDxHaPPWb1TR7qEFK5eQPFfjahknJuP9bd5B5a88JaRSaCBy6M2nv6fV1bbCai1Pt6hPhmaq1j9sPDc5mHr",
                      "state" : "ONLINE",
                      "target state" : "ONLINE",
                      "active links" : 1,
                      "tokens" : []})
        walletsModel.get(0).networks.append(
                    { "name" : "SUBZERO",
                      "address" : "RvHrfKqLPYy2uCKwzAd3oL1FNnD2nRNLnRVB2ADJG9cVwG9w8ovv8tRxZpxeNZFZjsj5U2WZfdtygEnqfuzhqBUjo2XzeU6oeLu6B2TP",
                      "state" : "ONLINE",
                      "target state" : "ONLINE",
                      "active links" : 1,
                      "tokens" : []})

        // TOKENS 0
        walletsModel.get(0).networks.get(0).tokens.append(
                    { "name" : "CELL",
                      "balance" : 1963.521002,
                      "balance text" : "1963.521002"})
        walletsModel.get(0).networks.get(0).tokens.append(
                    { "name" : "KEL",
                      "balance" : 70340.239,
                      "balance text" : "70340.239"})
        walletsModel.get(0).networks.get(0).tokens.append(
                    { "name" : "TOKEN",
                      "balance" : 23.9847,
                      "balance text" : "23.9847"})

        // TOKENS 1
        walletsModel.get(0).networks.get(1).tokens.append(
                    { "name" : "CELL",
                      "balance" : 1963.521002,
                      "balance text" : "1963.521002"})
        walletsModel.get(0).networks.get(1).tokens.append(
                    { "name" : "KEL",
                      "balance" : 70340.239,
                      "balance text" : "70340.239"})
        walletsModel.get(0).networks.get(1).tokens.append(
                    { "name" : "TOKEN",
                      "balance" : 23.9847,
                      "balance text" : "23.9847"})

        // TOKENS 2
        walletsModel.get(0).networks.get(2).tokens.append(
                    { "name" : "CELL",
                      "balance" : 1963.521002,
                      "balance text" : "1963.521002"})
        walletsModel.get(0).networks.get(2).tokens.append(
                    { "name" : "KEL",
                      "balance" : 70340.239,
                      "balance text" : "70340.239"})
        walletsModel.get(0).networks.get(2).tokens.append(
                    { "name" : "TOKEN",
                      "balance" : 23.9847,
                      "balance text" : "23.9847"})

        // TOKENS 3
        walletsModel.get(0).networks.get(3).tokens.append(
                    { "name" : "CELL",
                      "balance" : 1963.521002,
                      "balance text" : "1963.521002"})
        walletsModel.get(0).networks.get(3).tokens.append(
                    { "name" : "KEL",
                      "balance" : 70340.239,
                      "balance text" : "70340.239"})
        walletsModel.get(0).networks.get(3).tokens.append(
                    { "name" : "TOKEN",
                      "balance" : 23.9847,
                      "balance text" : "23.9847"})

    }

    function updateNetworksModel()
    {
        networksModel.clear()

        var tempModel = mainWalletsModel.get(currentWallet).networks

        for (var i = 0; i < tempModel.count; ++i)
        {
            networksModel.append({"name" : tempModel.get(i).name})
        }
    }

}
