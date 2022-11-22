import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
//import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

/*    QMLClipboard{
        id: clipboard
    }*/

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 23
//        anchors.leftMargin: 17

        spacing: 0

        ListView {
            clip: true
            orientation: ListView.Horizontal
            Layout.fillWidth: true
            Layout.leftMargin: 17
            height: 33 

            model: mainNetworkModel
//            spacing: 39

            spacing: {
                    if (count > 0) {
                        return (width - (60 * count))/(count - 1)
                    } else {
                        return 0
                    }
                }

            delegate:
            ColumnLayout
            {
                spacing: 0
//                width: 80

                Label {
//                    Layout.topMargin: 5 
//                    Layout.leftMargin: 15 
//                    Layout.rightMargin: 15 
//                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                    text: name
                    font: mainFont.dapFont.medium13
                    horizontalAlignment: Text.AlignHCenter
                    color: index === currentNetwork ? currTheme.hilightColorComboBox : currTheme.textColor
                }

                Rectangle
                {
                    Layout.topMargin: 11 
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 3 
                    width: 20 
//                    height: 4 
                    radius: 2
                    color: index === currentNetwork ? currTheme.hilightColorComboBox : currTheme.textColor
                }

                MouseArea
                {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        if(currentNetwork != index)
                        {
                            currentNetwork = index
                            window.updateTokenModel()

                        }
                    }
                }
            }
        }

        ListView {
            id: tokenView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 21 
            spacing: 0

            clip: true

            model: tokenModel

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
            Item {
                width: parent.width
                height: 86 

                Item
                {

                    anchors.fill: parent
                    anchors.topMargin: 13
                    anchors.bottomMargin: 13
                    anchors.leftMargin: 18
                    anchors.rightMargin: 17


                    Rectangle
                    {
                        id: itemRect
                        anchors.fill: parent
                        color: mouseArea.containsMouse ? currTheme.buttonColorNormalPosition0 :"#32363D"
                        radius: 12
                    }

                    InnerShadow {
                        id: shadow
                        anchors.fill: itemRect
                        radius: 5
                        samples: 10
                        cached: true
                        horizontalOffset: 1
                        verticalOffset: 1
                        color: "#515763"
                        source: itemRect
                    }
                    DropShadow {
                        anchors.fill: itemRect
                        radius: 10.0
                        samples: 10
                        cached: true
                        horizontalOffset: 4
                        verticalOffset: 4
                        color: "#252530"
                        source: shadow
                    }

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 22 
                        anchors.rightMargin: 22 

                        Text {
                            Layout.fillWidth: true

                            text: name
                            font: mainFont.dapFont.medium16
                            color: currTheme.textColor
                        }

                        Text {
                            text: balance
                            font: mainFont.dapFont.medium16
                            color: currTheme.textColor
                        }
                    }

                    MouseArea
                    {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            currentToken = index
                            mainStackView.push("Payment/TokenOverview.qml")
                            headerWindow.background.visible = false
                            walletNameLabel.visible = false
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: dapServiceController


        function onWalletsReceived(walletList) {
            logicMainApp.rcvWallets(walletList)
            nameWallet.text = dapModelWallets.get(currentWallet).name
            updateTokenModel()
        }
    }

}
