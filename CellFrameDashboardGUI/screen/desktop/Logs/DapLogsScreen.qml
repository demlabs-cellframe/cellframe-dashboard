import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick 2.0
import QtGraphicalEffects 1.0

DapLogsScreenForm
{
    ///@detalis firstMarginList First indent in the delegate to the first word.
    property int firstMarginList: 16 * pt
    ///@detalis secondMarginList Second indent between the first and second word.
    property int secondMarginList: 18 * pt
    ///@detalis thirdMarginList Third indent between the second and third word and the following.
    property int thirdMarginList: 40 * pt
    ///@detalis fifthMarginList Fifth indent between the second and third word and the following.
    property int fifthMarginList: 20 * pt
    ///@detalis fontSizeList Font size delegate.
    property int fontSizeList: 16 * pt
    ///@detalis fontSizeHeader Font size header.
    property int fontSizeHeader: 12 * pt
    ///@detalis fontFamily Font family.
    property string fontFamily: "Roboto"
    ///@detalis Font color.
    property string fontColor: "#070023"

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

    //Creates a list model for the example
    Component.onCompleted: {
        dapLogsListViewIndex = -1;
        privateDate.today = new Date();
        privateDate.todayDay = privateDate.today.getDate();
        privateDate.todayMonth = privateDate.today.getMonth();
        privateDate.todayYear = privateDate.today.getFullYear();
        var timeString = new Date();
        var day = new Date(86400);
        var count = 1000
        for (var i = 0; i < count; i++)
        {
            var momentTime = timeString/1000 - (day/6) * i;
            var momentDay = getDay(momentTime);
            dapLogsModel.append({"type":"DBG"+i, "info":"Add problems"+i, "file":"dup_chein"+i, "time":getTime(momentTime),
                                    "date":getDay(momentTime)});
        }
    }

    ListModel
    {
        id:dapLogsModel
    }
    //The Component Header
    Component
    {
        id:delegateLogsHeader
        Rectangle
        {
            height: 30 * pt
            width: dapLogsListView.width
            color: "#908D9D"

            Text
            {
                anchors.fill: parent
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: firstMarginList
                color: "#FFFFFF"
                font.pixelSize: fontSizeHeader
                font.family: fontFamily
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
            height: 60 * pt
            width: dapLogsListView.width

            color:
            {
                if(dapLogsListViewIndex === index)
                {
                    return "#FAE5ED";
                }
                else
                {
                    return "#FFFFFF";
                }
            }

            //Event container
            Rectangle
            {
                anchors.fill: parent
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 20 * pt
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
                    Text
                    {
                        id: typeLog
                        anchors.fill: parent
                        font.pixelSize: fontSizeList
                        font.family: fontFamily
                        color: fontColor
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
                    Text
                    {
                        id: textLog
                        anchors.fill: parent
                        font.pixelSize: fontSizeList
                        font.family: fontFamily
                        color: fontColor
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
                    width: 326 * pt
                    color: parent.color
                    Text
                    {
                        id: fileLog
                        anchors.fill: parent
                        font.pixelSize: 14 * pt
                        font.family: fontFamily
                        color: fontColor
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
                    Text
                    {
                        id: timeLog
                        anchors.fill: parent
                        font.pixelSize: fontSizeList
                        font.family: fontFamily
                        color: fontColor
                        text: time
                    }
                }
            }

            //Underline bar
            Rectangle
            {
                anchors.bottom: parent.bottom
                color: "#E3E2E6"
                width: parent.width
                height: 1 * pt
                visible:
                {
                    if(dapLogsListViewIndex === index | dapLogsListViewIndex - 1 === index)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
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

    //This function converts the string representation of time to the Date format
    function parceTime(thisTime)
    {
        var aDate = thisTime.split('-');
        var aDay = aDate[0].split('/');
        var aTime = aDate[1].split(':');
        privateDate.stringTime = new Date(20+aDay[2], aDay[0] - 1, aDay[1], aTime[0], aTime[1], aTime[2]);
    }

    //Returns the time in the correct form for the delegate
    function getTime(thisTime)
    {
        var tmpTime = new Date(thisTime * 1000)
        var thisHour = tmpTime.getHours();
        var thisMinute = tmpTime.getMinutes();
        var thisSecond = tmpTime.getSeconds();
        if(thisMinute<10) thisMinute = '0' + thisMinute;
        if(thisSecond<10) thisSecond = '0' + thisSecond;
        return thisHour + ':' + thisMinute + ':' + thisSecond;
    }

    //Returns the time in the correct form for the header
    function getDay(thisTime)
    {
        var monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September",
                          "October", "November", "December"];
        var tmpDate = new Date(thisTime*1000);
        var thisMonth = tmpDate.getMonth();
        var thisDay = tmpDate.getDate();
        var thisYear = tmpDate.getFullYear();

        if(thisYear === privateDate.todayYear)
        {
            if(thisMonth === privateDate.todayMonth)
            {
                switch(thisDay){
                case(privateDate.todayDay): return"Today";
                case(privateDate.todayDay-1): return"Yesterday";
                default: return monthArray[thisMonth] + ', ' + thisDay;
                }
            }
            else
                return monthArray[thisMonth] + ', ' + thisDay;
        }
        else
            return monthArray[thisMonth] + ', ' + thisDay + ', ' + thisYear;
    }
}
