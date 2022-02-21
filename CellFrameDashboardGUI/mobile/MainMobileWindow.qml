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
    width: 400
    height: 600

    property alias dapMainWindow: window

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
        id: walletModel
    }

    ListModel {
        id: networkModel
    }

    ListModel {
        id: tokenModel
    }

    ListModel {
        id: historyModel
    }

    property alias mainWalletModel: walletModel

    property alias mainNetworkModel: networkModel

    property alias mainTokenModel: tokenModel

    property alias mainHistoryModel: historyModel

    property string newWalletName: ""

    property real sendAmount: 123.456
    property string sendAddress: ""
    property string sendToken: ""

    Component.onCompleted:
    {
        initWalletModel()

        updateNetworkModel()

        updateTokenModel()

        initHistoryModel()

        nameWallet.text = walletModel.get(currentWallet).name

        stackView.setInitialItem("qrc:/mobile/Wallet/TokenWallet.qml")
//        stackView.setInitialItem("qrc:/mobile/History/History.qml")
    }

    property alias mainStackView: stackView

    property alias walletNameLabel: nameWallet

    title: qsTr("Cellframe Dashboard")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    header: ToolBar {
        id:headerWindow
        height: 73
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
                    radius: 30
                }
                DropShadow {
                    anchors.fill: headerRect
                    radius: 5.0
                    samples: 10
                    cached: true
                    horizontalOffset: 1
                    verticalOffset: 1
                    color: "#6B667E"
                    source: headerRect
                    visible: parent.visible
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
                Layout.topMargin: 9 * pt
                Layout.bottomMargin: 15 * pt

                Layout.preferredHeight: 30 * pt
                Layout.preferredWidth: 30 * pt
                id: toolButton
                normalImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
                hoverImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
//                height: 40 * pt
//                width: 40 * pt
                widthImageButton: 30 * pt
                heightImageButton: 30 * pt
                indentImageLeftButton: 0 * pt
                transColor: true

                onClicked: {
                    if (stackView.depth > 1) {
//                        stackView.pop()
                        stackView.clearAll()
                        walletNameLabel.visible = true
                    } else {
                        mainDrawer.open()
                    }
                }
            }

            ColumnLayout
            {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 12 * pt
//                Layout.t: 10 * pt

                Layout.fillWidth: true
                spacing: 9

                Label {
                    Layout.fillWidth: true
                    text: stackView.currentItem.title
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                    horizontalAlignment: Text.AlignHCenter
                    color: currTheme.textColor
                }

                Label {
                    id:nameWallet
                    visible: true
//                    Layout.alignment: Qt.AlignBottom
                    Layout.fillWidth: true
//                    Layout.bottomMargin: 7 * pt
                    text: walletModel.get(currentWallet).name
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    horizontalAlignment: Text.AlignHCenter
                    color: currTheme.textColor
                }
            }

            DapButton
            {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 9 * pt
                Layout.bottomMargin: 15 * pt

                Layout.preferredHeight: 30 * pt
                Layout.preferredWidth: 30 * pt
                id: toolButton1
                normalImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
                hoverImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
//                height: 40 * pt
//                width: 40 * pt
                widthImageButton: 30 * pt
                heightImageButton: 30 * pt
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
    }

    function initWalletModel()
    {
        walletModel.append(
                    { "name" : "DapWallet",
                      "networks" : [] })

        // NETWORKS
        walletModel.get(0).networks.append(
                    { "name" : "CORE-T",
                      "address" : "RpiDC8c1T1Phj39nZxX36V9bzq1XtZYVsGW6FwfsF3zxdGWdaBgRLRUr53pWDYxGWpBS9E1zza1wfNAJVkaSEsXvqS6C7fvgB8SutDyz",
                      "net_address" : "N2CA::00FQ::KJB4::875G",
                      "curr_state" : "ONLINE",
                      "target_state" : "ONLINE",
                      "active_links" : 2,
                      "tokens" : []})
        walletModel.get(0).networks.append(
                    { "name" : "KELVIN-TESTNET",
                      "address" : "RvHrfKqLPYy2uCKx1YtaiYvu62qBAPuPEaA32noX6pMnpwxovghxKiHjToD2PvovVsQCu9sQWX6d5HmpXrxSv46Pmbdvc1v7huo8Q5yM",
                      "net_address" : "875G::N2CA::KJB4::875G",
                      "curr_state" : "ONLINE",
                      "target_state" : "ONLINE",
                      "active_links" : 2,
                      "tokens" : []})
        walletModel.get(0).networks.append(
                    { "name" : "PRIVATE",
                      "address" : "RpiDC8c1T1Phj39nYaFWBGDxHaPPWb1TR7qEFK5eQPFfjahknJuP9bd5B5a88JaRSaCBy6M2nv6fV1bbCai1Pt6hPhmaq1j9sPDc5mHr",
                      "net_address" : "KJB4::875G::N2CA::00FQ",
                      "curr_state" : "ERROR",
                      "target_state" : "ERROR",
                      "active_links" : 0,
                      "tokens" : []})
        walletModel.get(0).networks.append(
                    { "name" : "SUBZERO",
                      "address" : "RvHrfKqLPYy2uCKwzAd3oL1FNnD2nRNLnRVB2ADJG9cVwG9w8ovv8tRxZpxeNZFZjsj5U2WZfdtygEnqfuzhqBUjo2XzeU6oeLu6B2TP",
                      "net_address" : "1128::00FQ::N2CA::N2CA",
                      "curr_state" : "DISCONNECTING",
                      "target_state" : "OFFLINE",
                      "active_links" : 1,
                      "tokens" : []})

        // TOKENS 0
        walletModel.get(0).networks.get(0).tokens.append(
                    { "name" : "CELL-core",
                      "balance" : 1963.521002})
        walletModel.get(0).networks.get(0).tokens.append(
                    { "name" : "TOKENL-core",
                      "balance" : 382.02803})

        // TOKENS 1
        walletModel.get(0).networks.get(1).tokens.append(
                    { "name" : "CELL-kelvin",
                      "balance" : 39058.00045})
        walletModel.get(0).networks.get(1).tokens.append(
                    { "name" : "KEL-kelvin",
                      "balance" : 509014.000561})
        walletModel.get(0).networks.get(1).tokens.append(
                    { "name" : "TOKEN-kelvin",
                      "balance" : 566.3839})

        // TOKENS 2
        walletModel.get(0).networks.get(2).tokens.append(
                    { "name" : "TEST",
                      "balance" : 4472.9391})


        // TOKENS 3
        walletModel.get(0).networks.get(3).tokens.append(
                    { "name" : "CELL-subzero",
                      "balance" : 9037.17033})
        walletModel.get(0).networks.get(3).tokens.append(
                    { "name" : "KEL-subzero",
                      "balance" : 24905.7384})

    }

    function updateNetworkModel()
    {
        networkModel.clear()

        var tempModel = mainWalletModel.get(currentWallet).networks

        for (var i = 0; i < tempModel.count; ++i)
        {
            networkModel.append({"name" : tempModel.get(i).name,
                                "address" : tempModel.get(i).address,
                                "net_address" : tempModel.get(i).net_address,
                                "curr_state" : tempModel.get(i).curr_state,
                                "target_state" : tempModel.get(i).target_state,
                                "active_links" : tempModel.get(i).active_links})
        }
    }

    function updateTokenModel()
    {
        tokenModel.clear()

        var tempModel = mainWalletModel.get(currentWallet).networks.get(currentNetwork).tokens

        for (var i = 0; i < tempModel.count; ++i)
        {
            tokenModel.append({"name" : tempModel.get(i).name,
                               "balance" : tempModel.get(i).balance})
        }
    }

    function updateBalance()
    {
        var balance = mainWalletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).balance - sendAmount

        mainWalletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).balance = balance;

        for (var i = 0; i < mainWalletModel.count; ++i)
        {
            for (var j = 0; j < mainWalletModel.get(i).networks.count; ++j)
            {
                if (sendAddress === mainWalletModel.get(i).networks.get(j).address)
                {
                    print("sendAddress", sendAddress)

                    var tempModel = mainWalletModel.get(i).networks.get(j).tokens

                    for (var k = 0; k < tempModel.count; ++k)
                    {
                        if (tempModel.get(k).name === sendToken)
                        {
                            print("sendToken", sendToken)

                            print(sendToken, tempModel.get(k).name)
                            tempModel.get(k).balance += sendAmount
                        }
                    }
                }
            }
        }

        updateTokenModel()
    }

    function createWallet(name)
    {
        walletModel.append(
                    { "name" : name,
                      "networks" : [] })

        walletModel.get(walletModel.count-1).networks.append(
                    { "name" : "CORE-T",
                      "address" : "RpiDC8c1SxrTF3aStz2MaMxqb1JKP26oSFx3tycvLWZ1BQxYyF7G2ASNewNJvzobmi3qfbhpQDVq8HxyNGax8DYediXUxtrZ3GgsJyEa",
                      "net_address" : "N2CA::00FQ::KJB4::875G",
                      "curr_state" : "ONLINE",
                      "target_state" : "ONLINE",
                      "active_links" : 2,
                      "tokens" : []})
        walletModel.get(walletModel.count-1).networks.append(
                    { "name" : "KELVIN-TESTNET",
                      "address" : "RvHrfKqLPYy2uCKwzAd3oL1FNnD2nRNLnRVB2ADJG9cVwG9w8ovv8tRxZpxeNZFZjsj5U2WZfdtygEnqfuzhqBUjo2XzeU6oeLu6B2TP",
                      "net_address" : "875G::N2CA::KJB4::875G",
                      "curr_state" : "ONLINE",
                      "target_state" : "ONLINE",
                      "active_links" : 2,
                      "tokens" : []})
        walletModel.get(walletModel.count-1).networks.append(
                    { "name" : "PRIVATE",
                      "address" : "rTDbDdeStfpodpLUcfpwxuto4VVuqySxypZQAP3jFLPfKZHC94kR3ZqsVZWL1Qo8sZnT65746a18ijq2ZZr2SjrBszdot72kNH4YSnKN",
                      "net_address" : "KJB4::875G::N2CA::00FQ",
                      "curr_state" : "ERROR",
                      "target_state" : "ERROR",
                      "active_links" : 0,
                      "tokens" : []})
        walletModel.get(walletModel.count-1).networks.append(
                    { "name" : "SUBZERO",
                      "address" : "rTDbDdeStfpodpLUe46Ut8pSmk84Dwz1RyEGB1dx618xDF64vwXTEPhePXkiHgrkzvKQRdu2FJJE2fXBYtDDFPqGHgNQUzWZr5yd9YGQ",
                      "net_address" : "1128::00FQ::N2CA::N2CA",
                      "curr_state" : "DISCONNECTING",
                      "target_state" : "ONLINE",
                      "active_links" : 1,
                      "tokens" : []})
        // TOKENS 0
        walletModel.get(walletModel.count-1).networks.get(0).tokens.append(
                    { "name" : "CELL-core",
                        "balance" : 0.0})
        walletModel.get(walletModel.count-1).networks.get(0).tokens.append(
                    { "name" : "TOKENL-core",
                        "balance" : 0.0})

        // TOKENS 1
        walletModel.get(walletModel.count-1).networks.get(1).tokens.append(
                    { "name" : "CELL-kelvin",
                        "balance" : 0.0})
        walletModel.get(walletModel.count-1).networks.get(1).tokens.append(
                    { "name" : "KEL-kelvin",
                        "balance" : 0.0})
        walletModel.get(walletModel.count-1).networks.get(1).tokens.append(
                    { "name" : "TOKEN-kelvin",
                        "balance" : 0.0})

        // TOKENS 2
        walletModel.get(walletModel.count-1).networks.get(2).tokens.append(
                    { "name" : "TEST",
                        "balance" : 0.0})


        // TOKENS 3
        walletModel.get(walletModel.count-1).networks.get(3).tokens.append(
                    { "name" : "CELL-subzero",
                        "balance" : 0.0})
        walletModel.get(walletModel.count-1).networks.get(3).tokens.append(
                    { "name" : "KEL-subzero",
                        "balance" : 0.0})


    }

    function initHistoryModel()
    {
        historyModel.append(
                    { "Date" : "2021-12-09",
                      "Network" : "CORE-T",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.0777",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1639013540
                    })
        historyModel.append(
                    { "Date" : "2021-12-09",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "0.00000321",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1639013790
                    })
        historyModel.append(
                    { "Date" : "2021-12-11",
                      "Network" : "CORE-T",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "0.0004444",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1639175152
                    })
        historyModel.append(
                    { "Date" : "2021-12-11",
                      "Network" : "CORE-T",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.0000321",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1639255662
                    })
        historyModel.append(
                    { "Date" : "2021-12-11",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "0.0555",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1639255702
                    })
        historyModel.append(
                    { "Date" : "2021-12-12",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.0000333",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1639257830
                    })
        historyModel.append(
                    { "Date" : "2021-12-12",
                      "Network" : "CORE-T",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "0.000007777",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1639257867
                    })
        historyModel.append(
                    { "Date" : "2021-12-15",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.002345",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1639531495
                    })
        historyModel.append(
                    { "Date" : "2021-12-15",
                      "Network" : "CORE-T",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "0.681",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1639531611
                    })
        historyModel.append(
                    { "Date" : "2021-12-30",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640816857
                    })
        historyModel.append(
                    { "Date" : "2022-01-15",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640826857
                    })
        historyModel.append(
                    { "Date" : "2022-01-31",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640836857
                    })
        historyModel.append(
                    { "Date" : "2022-02-15",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640846857
                    })
        historyModel.append(
                    { "Date" : "2022-02-19",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640856857
                    })
        historyModel.append(
                    { "Date" : "2022-02-20",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640866857
                    })
        historyModel.append(
                    { "Date" : "2022-02-21",
                      "Network" : "KELVIN-TESTNET",
                      "Status" : "Received",
                      "AmountWithoutZeros" : "123456.23456",
                      "Name" : "KEL-kelvin",
                      "SecsSinceEpoch" : 1640876857
                    })
        historyModel.append(
                    { "Date" : "2022-02-21",
                      "Network" : "CORE-T",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.0000321",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1640886857
                    })
        historyModel.append(
                    { "Date" : "2022-02-21",
                      "Network" : "CORE-T",
                      "Status" : "Sent",
                      "AmountWithoutZeros" : "0.0000321",
                      "Name" : "CELL-core",
                      "SecsSinceEpoch" : 1640896857
                    })

    }

    /*function initHistoryModel()
    {
        hisoryModel.append(
                    { "date" : "July, 22",
                      "network" : "CORE-T",
                      "status" : "Received",
                      "amount" : "+1234.567",
                      "token_name" : "CELL-core"})
        hisoryModel.append(
                    { "date" : "July, 22",
                      "network" : "KELVIN-TESTNET",
                      "status" : "Sent",
                      "amount" : "-123.56",
                      "token_name" : "KEL-kelvin"})
        hisoryModel.append(
                    { "date" : "July, 22",
                      "network" : "CORE-T",
                      "status" : "Error",
                      "amount" : "-34.4234",
                      "token_name" : "CELL-core"})
        hisoryModel.append(
                    { "date" : "July, 21",
                      "network" : "CORE-T",
                      "status" : "Received",
                      "amount" : "+1234.567",
                      "token_name" : "CELL-core"})
        hisoryModel.append(
                    { "date" : "July, 21",
                      "network" : "KELVIN-TESTNET",
                      "status" : "Sent",
                      "amount" : "-123.56",
                      "token_name" : "KEL-kelvin"})
        hisoryModel.append(
                    { "date" : "July, 20",
                      "network" : "CORE-T",
                      "status" : "Error",
                      "amount" : "-34.4234",
                      "token_name" : "CELL-core"})
        hisoryModel.append(
                    { "date" : "July, 20",
                      "network" : "KELVIN-TESTNET",
                      "status" : "Received",
                      "amount" : "+1234.567",
                      "token_name" : "KEL-kelvin"})
        hisoryModel.append(
                    { "date" : "July, 20",
                      "network" : "CORE-T",
                      "status" : "Received",
                      "amount" : "+1234.567",
                      "token_name" : "CELL-core"})
        hisoryModel.append(
                    { "date" : "July, 19",
                      "network" : "KELVIN-TESTNET",
                      "status" : "Sent",
                      "amount" : "-123.56",
                      "token_name" : "KEL-kelvin"})
        hisoryModel.append(
                    { "date" : "July, 18",
                      "network" : "CORE-T",
                      "status" : "Error",
                      "amount" : "-34.4234",
                      "token_name" : "CELL-core"})
    }*/

}
