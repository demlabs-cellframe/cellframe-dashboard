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
                    title.text: qsTr("Network")
                    content.text: detailsModel.get(0).network
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("TX hash")
                    content.text: detailsModel.get(0).tx_hash
                    title.color: currTheme.gray
                    copyButton.visible: true
                    copyButton.popupText: qsTr("Hash copied")
                }
                TextDetailsTx {
                    title.text: qsTr("TX status")
                    content.text: detailsModel.get(0).tx_status
                    title.color: currTheme.gray

                    content.color: detailsModel.get(0).tx_status === "DECLINED" ?
                                           currTheme.red :
                                           currTheme.lightGreen
                }
                TextDetailsTx {
                    title.text: qsTr("Date")
                    content.text: detailsModel.get(0).date
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Time")
                    content.text: detailsModel.get(0).time
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Status")
                    content.text: detailsModel.get(0).status
                    title.color: currTheme.gray
                    content.color: detailsModel.get(0).status === "Sent"        ?  currTheme.orange :
                                   detailsModel.get(0).status === "Pending"     ?  currTheme.darkYellow :
                                   detailsModel.get(0).status === "Queued"      ? currTheme.textColorLightBlue :
                                   detailsModel.get(0).status === "Error"       ?  currTheme.red :
                                   detailsModel.get(0).status === "Exchange"    ?  currTheme.coral :
                                   detailsModel.get(0).status === "Received"    ?  currTheme.lightGreen :
                                                                         currTheme.white
                }
                TextDetailsTx {
                    title.text: qsTr("From")
                    content.text: detailsModel.get(0).status === "Sent" ? detailsModel.get(0).wallet_name : detailsModel.get(0).address
                    title.color: currTheme.gray
                    copyButton.visible: detailsModel.get(0).direction === "to" ? false : detailsModel.get(0).address.length === 104 ? true : false
                }
                TextDetailsTx {
                    title.text: qsTr("To")
                    content.text: detailsModel.get(0).status === "Sent" ? detailsModel.get(0).address : detailsModel.get(0).wallet_name
                    title.color: currTheme.gray
                    copyButton.visible: detailsModel.get(0).direction === "to" && detailsModel.get(0).address !== "null" ? true : false
                }
                TextDetailsTx {
                    title.text: qsTr("Token")
                    content.text: detailsModel.get(0).token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Value")
                    content.text: detailsModel.get(0).value + " " + detailsModel.get(0).token
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
                    title.text: qsTr("Validator fee")
                    content.text: detailsModel.get(0).fee_validator + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Network fee")
                    content.text: detailsModel.get(0).fee_net + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Total fee")
                    content.text: detailsModel.get(0).fee + " " + detailsModel.get(0).fee_token
                    title.color: currTheme.gray
                }
                TextDetailsTx {
                    title.text: qsTr("Atom")
                    content.text: detailsModel.get(0).atom
                    title.color: currTheme.gray
                    copyButton.visible: true
                    copyButton.popupText: qsTr("Atom copied")
                    visible: detailsModel.get(0).atom !== ""
                }

                TextDetailsTx {
                    title.text: qsTr("Receive from xchange")
                    content.text:
                    {
                        var str = detailsModel.get(0).x_direction === "from" ? "+" : "-"
                        str += " " + detailsModel.get(0).x_value + " " + detailsModel.get(0).x_token
                        return str
                    }
                    title.color: currTheme.gray
                    visible: detailsModel.get(0).x_value !== ""
                }
                Item{
                    height: 10
                }
            }
        }
    }
}



