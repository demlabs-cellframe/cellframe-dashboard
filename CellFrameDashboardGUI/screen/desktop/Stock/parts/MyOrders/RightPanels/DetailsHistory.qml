import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../../../controls"

DapRectangleLitAndShaded {
    id: root

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
                onClicked: logic.closedDetails()
            }

            Text
            {
                id: textHeader
                text: qsTr("Order details")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ScrollView {
            Layout.topMargin: 8
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            clip: true

//            ScrollBar.vertical.policy: ScrollBar.AlwaysOn


            contentData:
            ColumnLayout
            {
                spacing: 16

                DetailsText {
                    title.text: qsTr("Date")
                    content.text: bufferDetails.get(0).date
                    title.color: currTheme.gray
                }
                // DetailsText {
                //     title.text: qsTr("Closed date")
                //     content.text: bufferDetails.get(0).closedDate
                //     title.color: currTheme.gray
                // }
                DetailsText {
                    title.text: qsTr("Pair")
                    content.text: bufferDetails.get(0).pair
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Type")
                    content.text: bufferDetails.get(0).type
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Side")
                    content.text: bufferDetails.get(0).side
                    title.color: currTheme.gray
                }
                // DetailsText {
                //     title.text: qsTr("Average price")
                //     content.text: bufferDetails.get(0).averagePrice
                //     title.color: currTheme.gray
                // }
                DetailsText {
                    title.text: qsTr("Price")
                    content.text: bufferDetails.get(0).price
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Filled")
                    content.text: bufferDetails.get(0).filled
                    title.color: currTheme.gray
                }
                DetailsText {
                    title.text: qsTr("Amount")
                    content.text: bufferDetails.get(0).amount
                    title.color: currTheme.gray
                }
                // DetailsText {
                //     title.text: qsTr("Total")
                //     content.text: bufferDetails.get(0).total
                //     title.color: currTheme.gray
                // }
                // DetailsText {
                //     title.text: qsTr("Trigger condition")
                //     content.text: bufferDetails.get(0).triggerCondition
                //     title.color: currTheme.gray
                // }
                // DetailsText {
                //     title.text: qsTr("Status")
                //     content.text: bufferDetails.get(0).status
                //     title.color: currTheme.gray
                // }
                Item{
                    height: 10
                }
            }
        }
    }
}   //root



