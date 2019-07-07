import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import KelvinDashboard 1.0

Page {
    id: dapUiQmlWidgetChainWallet

    title: qsTr("Wallet")

    property alias listViewWallet: listViewWallet
    property alias buttonSaveWallet: buttonSaveWallet
    property alias dialogAddWallet: dialogAddWallet
    property alias dialogSendToken: dialogSendToken
    property alias addressWallet: addressWallet
    property alias textBalance: textBalance
    property alias listViewTokens: listViewTokens
    property alias buttonSendToken: buttonSendToken

    Rectangle
    {
        id: rectanglePanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#353841"
        width: 100
        ListView {
            id: listViewWallet
            anchors.fill: parent
            keyNavigationEnabled: true
            model: dapChainWalletsModel

           delegate: Item {
               id: delegateWallet
                width: parent.width
                height: 100

                   Column
                    {
                        anchors.centerIn: parent
                        spacing: 5

                        Label {
                            id: nameWallet
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr(name)
                            font.pixelSize: 14
                            color: "#BBBEBF"
                            font.family: "Roboto"
                            width: delegateWallet.width
                            elide: Text.ElideRight
                            leftPadding: 5
                        }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: listViewWallet.currentIndex = index
                }
            }

           focus: true
        }
    }

    Rectangle
    {
        anchors.left: rectanglePanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        TextEdit {
            id: addressWallet
            font.pixelSize: 11
            wrapMode: Text.Wrap
            selectByMouse: true
            color: "black"
            selectionColor: "#008080"
            clip: true
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            readOnly: true
        }
        
        ListView {
            id: listViewTokens
            orientation: ListView.Vertical
            anchors.top: addressWallet.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width*2/3
            flickableDirection: Flickable.VerticalFlick
            delegate:  Item {
                width: 200; height: 50
                Text { id: nameField; text: modelData; color: listViewTokens.currentIndex === index ? 'green' : 'black'; }
                MouseArea {
                    anchors.fill: parent
                    onClicked: listViewTokens.currentIndex = index
                }
            }
            
            focus: true
        }
        
        Text 
        {
            id: textBalance
            wrapMode: Text.NoWrap
            textFormat: Text.PlainText
            clip: false
            anchors.top: addressWallet.bottom
            anchors.left: listViewTokens.right
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            
            font.pixelSize: 30
            font.bold: true
        }
    }

    DapUiQmlScreenDialogAddWallet {
        id: dialogAddWallet
            }
    DapUiQmlScreenDialogSendToken {
        id: dialogSendToken
            }

    RoundButton {
            id: buttonDeleteWallet
           highlighted: true
           anchors.margins: 10
           anchors.left: parent.left
           anchors.bottom: buttonSaveWallet.top
           height: 40
           width: 40
           contentItem: Text {
               text: qsTr("-")
               color: "#121B28"
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
               elide: Text.ElideRight
       
           }
                   background: Rectangle {
                       color: "white"
                       border.color: "#121B28"
                       radius: 20
                   }
    }

    RoundButton {
            id: buttonSaveWallet
            contentItem: Text {
                text: qsTr("+")
                color: "#121B28"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
        
            }
            background: Rectangle {
                id: inSave
                color: "white"
                border.color: "#121B28"
                radius: 20
            }
            
           highlighted: true
           anchors.margins: 10
           anchors.left: parent.left
           anchors.bottom: parent.bottom
           height: 40
           width: 40
    }
    
    RoundButton {
            id: buttonSendToken
            text: qsTr("->")
           highlighted: true
           anchors.margins: 10
           anchors.right: parent.right
           anchors.bottom: parent.bottom
    }
    
    RoundButton {
            id: buttonAddToken
            text: qsTr("+")
           highlighted: true
           anchors.margins: 10
           anchors.right: parent.right
           anchors.bottom: buttonSendToken.top
    }
}

