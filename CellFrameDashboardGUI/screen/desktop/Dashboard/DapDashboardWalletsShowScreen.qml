import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "../controls"
import "qrc:/widgets"

DapRectangleLitAndShaded
{
    property alias listViewWallet: listViewWallet

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            id: walletShowHeader
            Layout.fillWidth: true
            height: 42
            visible: listViewWallet.visible  && logicWallet.spiner !== true

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold14
                color: currTheme.white
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Tokens")
            }
        }

        ColumnLayout
        {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16
            visible: !listViewWallet.visible && !addWalletButtonLayout.visible
            //visible: logicWallet.spiner === true

            Item{Layout.fillHeight: true}

            DapLoadIndicator {
                Layout.alignment: Qt.AlignHCenter

                indicatorSize: 64
                countElements: 8
                elementSize: 10

                running: !listViewWallet.visible
            }

            Text
            {
                Layout.alignment: Qt.AlignHCenter

                font: mainFont.dapFont.medium16
                color: currTheme.white
                text: qsTr("Wallets loading...")
            }
            Item{Layout.fillHeight: true}
        }

        ColumnLayout
        {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            id: addWalletButtonLayout
            visible: !listViewWallet.visible && logicWallet.spiner !== true

            Item{Layout.fillHeight: true}

            Image
            {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/Resources/" + pathTheme + "/Illustratons/lock_illustration.svg"
                mipmap: true
                fillMode: Image.PreserveAspectFit
            }

            DapButton
            {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 48

                id: addWalletButton

                implicitWidth: 184
                implicitHeight: 36
                textButton: qsTr("Unlock wallet")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText:Qt.AlignCenter
                onClicked: walletActivatePopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName, false)
            }

            Item{Layout.fillHeight: true}
        }

        ListView
        {
            id: listViewWallet
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            visible: walletModelList.get(walletModule.currentWalletIndex).statusProtected !== "non-Active"
            model: walletModelInfo

            delegate: delegateTokenView
        }

        Component
        {
            id: delegateTokenView
            Column
            {
                width: listViewWallet.width

                Rectangle
                {
                    id: stockNameBlock
                    height: 30
                    width: parent.width
                    color: currTheme.mainBackground

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 0

                        Text
                        {
                            Layout.fillWidth: true
                            font: mainFont.dapFont.medium12
                            color: currTheme.white
                            verticalAlignment: Qt.AlignVCenter
                            text: networkName
                        }

                        Item{Layout.fillWidth: true}

                        Item
                        {
                            Layout.alignment: Qt.AlignRight
                            Layout.minimumWidth: 108
                            Layout.maximumWidth: 108
                            Layout.fillHeight: true

                            DapText
                            {
                                id: textMetworkAddress
                                height: parent.height
                                fontDapText: mainFont.dapFont.regular12
                                color: currTheme.white
                                fullText: address
                                textElide: Text.ElideMiddle
                                horizontalAlignment: Qt.AlignRight
                                verticalAlignment: Qt.AlignVCenter
                                anchors.left: parent.left
                                anchors.right:networkAddressCopyButton.left
                                anchors.rightMargin: 8
                            }

                            DapCopyButton
                            {
                                id: networkAddressCopyButton
                                onCopyClicked: textMetworkAddress.copyFullText()
                                popupText: qsTr("Address copied")
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.topMargin: 6
                            }
                        }
                    }
                }

                Repeater
                {
                    width: parent.width
                    model: networkTokensModel


                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 50
                        color: currTheme.secondaryBackground

                        RowLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 10

                            Text
                            {
                                id: currencyName
                                font: mainFont.dapFont.regular16
                                color: currTheme.white
                                text: tokenName
                                width: 172
                                horizontalAlignment: Text.AlignLeft
                            }

                            Item
                            {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: availableCoins === ""
                                DapBigText
                                {
                                    id: currencySum
                                    anchors.fill: parent
                                    textFont: mainFont.dapFont.regular14
                                    fullText: value
                                    horizontalAlign: Text.AlignRight
                                }
                            }

                            Text
                            {
                                id: currencyCode
                                visible: availableCoins === ""
                                font: mainFont.dapFont.regular14
                                color: currTheme.white
                                text: tiker
                                horizontalAlignment: Text.AlignRight
                            }

                            ColumnLayout
                            {
                                visible: availableCoins
                                Layout.fillWidth: false
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignRight
                                spacing: 4

                                RowLayout
                                {
                                    Layout.fillWidth: true

                                    Text
                                    {
                                        Layout.fillWidth: true
                                        font: mainFont.dapFont.regular12
                                        color: currTheme.textColorGrayTwo
                                        text: qsTr("full balance:")
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    DapBigText
                                    {
                                        textFont: mainFont.dapFont.regular12
                                        textColor: currTheme.textColor
                                        fullText: value
                                        horizontalAlign: Text.AlignRight
                                        width: textElement.implicitWidth
                                    }

                                    Text
                                    {
                                        font: mainFont.dapFont.regular12
                                        color: currTheme.textColor
                                        text: tiker
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }

                                RowLayout
                                {
                                    Layout.fillWidth: true

                                    Item
                                    {
                                        Layout.fillWidth: true

                                        height: 19
                                        width: 100
                                        Text
                                        {
                                            id: availableText
                                            font: mainFont.dapFont.regular12
                                            anchors.topMargin: 2
                                            anchors.fill: parent
                                            color: currTheme.textColorGrayTwo
                                            text: qsTr("available balance:")
                                            horizontalAlignment: Text.AlignRight
                                        }

                                        Image {
                                            width: availableText.width
                                            height: 1
                                            anchors.bottom: parent.bottom
                                            source: "qrc:/Resources/"+ pathTheme +"/icons/other/dash.svg"
                                        }
                                    }



                                    DapBigText
                                    {
                                        textFont: mainFont.dapFont.regular12
                                        textColor: currTheme.textColor
                                        fullText: availableCoins
                                        horizontalAlign: Text.AlignRight
                                        width: textElement.implicitWidth
                                    }

                                    Text
                                    {
                                        font: mainFont.dapFont.regular12
                                        color: currTheme.textColor
                                        text: tiker
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }
                            }
                        }

                        //  Underline
                        Rectangle
                        {
                            x: 16
                            y: parent.height - 1
                            width: parent.width - 32
                            height: 1
                            color: currTheme.mainBackground
                        }
                    }
                }
            }
        }
    }

    function updateVisibleList()
    {
        listViewWallet.visible = walletModelList.get(walletModule.currentWalletIndex).statusProtected !== "non-Active"
    }

    Connections
    {
        target: walletModule

        function onCurrentWalletChanged()
        {
            updateVisibleList()
        }

        function onWalletsModelChanged()
        {
            updateVisibleList()
        }
    }
}
