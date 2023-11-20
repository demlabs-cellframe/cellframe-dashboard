import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"

Page
{
    property alias dapModelHistoryConsole: modelHistoryConsole
    ///@detalis commandQuery Command for history.
    property string commandQuery
    ///@detalis historyQuery Text of command from the command history.
    property string historyQuery
    ///@detalis historyQueryIndex Index of command from the command history.
    property string historyQueryIndex
    ///@detalis historySize Num of history command at right panel.
    property int historySize: 20

    ListModel
    {
        id: modelHistoryConsole
    }

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 18 * pt

        Item
        {
            Layout.fillWidth: true
            height: 40

            Text
            {
                id: textHeader
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ListView
        {
            id: listViewHistoryConsole
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 20
            model: modelHistoryConsole
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
                Item
                {
                    anchors.leftMargin: 5 
                    anchors.rightMargin: 5
                    width: listViewHistoryConsole.width
                    implicitHeight: textCommand.contentHeight + 6 + textDateTime.contentHeight

                    Text
                    {
                        anchors.fill: parent
                        anchors.rightMargin: 16
                        anchors.leftMargin: 16 
                        verticalAlignment: Qt.AlignTop

                        id: textCommand
                        text: query
                        color: currTheme.white

                        wrapMode: Text.Wrap
                        font.family: "Quicksand"
                        font.pixelSize: 13

                        //For the automatic sending selected command from history
                        MouseArea
                        {
                            id: historyQueryMouseArea
                            anchors.fill: textCommand
                            onDoubleClicked: historyQueryIndex = index
                        }
                    }
                    Text
                    {
                        anchors.fill: parent
                        anchors.rightMargin: 16
                        anchors.leftMargin: 16
                        verticalAlignment: Qt.AlignBottom

                        id: textDateTime
                        text: datetime
                        color: "#B2B2B2"

                        font.family: "Quicksand"
                        font.pixelSize: 11
                    }
                }
            //It allows to see last element of list by default
            currentIndex: count - 1
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.ApplyRange
        }
    }

    Component.onCompleted:
    {
        logicMainApp.requestToService("DapGetHistoryExecutedCmdCommand", historySize);
    }

    // Parsing query and time from history
    function parsingTime(str, mode) {
        // mode 0 - return boolean result
        // mode 1 - return query
        // mode 2 - return time
        var regex = /\[\d{2}\.\d{2}\.\d{2}\s-\s\d{2}:\d{2}:\d{2}\]/
        var match = regex.exec(str)

        if (match !== null) {
            switch (mode) {
            case 0:
                return true
            case 1:
                return str.substring(22, str.length)
            case 2:
                return str.substring(1, 20)
            }
        } else {
            switch (mode) {
            case 0:
                return false
            case 1:
                return str
            case 2:
                return qsTr("undefined")
            }
        }
    }

    function currentTime() {
        return new Date().toLocaleString(Qt.locale(), "dd.MM.yy - hh:mm:ss")
    }

    //Returns true if item 'someElement' is already exist at list 'someModel'.
    function findElement(someModel, someElement)
    {
        for(var i = 0; i < someModel.count; ++i)
            if(someModel.get(i).query === someElement.query)
            {
                modelHistoryConsole.remove(i);
                return true;
            }

        return false;
    }

    onCommandQueryChanged:
    {
        var query_str = parsingTime(commandQuery, 1)
        var time_str = parsingTime(commandQuery, 2)

        //Adding only new element
        if(!findElement(modelHistoryConsole, {query: query_str}))
        {
            if(commandQuery !== "")
                modelHistoryConsole.insert(0, {query: query_str, datetime: time_str});
        }
        else
            modelHistoryConsole.insert(0, {query: query_str, datetime: time_str});

        //History is limited by historySize and realized as FIFO
        if(historySize < modelHistoryConsole.count)
            modelHistoryConsole.remove(modelHistoryConsole.count-1);

        listViewHistoryConsole.positionViewAtBeginning()
    }

    //Handler for the doubleClick on right history panel
    onHistoryQueryIndexChanged:
    {
        if(historyQueryIndex > -1)
        {
            historyQuery = "[" + currentTime() + "] " + modelHistoryConsole.get(historyQueryIndex).query;
            historyQueryIndex = -1;
            historyQuery = ""
        }
    }
}
