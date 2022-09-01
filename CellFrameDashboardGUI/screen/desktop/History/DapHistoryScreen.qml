import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
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
            color: currTheme.backgroundElements

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
                    Layout.minimumWidth: 120 
                    text: network
                    color: currTheme.textColor
                    font:  mainFont.dapFont.regular14
                    Layout.alignment: Qt.AlignLeft
                }

                // Token name
                Text
                {
                    id: textTokenName
                    Layout.minimumWidth: 100 
                    text: name
                    color: currTheme.textColor
                    font:  mainFont.dapFont.regular14
                    Layout.alignment: Qt.AlignLeft
                }

                // Status
                Text
                {
                    id: textSatus
                    Layout.minimumWidth: 100 
                    text: status
                    color: status === "Sent" ? "#FFCD44" : status === "Error" ? "#FF5F5F" : status === "Received"  ? "#CAFC33" : "#FFFFFF"
                    font:  mainFont.dapFont.regular14
                }


                // Balance
                //  Token currency
                Text
                {
                    id: lblAmount
                    Layout.fillWidth: true
                    property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                    text: sign + amount + " " + name
                    color: currTheme.textColor
                    font:  mainFont.dapFont.regular14
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideMiddle

                    ToolTip
                    {
                        id:toolTip
                        visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
                        text: parent.text
                        scale: mainWindow.scale

                        contentItem: Text {
                                text: toolTip.text
                                font: mainFont.dapFont.regular14
                                color: currTheme.textColor
                            }
                        background: Rectangle{color:currTheme.backgroundPanel}
                    }
                    MouseArea
                    {
                        id:area
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Image
                {
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

//                    sourceSize: Qt.size(20,20)
                    mipmap: true
//                    innerWidth: 20
//                    innerHeight: 20

                    visible: network === "subzero" || network === "Backbone" || network === "mileena" || network === "kelvpn-minkowski"  ? true : false

                    source: mouseArea.containsMouse? "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg" :
                                                     "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"

                    MouseArea
                    {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.openUrlExternally("https://test-explorer.cellframe.net/transaction/" + hash)
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
