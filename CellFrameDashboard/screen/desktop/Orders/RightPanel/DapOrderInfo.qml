import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../../controls"
import "qrc:/widgets"
import "../../Tokens/parts"


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
                onClicked:
                {
                    navigator.clear()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Info about order")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            Layout.topMargin: 12
//            Layout.leftMargin: 16
            clip: true

//            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            contentData:
            Loader{
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.leftMargin: 16
                anchors.fill: parent

                sourceComponent: logicOrders.currentTabTechName === "VPN"   ||
                                 logicOrders.currentTabTechName === "Stake"  ? vpnOrderDetails:
                                                                           dexOrderDetails

            }

        }
    }

    Component{
        id: vpnOrderDetails

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 16

            DetailsText {
                title.text: qsTr("Order Type")
                content: detailsModel.get(0).srv_uid
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Date copied")
                title.text: qsTr("Created")
                content: detailsModel.get(0).created
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Hash copied")
                title.text: qsTr("Hash")
                content: detailsModel.get(0).hash
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Network")
                content: detailsModel.get(0).network
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Version")
                content: detailsModel.get(0).version
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Direction")
                content: detailsModel.get(0).direction
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Units")
                content: detailsModel.get(0).units
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Price copied")
                title.text: qsTr("Price")
                content: detailsModel.get(0).price
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Price Token")
                content: detailsModel.get(0).price_token
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Price Unit")
                content: detailsModel.get(0).price_unit
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Location copied")
                title.text: qsTr("Node Location")
                content: detailsModel.get(0).node_location
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Address copied")
                title.text: qsTr("Node Address")
                content: detailsModel.get(0).node_addr
                title.color: currTheme.gray
            }
        }
    }

    Component{
        id: dexOrderDetails

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 16

            DetailsText {
                title.text: qsTr("Order Type")
                content: detailsModel.get(0).srv_uid
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Date copied")
                title.text: qsTr("Created")
                content: detailsModel.get(0).created
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Hash copied")
                title.text: qsTr("Hash")
                content: detailsModel.get(0).hash
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Network")
                content: detailsModel.get(0).network
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Status")
                content: detailsModel.get(0).status
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Amount copied")
                title.text: qsTr("Amount")
                content: detailsModel.get(0).amount
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Buy Token")
                content: detailsModel.get(0).buyToken
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Sell Token")
                content: detailsModel.get(0).sellToken
                title.color: currTheme.gray
            }
            DetailsText {
                title.text: qsTr("Filled")
                content: detailsModel.get(0).filled
                title.color: currTheme.gray
            }
            DetailsText {
                copyButton.visible: true
                copyButton.popupText: qsTr("Rate copied")
                title.text: qsTr("Rate")
                content: detailsModel.get(0).rate
                title.color: currTheme.gray
            }
        }
    }
}
