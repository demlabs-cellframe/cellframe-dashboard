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
        color: currTheme.backgroundMainScreen
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
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
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

    Component.onCompleted:
    {
        today = new Date()
        yesterday = new Date(new Date().setDate(new Date().getDate()-1))
    }

    Component
    {
        id: delegateDate
        Rectangle
        {
            height: 30
            width: parent.width
            color: currTheme.backgroundMainScreen

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 
                anchors.rightMargin: 16 
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.textColor
                text: logicExplorer.getDateString(payDate)
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
            color: listViewHistory.currentIndex === index? "#474B53" : currTheme.backgroundElements

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
                    color: currTheme.textColor
                    font:  mainFont.dapFont.regular14
                    Layout.alignment: Qt.AlignLeft
                }

                // Status
                Text
                {
                    id: textSatus
                    Layout.minimumWidth: 80
                    text: tx_status === "ACCEPTED" ? status : "Declined"
                    color: text === "Sent" ?      currTheme.textColorYellow :
                           text === "Error" ||
                           text === "Declined" ?  currTheme.textColorRed :
                           text === "Received"  ? currTheme.textColorLightGreen :
                                                  currTheme.textColor

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
                        property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
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
                        textColor: currTheme.textColorGrayTwo
                        fullText: qsTr("fee: ") + fee + " " + token
                        horizontalAlign: Text.AlignRight
                    }
                }

                Item{
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 32

                    Image
                    {
                        anchors.centerIn: parent

                        mipmap: true

                        visible: network === "subzero" || network === "Backbone" || network === "mileena" || network === "kelvpn-minkowski"  ? true : false

                        source: mouseArea.containsMouse? "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg" :
                                                         "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"

                        MouseArea
                        {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }

                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(mouseArea.containsMouse)
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
                color: currTheme.lineSeparatorColor
            }
        }
    }
}
