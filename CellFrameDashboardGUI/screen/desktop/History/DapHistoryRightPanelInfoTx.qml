import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../controls"
import "qrc:/widgets"

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
                    logicExplorer.selectTxIndex = -1
                    navigator.clear()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Transaction details")
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
                spacing: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 16

                TextDetailsTx {
                    title.text: "Network"
                    content.text: detailsModel.get(0).network
                    title.color: currTheme.textColorGray
                }
                TextDetailsTx {
                    title.text: "TX hash"
                    content.text: detailsModel.get(0).tx_hash
                    title.color: currTheme.textColorGray
                    copyButton.visible: true
                    copyButton.popupText: "Hash copied"
                }
                TextDetailsTx {
                    title.text: "TX status"
                    content.text: detailsModel.get(0).tx_status
                    title.color: currTheme.textColorGray

                    content.color: detailsModel.get(0).tx_status === "DECLINED" ?
                                           currTheme.textColorRed :
                                           currTheme.textColorLightGreen
                }
                TextDetailsTx {
                    title.text: "Date"
                    content.text: detailsModel.get(0).date
                    title.color: currTheme.textColorGray
                }
                TextDetailsTx {
                    title.text: "Status"
                    content.text: detailsModel.get(0).status
                    title.color: currTheme.textColorGray
                    content.color: detailsModel.get(0).status === "Sent"  ?  currTheme.textColorYellow :
                                       detailsModel.get(0).status === "Error" ?  currTheme.textColorRed :
                                       detailsModel.get(0).status === "Received"  ? currTheme.textColorLightGreen :
                                                                                currTheme.textColor
                }
                TextDetailsTx {
                    title.text: "From"
                    content.text: detailsModel.get(0).status === "Sent" ? detailsModel.get(0).wallet_name : detailsModel.get(0).address
                    title.color: currTheme.textColorGray
                    copyButton.visible: detailsModel.get(0).status === "Sent" ? false : detailsModel.get(0).address.length === 104 ? true : false
                }
                TextDetailsTx {
                    title.text: "To"
                    content.text: detailsModel.get(0).status === "Sent" ? detailsModel.get(0).address : detailsModel.get(0).wallet_name
                    title.color: currTheme.textColorGray
                    copyButton.visible: detailsModel.get(0).status === "Sent" ? true : false
                }
                TextDetailsTx {
                    title.text: "Token"
                    content.text: detailsModel.get(0).token
                    title.color: currTheme.textColorGray
                }
                TextDetailsTx {
                    title.text: "Value"
                    content.text: detailsModel.get(0).value + " " + detailsModel.get(0).token
                    title.color: currTheme.textColorGray
                }
                TextDetailsTx {
                    title.text: "Fee"
                    content.text: detailsModel.get(0).fee + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.textColorGray
                }
                TextDetailsTx {
                    title.text: "Atom"
                    content.text: detailsModel.get(0).atom
                    title.color: currTheme.textColorGray
                    copyButton.visible: true
                    copyButton.popupText: "Atom copied"
                }
                Item{
                    height: 10
                }
            }
        }
    }
}


