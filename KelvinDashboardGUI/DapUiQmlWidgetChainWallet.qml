import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: dapUiQmlWidgetChainWallet
    property string token: ""
    property double amount: 0.0
    property var    activeWalletModel
    property var    activeWalletIndex

    title: qsTr("Wallet")

    property var walletModels: [
    walletModel1, walletModel2, walletModel3
    ]
    property var walletHistories: [
    walletHistory1, walletHistory2, walletHistory3
    ]

    //ListModel {
    //    id:walletContainer
    //    ListElement{
            ListModel {
                id: walletModel1
                ListElement {
                    name:  qsTr("KLVNT")
                    amount: "1234"
                }
                ListElement {
                    name:  qsTr("KLVNT1")
                    amount: "100.5"
                }
                ListElement {
                    name:  qsTr("KLVNT2")
                    amount: "200.5"
                }
                ListElement {
                    name:  qsTr("KLVNT3")
                    amount: "100"
                }
                ListElement {
                    name:  qsTr("KLVNT4")
                    amount: "200"
                }
                ListElement {
                    name:  qsTr("KLVNT5")
                    amount: "300"
                }
            }
            ListModel {
                id: walletHistory1
                ListElement {
                    date:  qsTr("25 Mar")
                    amount: "50"
                    isAdd: true
                    from: "fdJfjsdfg7347Fhdfsjhf47"
                }
                ListElement {
                    date:  qsTr("1 Feb")
                    amount: "30"
                    isAdd: false
                    from: "fdJfjsdfg7347Fhdfsjhf47"
                }
                ListElement {
                    date:  qsTr("30 Jan")
                    amount: "100"
                    isAdd: true
                    from: "fdJfjsdfg7347Fhdfsjhf47"
                }
                ListElement {
                    date:  qsTr("14 Jan")
                    amount: "3"
                    isAdd: false
                    from: "fdJfjsdfg7347Fhdfsjhf47"
                }
                ListElement {
                    date:  qsTr("3 Jan")
                    amount: "10"
                    isAdd: true
                    from: "fdJfjsdfg7347Fhdfsjhf47"
                }
            }
        //}
        //ListElement{
             ListModel {
                id: walletModel2
                ListElement {
                    name:  qsTr("KLVNT")
                    amount: "1000"
                }
                ListElement {
                    name:  qsTr("KLVNT15")
                    amount: "250.3"
                }
             }
             ListModel {
                 id: walletHistory2
                 ListElement {
                     date:  qsTr("14 Mar")
                     amount: "500"
                     isAdd: true
                     from: "daffgFDfg7347Fhdfsjhf47"
                 }
             }
        //}
        //ListElement{
            ListModel {
                id: walletModel3
                ListElement {
                    name:  qsTr("KLVNT")
                    amount: "50"
                }
                ListElement {
                    name:  qsTr("KLVNT1")
                    amount: "13.5"
                }
                ListElement {
                    name:  qsTr("KLVNT2")
                    amount: "0.1"
                }
                ListElement {
                    name:  qsTr("KLVNT3")
                    amount: "16.5"
                }
                ListElement {
                    name:  qsTr("KLVNT4")
                    amount: "120"
                }
            }

            ListModel {
                id: walletHistory3
                ListElement {
                    date:  qsTr("25 Mar")
                    amount: "50"
                    isAdd: false
                    from: "fskdfhgkd458FjGjfgkdfg"
                }
                ListElement {
                    date:  qsTr("1 Feb")
                    amount: "50"
                    isAdd: false
                    from: "Lkgudfgj545Igjfgudfgkkgdf"
                }
                ListElement {
                    date:  qsTr("30 Jan")
                    amount: "100"
                    isAdd: true
                    from: "fskdfhgkd458FjGjfgkdfg"
                }
            }
    //    }
    //}

    ListModel {
            id: tabModel

            ListElement {
                alias:  qsTr("Default")
                address: qsTr("EUdzt7THsUTDWyohBrE5HtJJtj7qRSWbsb88n6owujTuzpYPXYGebFUjQTH7bK31UjV")
            }
            ListElement {
                alias:  qsTr("wallet 1")
                address: qsTr("gkGkdkfhHkldfLdfk3HQjsdfHK34JfdkfHGkafkgj98dgkjkkqwlekfjJfjllsdkfFj")
            }
            ListElement {
                alias:  qsTr("wallet 2")
                address: qsTr("PfsdsjqufmJfuah436FjkasduhqueymnBghdu47FhasdrynV4763jFjkjsdhfsklabj")
            }
        }

    TabBar
    {
        id: walletsBar
        width: parent.width
        anchors.top: parent.top
        Repeater {
            model: tabModel
            TabButton {
                text: model.alias
                //onClicked: tabModel.remove(model.index)
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    /////////////------------------------------------------------/////////////////
    // ---------------    settings screen -----------------//////////////

    Item{
        id: settings
        anchors.fill: parent
        visible: false

        Rectangle{
            id: centerWdg1
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: parent.height * 0.7
            radius: 10
            color: "#EEEEEE"

            Text{
                id: walletTitle1
                width: parent.width - 20
                text: {
                    if (walletsBar.currentIndex == 0)
                        return "Wallet: " + 'EUdzt7THsUTDWyohBrE5HtJJtj7qRSWbsb88n6owujTuzpYPXYGebFUjQTH7bK31UjV';
                    else if (walletsBar.currentIndex == 1)
                        return "Wallet: " + 'gkGkdkfhHkldfLdfk3HQjsdfHK34JfdkfHGkafkgj98dgkjkkqwlekfjJfjllsdkfFj';
                    else if (walletsBar.currentIndex == 2)
                        return "Wallet: " + 'PfsdsjqufmJfuah436FjkasduhqueymnBghdu47FhasdrynV4763jFjkjsdhfsklabj';
                }
                elide: Text.ElideRight
                font.pixelSize: 17

                anchors{
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                    top: centerWdg1.top
                    horizontalCenter: centerWdg1.horizontalCenter
                }
            }

            Row{
                width: parent.width
                height: 40
                anchors.topMargin: 40
                anchors.top: walletTitle1.top;
                anchors.horizontalCenter: centerWdg1.horizontalCenter
                Text{text: "Alias:"; width: parent.width / 8;
                    height: parent.height; font.pixelSize: 17; anchors.right: aliasEdit.left; anchors.rightMargin: 10;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                }
                Rectangle{
                    id: aliasEdit;
                    width: parent.width / 8 * 5
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter;
                    radius: 5
                    border.color: "Blue"
                    border.width: 1
                    color: "White"
                    TextEdit{
                        id: aliasEditText
                        text: tabModel.get(walletsBar.currentIndex).alias;
                        width: parent.width;
                        font.pixelSize: 15;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.leftMargin: 10
                        horizontalAlignment: Text.AlignHCenter
                        //anchors.right: recipientEdit.left
                    }
                }
            }

            Rectangle{
                width: parent.width - 20
                height: 70
                color: parent.color
                anchors{
                    leftMargin: 30
                    rightMargin: 30
                    topMargin: 10
                    bottomMargin: 10
                    bottom: centerWdg1.bottom
                    horizontalCenter: centerWdg1.horizontalCenter
                }
                Row{
                    width: parent.width
                    height: parent.height
                    Button {
                        width: 140
                        height: 60
                        text: "Cancel"
                        onClicked: {
                            switchToWalletSettings();
                        }
                        anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left;
                    }
                    Button {
                        width: 140
                        height: 60
                        text: "Apply"
                        onClicked: {
                            tabModel.get(walletsBar.currentIndex).alias = aliasEditText.text
                            switchToWalletSettings();
                        }
                        anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right;
                    }
                }
            }
        }
    }




//////////////////////////////////////////////////////////////////////////////
/////////////------------------------------------------------/////////////////
// ---------------    Transaction screen -----------------//////////////
    Item{
        id:transaction
        anchors.fill: parent
        visible: false

        Rectangle{
            id: centerWdg
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: parent.height * 0.7
            radius: 10
            color: "#EEEEEE"

            Text{
                id: walletTitle
                width: parent.width - 20
                text: {
                    if (walletsBar.currentIndex == 0)
                        return "Wallet: " + 'EUdzt7THsUTDWyohBrE5HtJJtj7qRSWbsb88n6owujTuzpYPXYGebFUjQTH7bK31UjV';
                    else if (walletsBar.currentIndex == 1)
                        return "Wallet: " + 'gkGkdkfhHkldfLdfk3HQjsdfHK34JfdkfHGkafkgj98dgkjkkqwlekfjJfjllsdkfFj';
                    else if (walletsBar.currentIndex == 2)
                        return "Wallet: " + 'PfsdsjqufmJfuah436FjkasduhqueymnBghdu47FhasdrynV4763jFjkjsdhfsklabj';
                }
                elide: Text.ElideRight
                font.pixelSize: 17

                anchors{
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                    top: centerWdg.top
                    horizontalCenter: centerWdg.horizontalCenter
                }
            }
            Rectangle{
                id: walletData
                width: parent.width - 20
                height: 40
                color: parent.color
                anchors{
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                    top: walletTitle.bottom
                    horizontalCenter: centerWdg.horizontalCenter
                }
                Row{
                    width: parent.width
                    height: parent.height
                    Text{text: "Token:"; width: parent.width / 4; font.pixelSize: 17; anchors.verticalCenter: parent.verticalCenter}
                    ComboBox {
                        id: tokenCmb
                        textRole: "name"
                        model: activeWalletModel
                        currentIndex: activeWalletIndex

                        anchors{
                            leftMargin: 10
                            topMargin: 10
                            bottomMargin: 10
                            top: centerWdg.top
                            verticalCenter: parent.verticalCenter
                        }
                        anchors.rightMargin: 20; width: parent.width / 4; font.pixelSize: 17;  anchors.right: transVertSep.left;

                        onCurrentIndexChanged: {
                            tokenAmountTxt.text = activeWalletModel.get(currentIndex).amount
                        }
                    }
                    //Text{anchors.rightMargin: 20; text: dapUiQmlWidgetChainWallet.token; width: parent.width / 4; font.pixelSize: 17; anchors.verticalCenter: parent.verticalCenter; anchors.right: transVertSep.left; horizontalAlignment: Text.AlignRight}
                    Rectangle{ width: 1; height: parent.height ; anchors.horizontalCenter: parent.horizontalCenter; color: "Black"; id:transVertSep}
                    Text{anchors.leftMargin: 20; text: "Balance:"; width: parent.width / 4; font.pixelSize: 17; anchors.verticalCenter: parent.verticalCenter; anchors.left: transVertSep.right}
                    Text{id: tokenAmountTxt; text: amount; width: parent.width / 4; font.pixelSize: 17; anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right; horizontalAlignment: Text.AlignRight}
                }
            }

            Rectangle{
                width: parent.width - 20
                height: 70
                color: parent.color
                anchors{
                    leftMargin: 30
                    rightMargin: 30
                    topMargin: 10
                    bottomMargin: 10
                    bottom: centerWdg.bottom
                    horizontalCenter: centerWdg.horizontalCenter
                }
                Row{
                    width: parent.width
                    height: parent.height
                    Button {
                        width: 140
                        height: 60
                        text: "Back to wallets"
                        onClicked: {
                            switchToTransaction();
                        }
                        anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left;
                    }
                    Button {
                        width: 140
                        height: 60
                        text: "Send"
                        onClicked: {
                            switchToTransaction();
                        }
                        anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right;
                    }
                }
            }
            Text{
                id: recipientLb;
                text: "Address:";
                width: parent.width / 2;
                height: 20
                font.pixelSize: 13;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.top: walletData.bottom;
                anchors.leftMargin: 10
                anchors.topMargin: 10
                anchors.left: parent.left
            }
            Rectangle{
                id: recipientEdit;
                width: parent.width - 20
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 20
                anchors.top: recipientLb.top;
                radius: 5
                border.color: "Blue"
                border.width: 1
                color: "White"
                TextEdit{
                    text: "";
                    width: parent.width / 2;
                    font.pixelSize: 15;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.leftMargin: 10
                    anchors.left: recipientEdit.left
                }
            }

            Text{
                id: recipientLb2;
                text: "Amount:";
                width: parent.width / 2;
                height: 20
                font.pixelSize: 13;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.top: recipientEdit.bottom;
                anchors.leftMargin: 10
                anchors.topMargin: 10
                anchors.left: parent.left
            }
            Rectangle{
                id: recipientEdit1;
                width: parent.width - 20
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 20
                anchors.top: recipientLb2.top;
                radius: 5
                border.color: "Blue"
                border.width: 1
                color: "White"
                TextEdit{
                    text: "0.00";
                    width: parent.width / 2;
                    font.pixelSize: 15;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.leftMargin: 10
                    anchors.left: recipientEdit1.left
                }
            }
        }
    }

    /////////////////////////--------------------------//////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////

    StackLayout {
        id: wallets
        width: parent.width - 10
        height: parent.height - walletsBar.height - 10
        anchors.top: walletsBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        currentIndex: walletsBar.currentIndex
        anchors.margins: 5

        Repeater{
            id: rep
            model: tabModel
            Item {

                Row {
                    id: walletAddress
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 20
                    anchors.topMargin: 10
                    width: parent.width
                    height: parent.height * 0.10

                    Text{
                        id: adressTxt
                        text: "Address: " + model.address
                        elide: Text.ElideRight
                        font.pixelSize: 16
                        width: parent.width / 1.5
                        height: parent.height
                        anchors.left: parent.left
                        anchors.top: walletAddress.top
                        anchors.topMargin: 10
                    }
                    Button{
                        id: cpAddressBtn
                        width: parent.height * 1.4
                        height: parent.height
                        anchors.left: adressTxt.right
                        anchors.leftMargin: 10
                        anchors.top: walletAddress.top
                        text: ""
                        icon.color: "transparent"
                        icon.source: "qrc:/Resources/Icons/save_icon.png"
                    }
                    Button{
                        id: walletSettBtn
                        width: parent.height * 1.4
                        height: parent.height
                        anchors.right: walletAddress.right
                        anchors.rightMargin: 20
                        anchors.top: walletAddress.top
                        text: ""
                        icon.color: "transparent"
                        icon.source: "qrc:/Resources/Icons/settings_icon.png"
                        onClicked: {
                            switchToWalletSettings();
                        }
                    }
                }

                Text{
                    id: tokensTitle
                    font.pixelSize: 16
                    anchors.left: parent.left
                    anchors.top: walletAddress.bottom
                    anchors.leftMargin: 20
                    anchors.topMargin: 10
                    text: qsTr("Tokens:")
                }

                Rectangle {
                    height: 1
                    color: 'Grey'
                    anchors {
                        left: parent.left
                        top: tokensTitle.bottom
                    }
                    id : titleSeparator
                    anchors.leftMargin: 10
                    width: 120
                    opacity: 0.5
                }
                ListView {
                    id: listViewTokens
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    width: parent.width
                    height: parent.height * 0.35
                    anchors.margins: 1
                    anchors.top: titleSeparator.bottom
                    model: walletModels[index];
                    clip: true

                    delegate: Item{
                        width: parent.width
                        height: 41
                        Rectangle{
                            id: borderRect
                            width: parent.width
                            height: 40
                            border.color: "Green"
                            border.width: 0
                            radius: 5
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered:{
                                    borderRect.border.width = 1
                                }
                                onExited: {
                                    borderRect.border.width = 0
                                }
                                onClicked: {
                                    dapUiQmlWidgetChainWallet.amount = parseFloat(walletAmount.text)
                                    dapUiQmlWidgetChainWallet.token = walletName.text
                                    dapUiQmlWidgetChainWallet.activeWalletIndex = index
                                    dapUiQmlWidgetChainWallet.activeWalletModel = listViewTokens.model
                                    switchToTransaction();
                                }
                            }
                            Row {
                                width: parent.width
                                height: parent.height
                                Text{
                                    id: walletName
                                    text: qsTr(model.name)
                                    font.pixelSize: { if (index === 0) return 18; else return 16;}
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 30
                                }

                                Text{
                                    id: walletAmount
                                    text: qsTr(model.amount)
                                    font.pixelSize: { if (index === 0) return 18; else return 16;}
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 30
                                }
                            }
                        }
                        Rectangle {
                            height: 1
                            color: 'Grey'
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: borderRect.bottom
                            }
                            anchors.leftMargin: 30
                            anchors.rightMargin: 30
                            opacity: 0.5
                        }
                    }


                    ScrollBar.vertical: ScrollBar { policy: { if (listViewTokens.count > 3) return ScrollBar.AlwaysOn;}  }

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    focus: true
                }


                Text{
                    id: historyTitle
                    font.pixelSize: 16
                    anchors.left: parent.left
                    anchors.top: listViewTokens.bottom
                    anchors.leftMargin: 20
                    anchors.topMargin: 30
                    text: qsTr("Transaction History:")
                }

                Rectangle {
                    height: 1
                    color: 'Grey'
                    anchors {
                        left: parent.left
                        top: historyTitle.bottom
                    }
                    id : titleSeparatorHis
                    anchors.leftMargin: 10
                    width: 120
                    opacity: 0.5
                }
                ListView {
                    id: listViewHistory
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    width: parent.width
                    height: parent.height * 0.28
                    anchors.margins: 1
                    anchors.top: titleSeparatorHis.bottom
                    model: walletHistories[index]
                    clip: true

                    delegate: Item{
                        width: parent.width
                        height: 41
                        Rectangle{
                            id: borderRectH
                            width: parent.width
                            height: 40
                            border.color: "Green"
                            border.width: 0
                            radius: 5

                            Row {
                                width: parent.width
                                height: parent.height
                                Text{
                                    id: transDate
                                    text: qsTr(model.date)
                                    font.pixelSize: 15
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 30
                                }

                                Text{
                                    id: transFrom
                                    width: 150
                                    text: {
                                        if (model.isAdd === true)
                                            return "from:" + qsTr(model.from);
                                        else
                                            return "to:" + qsTr(model.from);
                                    }
                                    font.pixelSize: 15
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text{
                                    id: transAmount
                                    text:{
                                        if (model.isAdd === true)
                                            return "+" + qsTr(model.amount)
                                        else
                                            return "-" + qsTr(model.amount)
                                    }
                                    font.pixelSize: 15
                                    color: {
                                        if (model.isAdd === true)
                                            return "Green";
                                        else
                                            return "Red";
                                    }
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 30
                                }
                            }
                        }
                        Rectangle {
                            height: 1
                            color: 'Grey'
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: borderRectH.bottom
                            }
                            anchors.leftMargin: 30
                            anchors.rightMargin: 30
                            opacity: 0.5
                        }
                    }


                    ScrollBar.vertical: ScrollBar { policy: { if (listViewHistory.count > 3) return ScrollBar.AlwaysOn;}  }

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    focus: true
                }
            }
        }
    }

    function switchToTransaction()
    {
        if (transaction.visible === false){
            walletsBar.visible = false;
            wallets.visible = false;
            transaction.visible = true;
        }
        else{
            walletsBar.visible = true;
            wallets.visible = true;
            transaction.visible = false;
        }
    }

    function switchToWalletSettings()
    {
        if (settings.visible === false){
            walletsBar.visible = false;
            wallets.visible = false;
            settings.visible = true;
        }
        else{
            walletsBar.visible = true;
            wallets.visible = true;
            settings.visible = false;
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_height:200;anchors_width:200;anchors_x:60;anchors_y:173}
}
 ##^##*/
