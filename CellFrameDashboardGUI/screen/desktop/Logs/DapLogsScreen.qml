import QtQuick.Window 2.2
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../controls"
import "qrc:/widgets"
import "../../"
import "qrc:/resources/JS/TimeFunctions.js" as TimeFunction

Page
{
    id:dapLogsScreenForm

    ///@detalis firstMarginList First indent in the delegate to the first word.
    property int firstMarginList: 16 
    ///@detalis secondMarginList Second indent between the first and second word.
    property int secondMarginList: 18 
    ///@detalis thirdMarginList Third indent between the second and third word and the following.
    property int thirdMarginList: 40 
    ///@detalis fifthMarginList Fifth indent between the second and third word and the following.
    property int fifthMarginList: 20 
    ///@detalis Font color.
    property string fontColor: "#070023"

    ///@detalis dapLogsListView Indicates an active item.
    property alias dapLogsListViewIndex: dapLogsList.currentIndex
    ///@detalis dapLogsListView Log list widget.
    property alias dapLogsListView: dapLogsList
    property bool isModelLoaded: false

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0
                // Title
                Item
                {
                    Layout.fillWidth: true
                    height: 42

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter

                        font: mainFont.dapFont.bold14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Node data logs")
                    }
                }

                ListView
                {
                    id: dapLogsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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

//        DapBusyIndicator
//        {
//            x: parent.width / 2
//            y: parent.height / 2
//            busyPointNum: 8
//            busyPointRounding: 50
//            busyPointWidth: 12
//            busyPointHeight: 12
//            busyPointMinScale: 1.0
//            busyPointMaxScale: 1.0
//            busyIndicatorWidth: 40
//            busyIndicatorHeight: 40
//            busyIndicatorDelay: 125
//            busyIndicatorDarkColor: currTheme.hilightColorComboBox
//            busyIndicatorLightColor: currTheme.backgroundElements
//            running: !isModelLoaded
//        }

        DapLoadIndicator {
//            x: parent.width / 2
//            y: parent.height / 2

            anchors.centerIn: parent

            indicatorSize: 64
            countElements: 8
            elementSize: 10

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
        function onLogUpdated(logs)
        {
//            dapLogsList.enabled = false
            isModelLoaded = false;
            isModelLoaded = updateLogsModel(logs);
//            dapLogsListView.currentIndex = -1
//            dapLogsListView.update()
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
            height: 30 
            color: currTheme.backgroundMainScreen
            z:10

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Qt.AlignVCenter
                font:  mainFont.dapFont.medium12
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
            height: row.implicitHeight < 36 ? 50 : row.implicitHeight + 27

            //Event container
            RowLayout{
                id: row
                anchors.fill: parent
                anchors.topMargin: 14 
                anchors.bottomMargin: 13 
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 0

                Text
                {
                    id: typeLog
                    Layout.minimumWidth: 34
                    Layout.maximumWidth: 34
                    Layout.alignment: Qt.AlignLeft
//                    width: 34
                    verticalAlignment: Qt.AlignVCenter
                    font:  mainFont.dapFont.regular14
                    color: type === "WRN" ? currTheme.textColorYellow :
                           type === "ERR" ? currTheme.textColorRed :
                           type === "INF" || type === " * " ?
                           currTheme.textColorLightBlue : currTheme.textColor
                    text: type
                }

                Text
                {
                    id: textLog
//                    Layout.preferredWidth: 280
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 30
                    verticalAlignment: Qt.AlignVCenter
                    wrapMode: Text.WrapAnywhere
                    font:  mainFont.dapFont.regular14
                    color: currTheme.textColor
                    text: info
                }

                Text
                {
                    id: fileLog
                    Layout.minimumWidth: 200
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 40
                    verticalAlignment: Qt.AlignVCenter
                    font:  mainFont.dapFont.regular13
                    color: currTheme.textColor
                    text: file
                }

                Text
                {
                    id: timeLog
                    Layout.minimumWidth: 50
                    Layout.maximumWidth: 50
                    Layout.leftMargin: 20
                    Layout.alignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font:  mainFont.dapFont.regular14
                    color: currTheme.textColor
                    text: time
                }
            }

            //Underline bar
            Rectangle
            {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
//                anchors.topMargin: 13 
                height: 1 
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
                var info = arrLogString[4]
                if(info[0] === " ")
                    info = info.substring(1)

                dapLogsModel.append({"type": arrLogString[2],
                                     "info": info,
                                     "file": arrLogString[3],
                                     "time": TimeFunction.getTime(stringTime),
                                     "date": TimeFunction.getDay(stringTime, privateDate),
                                     "momentTime": stringTime});
            }
        }
        return true
    }
}
