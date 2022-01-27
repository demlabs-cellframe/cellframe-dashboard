import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/widgets"
import "../../"
import "qrc:/resources/JS/TimeFunctions.js" as TimeFunction

DapAbstractScreen
{
    id:dapLogsScreenForm

    ///@detalis firstMarginList First indent in the delegate to the first word.
    property int firstMarginList: 16 * pt
    ///@detalis secondMarginList Second indent between the first and second word.
    property int secondMarginList: 18 * pt
    ///@detalis thirdMarginList Third indent between the second and third word and the following.
    property int thirdMarginList: 40 * pt
    ///@detalis fifthMarginList Fifth indent between the second and third word and the following.
    property int fifthMarginList: 20 * pt
    ///@detalis Font color.
    property string fontColor: "#070023"

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
                    cacheBuffer: 15000
                    highlight: Rectangle{color: currTheme.placeHolderTextColor; opacity: 0.12}
                    highlightMoveDuration: 0

                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }
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

    //Creates a list model for the example
    Component.onCompleted:
    {
        dapLogsListViewIndex = -1;
        privateDate.today = new Date();
        privateDate.todayDay = privateDate.today.getDate();
        privateDate.todayMonth = privateDate.today.getMonth();
        privateDate.todayYear = privateDate.today.getFullYear();
        var timeString = new Date();
        var day = new Date(86400);
    }

    //Slot for updating data in the model. The signal comes from C++.
    Connections
    {
        target: dapServiceController
        onLogUpdated:
        {
//            dapLogsList.enabled = false
            isModelLoaded = false;
            isModelLoaded = updateLogsModel(logs);
            dapLogsListView.currentIndex = -1
            dapLogsListView.update()
//            dapLogsList.enabled = true
        }
    }

    //The Component Header
    Component
    {
        id:delegateLogsHeader

        Rectangle
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30 * pt
            color: currTheme.backgroundMainScreen
            z:10

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 15 * pt
                verticalAlignment: Qt.AlignVCenter
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                color: currTheme.textColor
                text: section
            }
        }
    }


    //The component delegate
    Component
    {
        id:delegateLogs

        //Frame delegate
        Rectangle
        {
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"
//            height: 70 * pt
            height: textLog.implicitHeight < 60 * pt ? 60 * pt : textLog.implicitHeight + 20 * pt

            //Event container
            Rectangle
            {
                id: container
                anchors.fill: parent
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                anchors.leftMargin: firstMarginList
                anchors.rightMargin: fifthMarginList
                color: parent.color

                //Frame type log
                Rectangle
                {
                    id:frameTypeLog
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 43 * pt
                    color: parent.color
                    clip: true
                    Text
                    {
                        id: typeLog
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        color: currTheme.textColor
                        text: type
                    }
                }

                // Frame text log
                Rectangle
                {
                    id:frameTextLog
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: frameTypeLog.right
                    anchors.leftMargin: secondMarginList
                    anchors.right: frameFileLog.left
                    anchors.rightMargin: thirdMarginList
                    color: parent.color
                    clip: true
                    Text
                    {
                        id: textLog
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        wrapMode: Text.Wrap
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        color: currTheme.textColor
                        text: info
                    }
                }

                //Frame file log
                Rectangle
                {
                    id: frameFileLog
                    anchors.right: frameTimeLog.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: thirdMarginList
                    width: 200 * pt
                    color: parent.color
                    clip: true
                    Text
                    {
                        id: fileLog
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                        color: currTheme.textColor
                        text: file
                    }
                }

                //Frame time log
                Rectangle
                {
                    id: frameTimeLog
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: 62 * pt
                    color: parent.color
                    clip: true
                    Text
                    {
                        id: timeLog
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        color: currTheme.textColor
                        text: time
                    }
                }
            }

            //Underline bar
            Rectangle
            {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: 2 * pt
                color: currTheme.lineSeparatorColor
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                   dapLogsListViewIndex = index;
                }
            }
        }
    }

    ///In this block, the properties are only auxiliary for internal use.
    QtObject
    {
        id: privateDate
        //Day
        property int day: 86400
        //Current time
        property var today
        property var todayDay
        property var todayMonth
        property var todayYear
        property var stringTime
    }

    function updateLogsModel(logList)
    {
        dapLogsModel.clear();
        var count = Object.keys(logList).length
        console.log(count);
        var thisDay = new Date();
        var privateDate = {'today' : thisDay,
                            'todayDay': thisDay.getDate(),
                            'todayMonth': thisDay.getMonth(),
                            'todayYear': thisDay.getFullYear()};

        for (var ind = count-1; ind >= 0; ind--)
        {
            var arrLogString = TimeFunction.parceStringFromLog(logList[ind]);
            var stringTime = TimeFunction.parceTime(arrLogString[1]);

            if(stringTime !== "error" && arrLogString[2] !== "")
            {
                dapLogsModel.append({"type": arrLogString[2],
                                     "info": arrLogString[4],
                                     "file": arrLogString[3],
                                     "time": TimeFunction.getTime(stringTime),
                                     "date": TimeFunction.getDay(stringTime, privateDate),
                                     "momentTime": stringTime});
            }
        }
        return true
    }
}
