import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../controls"

Page {
    id: root

    background: Rectangle {
        color: "transparent"
    }


    ListModel
    {
        id: chainModel

        ListElement
        {
            name: "chain1"
        }

        ListElement
        {
            name: "chain2"
        }

        ListElement
        {
            name: "chain3"
        }

        ListElement
        {
            name: "chain4"
        }

        ListElement
        {
            name: "chain5"
        }
    }

    ListModel
    {
        id: certModel

        ListElement
        {
            name: "cert1"
        }

        ListElement
        {
            name: "cert2"
        }

        ListElement
        {
            name: "cert3"
        }

        ListElement
        {
            name: "cert4"
        }

        ListElement
        {
            name: "cert5"
        }
    }

    ColumnLayout
    {
        width: parent.width
//        height: childrenRect.height

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 21 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked:
                {
                    logicTokens.unselectToken()
                    navigator.clear()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Emission")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Chain")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item
        {
            height: 56 * pt
            Layout.fillWidth: true

            DapComboBox {
                anchors.fill: parent
                anchors.leftMargin: 15 * pt
                anchors.rightMargin: 15 * pt
                model: chainModel

                defaultText: qsTr("chain1")
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Select certificate")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item
        {
            height: 56 * pt
            Layout.fillWidth: true

            DapComboBox {
                anchors.fill: parent
                anchors.leftMargin: 15 * pt
                anchors.rightMargin: 15 * pt
                model: certModel

                defaultText: qsTr("cert1")
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Emission value")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item
        {
            Layout.fillWidth: true
            height: 60 * pt

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 36 * pt
                anchors.rightMargin: 36 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 16 * pt
                border.width: 1
                border.color: "#666E7D"
                color: "transparent"

                TextField
                {
                    anchors.fill: parent
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight
                    color: currTheme.textColor

                    background: Rectangle {
                        color: "transparent"
                    }
                    text: "200000.86"
                }
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Rectangle
        {
            id: frameRecipientWalletAddress
            Layout.fillWidth: true
            Layout.leftMargin: 20 * pt
            Layout.rightMargin: 20 * pt
            height: 53 * pt
            color: "transparent"

            TextField
            {
                id: textInputRecipientWalletAddress
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Paste here")
                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.topMargin: 26 * pt
                color: currTheme.textColor

                background: Rectangle {
                    color: "transparent"
                }
            }

            Rectangle
            {
                height: 1 * pt
                width: parent.width - x * 2
                color: currTheme.borderColor
                y: textInputRecipientWalletAddress.y + textInputRecipientWalletAddress.height + 5 * pt
                x: 10 * pt
            }
        }

    }

    DapButton
    {
        implicitWidth: 165 * pt
        implicitHeight: 36 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24 * pt
        textButton: qsTr("Emission")
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText:Qt.AlignCenter
    }
}


