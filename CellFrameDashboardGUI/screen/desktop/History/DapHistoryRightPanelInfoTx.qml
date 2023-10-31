import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "../controls"
import "qrc:/widgets"

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
                color: currTheme.white
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
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "TX hash"
                    content.text: detailsModel.get(0).tx_hash
                    title.color: currTheme.gray
                    copyButton.visible: true
                    copyButton.popupText: "Hash copied"
                }
                TextDetailsTx {
                    title.text: "TX status"
                    content.text: detailsModel.get(0).tx_status
                    title.color: currTheme.gray

                    content.color: detailsModel.get(0).tx_status === "DECLINED" ?
                                           currTheme.red :
                                           currTheme.lightGreen
                }
                TextDetailsTx {
                    title.text: "Date"
                    content.text: detailsModel.get(0).date
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "Time"
                    content.text: detailsModel.get(0).time
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "Status"
                    content.text: detailsModel.get(0).status
                    title.color: currTheme.gray
                    content.color: text === "Sent"      ? currTheme.orange :
                                   text === "Pending"   ? currTheme.darkYellow :
                                   text === "Error" ||
                                   text === "Declined"  ? currTheme.red :
                                   text === "Received"  ? currTheme.lightGreen :
                                   text === "Queued"    ? currTheme.textColorLightBlue :
                                   text === "Unknown"   ? currTheme.textColorPurple :
                                                          currTheme.white
                }
                TextDetailsTx {
                    title.text: "From"
                    content.text: detailsModel.get(0).direction === "to" ? detailsModel.get(0).wallet_name : detailsModel.get(0).address
                    title.color: currTheme.gray
                    copyButton.visible: detailsModel.get(0).direction === "to" ? false : detailsModel.get(0).address.length === 104 ? true : false
                }
                TextDetailsTx {
                    title.text: "To"
                    content.text: detailsModel.get(0).direction === "to" ? detailsModel.get(0).address : detailsModel.get(0).wallet_name
                    title.color: currTheme.gray
                    copyButton.visible: detailsModel.get(0).direction === "to" ? true : false
                }
                TextDetailsTx {
                    title.text: "Token"
                    content.text: detailsModel.get(0).token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "Value"
                    content.text: detailsModel.get(0).value + " " + detailsModel.get(0).token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "Validator fee"
                    content.text: detailsModel.get(0).fee + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: "Fee"
                    content.text: detailsModel.get(0).fee_net + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: detailsModel.get(0).m_direction === "from" ? qsTr("Deposited") : qsTr("Burning")
                    content.text:
                    {
                        var str = detailsModel.get(0).m_direction === "from" ? "+" : "-"
                        str += " " + detailsModel.get(0).m_value + " " + detailsModel.get(0).m_token
                        return str
                    }
                    title.color: currTheme.gray
                    visible: detailsModel.get(0).m_value !== "0.0" && detailsModel.get(0).m_value !== ""
                }
                TextDetailsTx {
                    title.text: "Atom"
                    content.text: detailsModel.get(0).atom
                    title.color: currTheme.gray
                    copyButton.visible: true
                    copyButton.popupText: "Atom copied"
                    visible: detailsModel.get(0).atom !== ""
                }
                Item{
                    height: 10
                }
            }
        }
    }
}



