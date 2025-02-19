import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../controls"

Page
{
    id: historyScreen
    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapListViewHistory: listViewHistory
    property bool isHistoryRequest: false
    property int countTransaction: modelHistory.getCount()

    background: Rectangle{color: currTheme.mainBackground}
    hoverEnabled: true

    ListModel {
        id: periodModel
        ListElement {
            name: qsTr("All time")
        }
        ListElement {
            name: qsTr("Today")
        }
        ListElement {
            name: qsTr("Yesterday")
        }
        ListElement {
            name: qsTr("Last week")
        }
    }

    Text{
        id: noTransactionsText
        visible: !countTransaction && isHistoryRequest

        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        color: currTheme.gray
        text: qsTr("There are no transactions yet")
        font: mainFont.dapFont.medium14
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        DapHistoryTopPanel
        {
            id: historyTopPanel

            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            height: 32

            onSelected:
            {
//                console.log("modelHistory.count", modelHistory.count)
            }
        }

        DefaultComboBox
        {
            id: periodComboBox
            z: 10
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40

            font: mainFont.dapFont.regular14

            backgroundColor: popupVisible? currTheme.secondaryBackground : "transparent"
            indicatorSource: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_chevronDownNormal.svg"

            rightMarginIndicator: 4
            model: periodModel


            onItemSelected:
            {
                var data = [periodComboBox.currentText, false]
                modelHistory.setCurrentPeriod(data)
            }
        }

        Item{Layout.fillHeight: true; visible: !isHistoryRequest}

        ListView
        {
            id: listViewHistory
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: modelHistory
            clip: true

            visible: isHistoryRequest

            delegate: delegateToken

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateDate

            currentIndex: logicExplorer.selectTxIndex


            ScrollBar.vertical: ScrollBar{
                interactive: true
                bottomPadding: mainMenu.height
            }
        }
    }

    AnimatedImage{
        visible: !isHistoryRequest
        source: "qrc:/walletSkin/Resources/BlackTheme/icons/Loader.gif"

        width: 240
        height: 240

        mipmap: true

        playing: visible

        anchors.horizontalCenter: parent.horizontalCenter

        y: historyScreen.height/3

        Text{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 42

            text: qsTr("History loading...")
            color: currTheme.gray
            font: mainFont.dapFont.medium14
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component
    {
        id: delegateDate

        Item{
            property date payDate: new Date(Date.parse(section))
            height: 60
            width: listViewHistory.width
            x: 0
            Item{
                anchors.fill: parent
                anchors.rightMargin: 16
                anchors.leftMargin: 16
                anchors.topMargin: 20
                anchors.bottomMargin: 10

                //background
                Rectangle
                {
                    id: itemRect
                    anchors.fill: parent
                    color: currTheme.thirdBackground
                    radius: 12
                }

                DropShadow {
                    anchors.fill: itemRect
                    source: itemRect
                    color: currTheme.mainBlockShadowDrop
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 0
                    samples: 0
                    opacity: 0.49
                    fast: true
                    cached: true
                }
                InnerShadow {
                    id: shadow
                    anchors.fill: itemRect
                    radius: 5
                    samples: 10
                    horizontalOffset: 3
                    verticalOffset: 3
                    color: currTheme.shadowMain
                    opacity: 0.33
                    source: itemRect
                }

                Text
                {
                    anchors.fill: parent
                    anchors.topMargin: 1
                    anchors.leftMargin: 14
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    color: currTheme.white
                    text: logicExplorer.getDateString(payDate)
                    font: mainFont.dapFont.medium12
                }
            }
        }
    }

    Component
    {
        id: delegateToken

        Item{
            property string date: date

            property bool lastItem: index === modelHistory.getCount() - 1

            width: listViewHistory.width
            x: 0
            height: lastItem ? 150 : 50

            Rectangle
            {
                anchors.fill: parent
                anchors.rightMargin: 16
                anchors.leftMargin: 16
                anchors.bottomMargin: lastItem ?
                    100 : 0

                color: logicExplorer.selectTxIndex === index? currTheme.grayDark : "transparent"

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16
                    spacing: 12

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 3

                        Text
                        {
                            Layout.fillWidth: true
                            text: network
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            text: logicExplorer.getStatusName(tx_status, status)
                            color: logicExplorer.getStatusColor(tx_status, status)
                            font: mainFont.dapFont.regular12
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 0

                        DapBigText
                        {
                            property string sign: direction === "to"? "- " : "+ "
                            Layout.fillWidth: true
                            height: 20
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + value + " " + token
                            textFont: mainFont.dapFont.regular14

                            width: 160
                        }
                        DapBigText
                        {
                            visible: fee !== ""
                            Layout.fillWidth: true
                            height: 15
                            textColor: currTheme.gray
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("fee: ") + fee + " " + token
                            textFont: mainFont.dapFont.regular12

                            width: 160
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
//                    anchors.rightMargin: 50
                    onClicked: {
                            logicExplorer.initDetailsModel(model)
//                            detailsModel
                            dapBottomPopup.show("qrc:/walletSkin/forms/History/TxInfo.qml")                        
                    }
                }

                Rectangle
                {
                    height: 1
                    color: currTheme.secondaryBackground
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    Connections{
        target: dapBottomPopup
        function onClosed()
        {
            logicExplorer.selectTxIndex = -1
        }
    }

    Component.onCompleted:
    {
        today = new Date()
        yesterday = new Date(new Date().setDate(new Date().getDate()-1))

        isHistoryRequest = modelHistory.getCount() > 0
        countTransaction = modelHistory.getCount()
    }

    Connections
    {
        target: modelHistory
        function onCountChanged()
        {
            isHistoryRequest = true
            countTransaction = modelHistory.getCount()
            noTransactionsText.visible = !countTransaction
        }
    }

    Connections
    {
        target: txExplorerModule
        function onUpdateHistoryModel()
        {
            isHistoryRequest = true
            updateSize("history")
        }
    }

    Connections
    {
        target: walletModule
        function onCurrentWalletChanged()
        {
            isHistoryRequest = false
        }
    }
}
