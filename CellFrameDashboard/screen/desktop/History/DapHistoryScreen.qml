import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../controls"
import qmlclipboard 1.0

Page
{
    id: historyScreen
    property alias dapHistoryRightPanel: historyRightPanel
    property alias dapHistoryVerticalScrollBar: historyVerticalScrollBar
    property alias dapListViewHistory: listViewHistory

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    QMLClipboard{
        id: clipboard
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 24 

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            anchors.fill: parent
            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
            Item{
                anchors.fill: parent
                ListView
                {
                    id: listViewHistory
                    anchors.fill: parent
                    visible: txExplorerModule.statusInit
                    model: modelHistory
                    clip: true

                    delegate: delegateToken

                    section.property: "date"
                    section.criteria: ViewSection.FullString
                    section.delegate: delegateDate

                    ScrollBar.vertical: ScrollBar {
                        id: historyVerticalScrollBar
                        active: true
                    }
                    currentIndex: logicExplorer.selectTxIndex
                }

                ColumnLayout{
                    anchors.fill: parent
                    spacing: 16
                    visible: !txExplorerModule.statusInit && !cellframeNodeWrapper.nodeRunning

                    Item{Layout.fillHeight: true}

                    DapLoadIndicator {
                        Layout.alignment: Qt.AlignHCenter

                        indicatorSize: 64
                        countElements: 8
                        elementSize: 10

                        running: !txExplorerModule.statusInit
                    }


                    Text
                    {
                        Layout.alignment: Qt.AlignHCenter

                        font: mainFont.dapFont.medium18
                        color: currTheme.white
                        text: qsTr("History data loading...")
                    }
                    Item{Layout.fillHeight: true}
                }
            }


        }

        DapHistoryRightPanel
        {
            id: historyRightPanel

            Layout.fillHeight: true
            Layout.minimumWidth: 350 
            Layout.maximumWidth: 350
        }

    }

    Component
    {
        id: delegateDate
        Rectangle
        {
            height: 30
            width: parent.width
            color: currTheme.mainBackground

//            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 
                anchors.rightMargin: 16 
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: dateWorker.getDateString(section)
                font: mainFont.dapFont.regular12
            }
        }
    }

    Component
    {
        id: delegateToken
        Rectangle
        {
            width:  dapListViewHistory.width
            height: 50 
            color: listViewHistory.currentIndex === index? currTheme.rowHover : currTheme.secondaryBackground

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 10

                // Network name and timestamp
                Item
                {
                    Layout.minimumWidth: 190
                    Layout.alignment: Qt.AlignLeft
                    Layout.fillHeight: true

                    Text
                    {
                        id: textNetworkName
                        text: network
                        color: currTheme.white
                        font:  mainFont.dapFont.regular14
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: 4
                    }

                    Text
                    {
                        id: textTimestamp
                        text: qsTr("Timestamp:")
                        color: currTheme.gray
                        font: mainFont.dapFont.regular11
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                    }

                    Text
                    {
                        text: time
                        color: currTheme.white
                        font: mainFont.dapFont.regular11
                        anchors.left: textTimestamp.right
                        anchors.top: textTimestamp.top
                        anchors.leftMargin: 3
                    }
                }

                // Status
                Text
                {
                    id: textSatus
                    Layout.minimumWidth: 80
                    text: tx_status === "ACCEPTED" || tx_status === "PROCESSING" ? status : "Declined"
                    color: text === "Sent"      ?  currTheme.orange :
                           text === "Pending"   ?  currTheme.darkYellow :
                           text === "Error"     ||
                           text === "Declined"  ?  currTheme.red :
                           text === "Received"  ?  currTheme.lightGreen :
                           text === "Queued"    ?  currTheme.textColorLightBlue :
                           text === "Exchange"  ?  currTheme.coral :
                           text === "Vote"      ?  currTheme.сrayola :
                           text === "Unknown"   ?  currTheme.mainButtonColorNormal0 :
                                                   currTheme.white

                    font:  mainFont.dapFont.regular14
                }


                // Balance
                //  Token currency

                Item
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    DapBigText
                    {
                        id: lblAmount
                        height: 20
                        property string sign: direction === "to"? "- " : "+ "
                        anchors.right: copyBtn.left
                        anchors.rightMargin: 4
                        anchors.top: parent.top
                        anchors.topMargin: !x_lblAmount.visible ? 16 : 4
                        anchors.left: parent.left
                        textFont: mainFont.dapFont.regular14
                        fullText: sign + value + " " + token
                        horizontalAlign: Text.AlignRight
                    }

                    DapCopyButton {
                        id: copyBtn
                        height: 16
                        popupText: qsTr("Value copied")
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: !x_lblAmount.visible ? 18 : 6
                        onCopyClicked: {
                            clipboard.setText(value)
                        }
                    }


                    DapBigText
                    {
                        id: x_lblAmount
                        visible: x_value !== ""
                        height: 20
                        property string sign: x_direction === "to"? "- " : "+ "
                        anchors.right: copyBtn.left
                        anchors.rightMargin: 4
                        anchors.left: parent.left
                        anchors.topMargin: 0
                        anchors.top: lblAmount.bottom
                        textFont: mainFont.dapFont.regular14
                        fullText: sign + x_value + " " + x_token
                        horizontalAlign: Text.AlignRight
                    }

                    DapCopyButton
                    {
                        id: copyBtn2
                        height: 16
                        visible: x_lblAmount.visible
                        popupText: qsTr("Value copied")
                        anchors.right: parent.right
                        anchors.top: copyBtn.bottom
                        anchors.topMargin: 4
                        onCopyClicked: {
                            clipboard.setText(x_value)
                        }
                    }
                }

                Item{
                    Layout.minimumWidth: 142
                    Layout.fillHeight: true

                    DapBigText
                    {
                        id: lblFee
                        anchors.fill: parent
                        textFont: mainFont.dapFont.regular12
                        textColor: currTheme.gray
                        fullText: qsTr("fee: ") + fee + " " + fee_token
                        horizontalAlign: Text.AlignRight
                    }
                }

                DapToolTipInfo{
                    property string normalIcon: textSatus.text === "Queued" ? "qrc:/Resources/"+ pathTheme +"/icons/other/delete_button.svg"
                                                                        : "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"

                    property string hoverIcon: textSatus.text === "Queued" ? "qrc:/Resources/"+ pathTheme +"/icons/other/delete_button_hover.svg"
                                                                        : "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"

                    property string disabledIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"

                    id: explorerIcon
                    Layout.preferredHeight: textSatus.text === "Queued" ? 16 : 18
                    Layout.preferredWidth: textSatus.text === "Queued" ? 16 : 18
                    contentText: textSatus.text === "Queued" ? qsTr("Remove") : qsTr("Explorer")

                    toolTip.width: text.implicitWidth + 16
                    toolTip.x: -toolTip.width/2 + 8

                    enabled: textSatus.text === "Queued" ? true : tx_status === "DECLINED" || tx_status === "PROCESSING" ? false :
                              network !== "private"?
                              true : false

                    indicatorSrcNormal: textSatus.text === "Queued" ? normalIcon : tx_status === "DECLINED"  || tx_status === "PROCESSING" ? disabledIcon :
                                            network !== "private"?
                                            normalIcon : disabledIcon

                    indicatorSrcHover: textSatus.text === "Queued" ? hoverIcon : tx_status === "DECLINED"   || tx_status === "PROCESSING" ? disabledIcon :
                                            network !== "private"?
                                            hoverIcon : disabledIcon
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: !(copyBtn.mouseArea.containsMouse || copyBtn2.mouseArea.containsMouse)
                onClicked: {
                    if(explorerIcon.mouseArea.containsMouse && explorerIcon.enabled)
                        if(textSatus.text === "Queued")
                        {
                            var stringLists = [[network, wallet_name, date_to_secs]]
                                dapServiceController.tryRemoveTransactions(stringLists)
                        }
                        else
                        {
                            Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)
                        }
                    else if(logicExplorer.selectTxIndex !== index)
                    {
                        logicExplorer.initDetailsModel(model)
                        navigator.txInfo()
                    }
                }
            }

            //  Underline
            Rectangle
            {
                x: 16
                y: parent.height - 1
                width: parent.width - 32
                height: 1 
                color: currTheme.mainBackground
            }
        }
    }

    function getStatusName(tx_status, status)
    {
        if (tx_status !== "ACCEPTED")
            return qsTr("Declined")
        if (status === "Sent")
            return qsTr("Sent")
        if (status === "Error")
            return qsTr("Error")
        if (status === "Declined")
            return qsTr("Declined")
        if (status === "Received")
            return qsTr("Received")
        return status
    }

    function getStatusColor(tx_status, status)
    {
        if (tx_status !== "ACCEPTED" || status === "Error")
            return currTheme.red
        if (status === "Sent")
            return currTheme.orange
        if (status === "Received")
            return currTheme.lightGreen
        return currTheme.white
    }
}
