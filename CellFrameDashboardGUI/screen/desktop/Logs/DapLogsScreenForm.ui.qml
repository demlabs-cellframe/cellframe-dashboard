import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{

    id: logsBoard
    ///@detalis dapLogsListView Indicates an active item.
    property alias dapLogsListViewIndex: dapLogsList.currentIndex
    ///@detalis dapLogsListView Log list widget.
    property alias dapLogsListView: dapLogsList
    property bool isModelLoaded: false

    anchors
    {
        fill: parent
        topMargin: 24 * pt
        rightMargin: 24 * pt
        leftMargin: 24 * pt
        bottomMargin: 20 * pt
    }
    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
            {
                anchors.fill: parent

                // Title
                Item
                {
                    id: consoleTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 38 * pt
                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 15 * pt
                        anchors.topMargin: 10 * pt
                        anchors.bottomMargin: 10 * pt

                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Node data logs")
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                        color: currTheme.textColor
                    }
                }

                ListView
                {
                    id: dapLogsList
                    anchors.top: consoleTitle.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true
                    model: dapLogsModel
                    delegate: delegateLogs
                    section.property: "date"
                    section.criteria: ViewSection.FullString
                    section.delegate: delegateLogsHeader

                    highlight: Rectangle{color: currTheme.placeHolderTextColor; opacity: 0.12}
                    highlightMoveDuration: 0

                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }
                }

                DapBusyIndicator
                {
                    x: parent.width / 2
                    y: parent.height / 2
                    busyPointNum: 8
                    busyPointRounding: 50
                    busyPointWidth: 12
                    busyPointHeight: 12
                    busyPointMinScale: 1.0
                    busyPointMaxScale: 1.0
                    busyIndicatorWidth: 40
                    busyIndicatorHeight: 40
                    busyIndicatorDelay: 125
                    busyIndicatorDarkColor: "#d51f5d"
                    busyIndicatorLightColor: "#FFFFFF"
                    running: !isModelLoaded
                }
            }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
