import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../../controls"
import "qrc:/widgets"
import "../parts"


DapRectangleLitAndShaded {
    id: root

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

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
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 16

                DetailsText {
                    title.text: "Name"
                    content.fullNumber: detailsModel.get(0).name
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Auth signs"
                    content.fullNumber: detailsModel.get(0).auth_signs
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Type"
                    content.fullNumber: detailsModel.get(0).type
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Flags"
                    content.fullNumber: detailsModel.get(0).flags
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Decimals"
                    content.fullNumber: detailsModel.get(0).decimals
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Current supply"
                    content.fullNumber: dapMath.balanceToCoins(detailsModel.get(0).current_supply)
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Total supply"
                    content.fullNumber: dapMath.balanceToCoins(detailsModel.get(0).total_supply)
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Total emissions"
                    content.fullNumber: detailsModel.get(0).total_emissions
                    title.color: currTheme.textColorGray
                }
                Item{
                    height: 10
                }
            }
        }
        DapButton
        {
            implicitWidth: 163
            implicitHeight: 36
            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Emission")
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText:Qt.AlignCenter
            onClicked: navigator.emission()
        }
    }
}



