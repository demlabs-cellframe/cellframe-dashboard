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

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 7
                anchors.leftMargin: 21
                anchors.rightMargin: 13

                id: itemButtonClose
                height: 20
                width: 20
                heightImage: 20
                widthImage: 20

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
                text: qsTr("Info about token")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12
                anchors.bottomMargin: 8
                anchors.leftMargin: 52

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            Layout.topMargin: 12
            Layout.leftMargin: 16
            clip: true

//            ScrollBar.vertical.policy: ScrollBar.AlwaysOn


            contentData:
            ColumnLayout
            {
                spacing: 16

                DetailsText {
                    title.text: "Name"
                    content.text: detailsModel.get(0).name
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Auth signs"
                    content.text: detailsModel.get(0).auth_signs
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Type"
                    content.text: detailsModel.get(0).type
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Flags"
                    content.text: detailsModel.get(0).flags
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Decimals"
                    content.text: detailsModel.get(0).decimals
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Current supply"
                    content.text: dapMath.balanceToCoins(detailsModel.get(0).current_supply)
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Total supply"
                    content.text: dapMath.balanceToCoins(detailsModel.get(0).total_supply)
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Total emissions"
                    content.text: detailsModel.get(0).total_emissions
                    title.color: currTheme.textColorGray
                }
                Item{
                    height: 10
                }
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
        onClicked: navigator.emission()
    }
}



