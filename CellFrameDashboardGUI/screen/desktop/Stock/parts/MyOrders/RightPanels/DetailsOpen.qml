import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../../../controls"

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
            height: 38
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
                onClicked: logic.closedDetails()
            }

            Text
            {
                id: textHeader
                text: qsTr("Order details")
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
            Layout.topMargin: 12
            Layout.leftMargin: 16
            clip: true


            contentData:
            ColumnLayout
            {
                spacing: 16

                DetailsText {
                    title.text: "Date"
                    content.text: bufferDetails.get(0).date
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Pair"
                    content.text: bufferDetails.get(0).pair
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Type"
                    content.text: bufferDetails.get(0).type
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Side"
                    content.text: bufferDetails.get(0).side
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Price"
                    content.text: bufferDetails.get(0).price
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Filled"
                    content.text: bufferDetails.get(0).filled
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Amount"
                    content.text: bufferDetails.get(0).amount
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Total"
                    content.text: bufferDetails.get(0).total
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Trigger condition"
                    content.text: bufferDetails.get(0).triggerCondition
                    title.color: currTheme.textColorGray
                }
                DetailsText {
                    title.text: "Expires in"
                    content.text: bufferDetails.get(0).expiresIn
                    title.color: currTheme.textColorGray
                }
            }
        }
    }
}   //root



