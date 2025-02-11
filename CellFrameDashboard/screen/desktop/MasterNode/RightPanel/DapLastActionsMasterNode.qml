import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"
import "../../controls"
import qmlclipboard 1.0

DapRectangleLitAndShaded
{
    id:control

    property int lastHistoryLength: 0
    property alias dapLastActionsView: lastActionsView

    ListModel{id: newModelLastActions}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    QMLClipboard
    {
        id: clipboard
    }

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        // Header
        Item
        {
            Layout.fillWidth: true
            height: 42
            visible: txExplorerModule.statusInit

            HeaderButtonForRightPanels
            {
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

                onClicked: dapRightPanel.push(baseMasterNodePanel)
            }


            Text
            {
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                font: mainFont.dapFont.bold14
                color: currTheme.white
                text: qsTr("Last actions")
            }
        }

        // Preloader
        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            visible: walletModelList.count > 0 && networkModel.count ? !txExplorerModule.statusInit : false

            Item{Layout.fillHeight: true}

            DapLoadIndicator
            {
                Layout.alignment: Qt.AlignHCenter

                indicatorSize: 64
                countElements: 8
                elementSize: 10

                running: !txExplorerModule.statusInit
            }


            Text
            {
                Layout.alignment: Qt.AlignHCenter

                font: mainFont.dapFont.medium16
                color: currTheme.white
                text: qsTr("Last Actions data loading...")
            }
            Item{Layout.fillHeight: true}
        }

        // Body
        ListView
        {
            id: lastActionsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: modelHistory
            ScrollBar.vertical: ScrollBar {
                active: true
            }
            visible: txExplorerModule.statusInit

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            delegate:
                Item
            {
                width: lastActionsView.width

                height: 67

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16
                    spacing: 12

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text
                        {
                            text: network
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 7
                        }

                        Text
                        {
                            id: statusText
                            text: tx_status === "ACCEPTED" || tx_status === "PROCESSING" ? status : "Declined"
                            color: text === "Sent" ?      currTheme.orange :
                                   text === "Pending" ?   currTheme.darkYellow :
                                   text === "Error" ||
                                   text === "Declined" ?  currTheme.red :
                                   text === "Received"  ? currTheme.lightGreen :
                                   text === "Queued"    ? currTheme.textColorLightBlue :
                                   text === "Exchange"  ? currTheme.coral :
                                   text === "Unknown"   ? currTheme.mainButtonColorNormal0 :
                                                          currTheme.white

                            font: mainFont.dapFont.regular12
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 24
                        }

                        Text
                        {
                            id: timestamp
                            text: qsTr("Timestamp:")
                            color: currTheme.gray
                            font: mainFont.dapFont.regular11
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 42
                        }

                        Text
                        {
                            text: time
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            anchors.left: timestamp.right
                            anchors.top: timestamp.top
                            anchors.leftMargin: 4
                        }

                        DapBigText
                        {
                            id: x_text
                            visible: x_value !== ""

                            property string sign: x_direction === "to"? "- " : "+ "
                            width: 160
                            height: 20
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + x_value + " " + x_token
                            textFont: mainFont.dapFont.regular13
                            anchors.right: copyBtn.left
                            anchors.top: val.bottom
                            anchors.rightMargin: 3
                            anchors.topMargin: 2
                        }

                        DapCopyButton
                        {
                            visible: x_text.visible
                            popupText: qsTr("Value copied")
                            anchors.right: parent.right
                            anchors.top: val.bottom
                            anchors.topMargin: 2
                            onCopyClicked: {
                                clipboard.setText(x_value)
                            }
                        }

                        DapBigText
                        {
                            property string sign: direction === "to"? "- " : "+ "
                            id: val
                            width: 160
                            height: !x_text.visible ? 20 : 14
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + value + " " + token
                            textFont: mainFont.dapFont.regular13
                            anchors.right: copyBtn.left
                            anchors.top: parent.top
                            anchors.rightMargin: 3
                            anchors.topMargin: !x_text.visible ? 13 : 6
                        }

                        DapCopyButton
                        {
                            id: copyBtn
                            popupText: qsTr("Value copied")
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: !x_text.visible ? 13 : 5
                            onCopyClicked: {
                                clipboard.setText(value)
                            }
                        }

                        DapTextWithList
                        {
                            ListModel
                            {
                                id: model_tooltip
                                Component.onCompleted:
                                {
                                    append ({
                                                name: qsTr("Fee: "),
                                                number: fee_net ,
                                                token_name: fee_token
                                            })
                                    append ({
                                                name: qsTr("Validator fee: "),
                                                number: fee,
                                                token_name: fee_token
                                            })
                                    if(m_value !== "0.0" && m_value !== "")
                                    {
                                        var str = m_direction === "from" ? "+" : "-"
                                        str += " "+ m_value
                                        append ({
                                                    name: m_direction === "from" ? qsTr("Deposited: ") : qsTr("Burning: "),
                                                    number: str,
                                                    token_name: m_token
                                                })
                                    }
                                }
                            }

                            alwaysHoverShow: true
                            height: 15
                            textColor: currTheme.lime
                            textHoverColor: currTheme.orange
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("Details")
                            textAndMenuFont: mainFont.dapFont.regular12
                            listView.model: model_tooltip
                            width: 40
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 42
                        }
                    }

                    DapToolTipInfo
                    {
                        property string normalIcon: statusText.text === "Queued" ? "qrc:/Resources/"+ pathTheme +"/icons/other/delete_button.svg"
                                                                            : "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"

                        property string hoverIcon: statusText.text === "Queued" ? "qrc:/Resources/"+ pathTheme +"/icons/other/delete_button_hover.svg"
                                                                            : "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"

                        property string disabledIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"

                        id: explorerIcon
                        Layout.preferredHeight: statusText.text === "Queued" ? 16 : 18
                        Layout.preferredWidth: statusText.text === "Queued" ? 16 : 18
                        contentText: statusText.text === "Queued" ? qsTr("Remove") : qsTr("Explorer")

                        toolTip.width: text.implicitWidth + 16
                        toolTip.x: -toolTip.width/2 + 8

                        enabled: statusText.text === "Queued" ? true : tx_status === "DECLINED" || tx_status === "PROCESSING" ? false :
                                  network !== "private"?
                                  true : false

                        indicatorSrcNormal: statusText.text === "Queued" ? normalIcon : tx_status === "DECLINED"  || tx_status === "PROCESSING" ? disabledIcon :
                                                network !== "private"?
                                                normalIcon : disabledIcon

                        indicatorSrcHover: statusText.text === "Queued" ? hoverIcon : tx_status === "DECLINED"   || tx_status === "PROCESSING" ? disabledIcon :
                                                network !== "private"?
                                                hoverIcon : disabledIcon

                        onClicked:
                        {
                            if(statusText.text === "Queued")
                            {
                                var stringLists = [[network, wallet_name, date_to_secs]]
                                    dapServiceController.tryRemoveTransactions(stringLists)
                            }
                            else
                            {
                                Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)
                            }
                        }
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1
                    color: currTheme.mainBackground
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30
            width: parent.width
            color: currTheme.mainBackground

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: dateWorker.getDateString(section)
                font: mainFont.dapFont.medium12
            }
        }
    }

    Component.onCompleted:
    {
        modelHistory.setNetworkFilter(nodeMasterModule.currentNetwork)
        modelHistory.setLastActions(true)
        lastHistoryLength = 0
        // txExplorerModule.updateHistory(true)
    }

    Component.onDestruction:
    {
        modelHistory.setNetworkFilter("All")
        modelHistory.setLastActions(false)
    }
}
