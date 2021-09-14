import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapLogsScreenForm
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
            isModelLoaded = false;
            logWorkerScript.msg = {'stringList' : logs, 'model': dapLogsModel};

            logWorkerScript.sendMessage(logWorkerScript.msg);
        }
            //fillModel(logs);
    }

    //The Component Header
    Component
    {
        id:delegateLogsHeader

        Rectangle
        {
            height: 20 * pt
            width: dapLogsListView.width
            color: "#908D9D"

            Text
            {
                anchors.fill: parent
                anchors.topMargin: 1 * pt
                anchors.bottomMargin: 1 * pt
                anchors.leftMargin: firstMarginList
                color: "#FFFFFF"
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
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
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
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
                    clip: true
                    Text
                    {
                        id: textLog
                        anchors.fill: parent
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
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
                    clip: true
                    Text
                    {
                        id: fileLog
                        anchors.fill: parent
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
                    clip: true
                    Text
                    {
                        id: timeLog
                        anchors.fill: parent
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
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

    WorkerScript
    {
        id: logWorkerScript
        source: "JS/DapLogScreenScripts.js"
        property var msg
        onMessage: isModelLoaded = messageObject.result
    }


}
