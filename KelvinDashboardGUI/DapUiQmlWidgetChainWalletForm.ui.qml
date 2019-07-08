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
    property alias listViewTokens: listViewTokens
    property alias buttonSendToken: buttonSendToken
    property alias buttonDeleteWallet: buttonDeleteWallet
    property alias dialogRemoveWallet: dialogRemoveWallet
    
    Rectangle {
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

                Column {
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

    Rectangle {
        anchors.left: rectanglePanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Row
        {
            id: rowAddress
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100
            width: parent.width
            Rectangle
            {
                id: rectangleLableAddress
                color: "green"
                width: 150
                height: parent.height
                Text
                {
                    id: labelAddress
                    anchors.centerIn: parent
                    text: "Address"
                    font.pixelSize: 22
                    color: "white"
                }
            }
            Column
            {
                id: columnAddress
                width: rowAddress.width - rectangleLableAddress.width
                height: parent.height
                clip: true
                TextEdit {
                    id: addressWallet
                    font.pixelSize: 16
                    wrapMode: TextEdit.WrapAnywhere

                    selectByMouse: true
                    color: "#353841"
                    selectionColor: "#353841"
                    clip: true
                    readOnly: true
                    height: parent.height - rectangleBottomBorder.height
                    width: parent.width
                    verticalAlignment: TextEdit.AlignVCenter
                    horizontalAlignment: TextEdit.AlignHCenter
                }
                Rectangle
                {
                    id: rectangleBottomBorder
                    color: "green"
                    height: 1
                    width: columnAddress.width
                }
            }
        }

        ListView {
            id: listViewTokens
            height: 100
            orientation: ListView.Horizontal
            anchors.top: rowAddress.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            flickableDirection: Flickable.VerticalFlick
            preferredHighlightBegin: parent.width/2-width/3/2;
            preferredHighlightEnd: parent.width/2+width/3/2
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapOneItem;
            model: ListModel {
                id: modelTokens
            }

            delegate:  Item {
                id: delegateListViewTokens
                width: listViewTokens.width/3; height: listViewTokens.height
                Column
                {
                    id: itemRectangleIfoWallet
                    anchors.centerIn: delegateListViewTokens
                    Text {
                        id: itemNameWallet;
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: token;
                        color: listViewTokens.currentIndex === index ? 'green' : "#BBBEBF";
                        font.pixelSize: listViewTokens.currentIndex === index ? 40 : 30;
                        font.family: "Roboto"
                        font.weight: Font.Thin
                    }
                    Text {
                        id: itemBalanceWallet;
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: balance
                        color: listViewTokens.currentIndex === index ? 'green' : "#BBBEBF";
                        font.pixelSize: listViewTokens.currentIndex === index ? 40 : 30;
                        font.family: "Roboto"
                        font.weight: Font.Thin
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: listViewTokens.currentIndex = index
                }
            }

            focus: true
            clip: true
        }

        Rectangle
        {
            id: rectangleHistory
            anchors.top: listViewTokens.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "green"
            width: parent.width
            height: 30
            Text
            {
                id: labelHistory
                anchors.centerIn: parent
                text: "History"
                font.pixelSize: 22
                color: "white"
            }
        }
    }

    DapUiQmlScreenDialogAddWallet {
        id: dialogAddWallet
    }
    DapUiQmlScreenDialogSendToken {
        id: dialogSendToken
    }
    DapUiQmlScreenDialogRemoveWallet {
        id: dialogRemoveWallet
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
