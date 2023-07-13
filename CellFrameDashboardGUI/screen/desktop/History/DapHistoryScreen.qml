import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

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
            ListView
            {
                id: listViewHistory
                anchors.fill: parent
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

                // Network name
                Text
                {
                    id: textNetworkName
                    Layout.minimumWidth: 190
                    text: network
                    color: currTheme.white
                    font:  mainFont.dapFont.regular14
                    Layout.alignment: Qt.AlignLeft
                }

                // Status
                Text
                {
                    id: textSatus
                    Layout.minimumWidth: 80
                    text: tx_status === "ACCEPTED" || tx_status === "PROCESSING" ? status : "Declined"
                    color: text === "Sent" ?      currTheme.orange :
                           text === "Pending" ?   currTheme.neon :
                           text === "Error" ||
                           text === "Declined" ?  currTheme.red :
                           text === "Received"  ? currTheme.lightGreen :
                                                  currTheme.white

                    font:  mainFont.dapFont.regular14
                }


                // Balance
                //  Token currency

                Item{
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    DapBigText
                    {
                        id: lblAmount
                        property string sign: direction === "to"? "- " : "+ "
                        anchors.fill: parent
                        textFont: mainFont.dapFont.regular14
                        fullText: sign + value + " " + token
                        horizontalAlign: Text.AlignRight
                    }
                }

                Item{
//                    visible: fee !== "0.0"
                    Layout.minimumWidth: 142
                    Layout.fillHeight: true

                    DapBigText
                    {
                        id: lblFee
                        anchors.fill: parent
                        textFont: mainFont.dapFont.regular12
                        textColor: currTheme.gray
                        fullText: qsTr("fee: ") + fee + " " + token
                        horizontalAlign: Text.AlignRight
                    }
                }

                DapToolTipInfo{
                    property string normalIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"
                    property string hoverIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"
                    property string disabledIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"
                    id: explorerIcon
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: 18
                    Layout.leftMargin: 14
                    contentText: qsTr("Explorer")

                    toolTip.width: text.implicitWidth + 16
                    toolTip.x: -toolTip.width/2 + 8

                    enabled: tx_status === "DECLINED" || tx_status === "PROCESSING" ? false :
                              network !== "private"?
                              true : false

                    indicatorSrcNormal: tx_status === "DECLINED"  || tx_status === "PROCESSING" ? disabledIcon :
                                            network !== "private"?
                                            normalIcon : disabledIcon

                    indicatorSrcHover: tx_status === "DECLINED"   || tx_status === "PROCESSING" ? disabledIcon :
                                            network !== "private"?
                                            hoverIcon : disabledIcon
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(explorerIcon.mouseArea.containsMouse && explorerIcon.enabled)
                        Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)
                    else if(logicExplorer.selectTxIndex !== index)
                    {
                        logicExplorer.selectTxIndex = index
                        logicExplorer.initDetailsModel()
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
}
