import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "qrc:/resources/QML"
import "qrc:/widgets"

Item {

    property bool blurBackground: false

    property int pushedPage: 0

    property var mainButtonsModel: [
        {
            "name": qsTr("Wallet"),
            "systemName": "Wallet",
            "bttnIco": "wallet.svg",
            "bttnIcoHover": "wallet_hover.svg",
            "url": walletPage
        },
        {
            "name": qsTr("Transactions"),
            "systemName": "Transactions",
            "bttnIco": "transactions.svg",
            "bttnIcoHover": "transactions_hover.svg",
            "url": txExplorerPage
        },
        {
            "name": qsTr("DEX"),
            "systemName": "DEX",
            "bttnIco": "dex.svg",
            "bttnIcoHover": "dex_hover.svg",
            "url": dexPage
        },
        {
            "name": qsTr("dApps"),
            "systemName": "dApps",
            "bttnIco": "daps.svg",
            "bttnIcoHover": "daps_hover.svg",
            "url": dAppsPage
        },
        {
            "name": qsTr("Settings"),
            "systemName": "Settings",
            "bttnIco": "settings.svg",
            "bttnIcoHover": "settings_hover.svg",
            "url": settingsPage
        }
    ]

    Component.onCompleted:
    {
        //modulesController.setNewTypeScreen(mainButtonsModel.indexOf(0).systemName)
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: currTheme.mainBackground

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onWheel: {}
            onEntered: {}
            onExited: {}
        }
    }

    FastBlur {
        visible: blurBackground
        anchors.fill: parent
        source: mainViewBottom
        radius: 32
    }

/*    Rectangle{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: "#524D64"
    }*/

    RowLayout {
        anchors.fill: parent
        spacing: 0

//        MouseArea
//        {
//            id: mainArea
//            anchors.fill: parent

//            onClicked:
//            {
////                console.log("mainArea onClicked")
//            }

//        }

        Repeater{
            model: mainButtonsModel

            delegate:
            Item
            {
                id: delegate
                property bool isPushed: pushedPage === index
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

                width: 75
                height: 50

                ColumnLayout{
                    id: lay
                    anchors.fill: parent
                    anchors.topMargin: 7
                    spacing: 3

                    DapImageRender {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignvCenter
                        source: delegate.isPushed? "qrc:/walletSkin/Resources/" + pathTheme + "/icons/navigation/" + modelData.bttnIcoHover:
                                                   "qrc:/walletSkin/Resources/" + pathTheme + "/icons/navigation/" + modelData.bttnIco

                    }

                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignHCenter

                        text: modelData.name
                        color: delegate.isPushed ? currTheme.lime:
                                                   currTheme.white

                        font: mainFont.dapFont.medium10
                    }
                    Item{Layout.fillHeight: true}
                }

                MouseArea
                {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {

                    }
                    onExited: {

                    }

                    onClicked:
                    {
                        if(pushedPage !== index)
                        {
                            pushedPage = index;
                            stackView.setInitialItem(modelData.url)
                            stackView.isDappLoad = false
                        }
                    }
                }

                Connections
                {
                    target: dapMainWindow
                    function onCheckWebRequest() {
                        if(modelData.url === settingsPage)
                        {
                            if(pushedPage !== index)
                            {
                                pushedPage = index;
                                stackView.setInitialItem(modelData.url)
                                stackView.isDappLoad = false
                            }

                            delay(400,function() {
                                openRequests()
                            })
                        }
                    }
                }

            }
        }
    }

    Timer{id: timer}

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Connections
    {
        target: dapMainWindow
        function onOpenHistory() {
            pushedPage = 1
            stackView.setInitialItem(mainButtonsModel[1].url)
            stackView.isDappLoad = false
        }
    }

}
