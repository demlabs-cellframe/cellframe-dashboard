import QtQuick.Window 2.2
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../controls"
import "qrc:/widgets"
import "../../"
import "../History/logic"
import qmlclipboard 1.0

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
    property bool isModelLoaded: true

//    property date today: new Date()
//    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))
//    property date today: new Date(new Date().setDate(new Date().getDate()-1))
//    property date yesterday: new Date(new Date().setDate(new Date().getDate()-2))

    QMLClipboard{
        id: clipboard
    }

//    Timer {
//        id: updateTimer
//        interval: 5000;
//        running: true;
//        repeat: true

//        property int count: 0

//        onTriggered:
//        {
//            ++count

//            var currentDate = new Date()

//            console.info("Log updateTimer", count)

//            console.log("today.getDate()", today.getDate(),
//                        "currentDate.getDate()", currentDate.getDate())

//            var pos = logsModule.getPosition()

////            console.log("logsModule.getPosition()", logsModule.getPosition(),
////                        "vertBar.position", vertBar.position)

//            if (currentDate.getDate() !==  today.getDate())
//            {
//                today = new Date()
//                yesterday = new Date(new Date().setDate(new Date().getDate()-1))

//                logsModule.fullUpdate()
//                vertBar.position = 0
//            }
//            else
//            {
////                logsModule.fullUpdate()
////                vertBar.position = 0
//                logsModule.updateLog()
//            }

//            vertBar.size = logsModule.getScrollSize()

//            if (!vertBar.position > 0)
//            {
//                vertBar.position = 0
//                logsModule.setPosition(0)
//            }
//            else
//            {
//                console.log("logsModule.getPosition()", logsModule.getPosition(),
//                            "vertBar.position", vertBar.position)

//                vertBar.position = logsModule.getPosition()
////                logsModule.setPosition(pos)
//            }
//        }
//    }

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0
                visible: logsModule.statusInit

                RowLayout
                {
                    id: titleItem
                    Layout.minimumHeight: 45
                    Layout.maximumHeight: 45
//                    Layout.leftMargin: 16

                    spacing: 0

                    SelectorItem
                    {
                        id: selectorNode
                        text: qsTr("Cellframe node logs")
                        current: true
                        onItemClicked:
                        {
                            if (!current)
                              selectLog("Node")
                        }
                    }

//                    SelectorItem
//                    {
//                        id: selectorService
//                        text: qsTr("Dashboard service logs")
//                        current: false
//                        onItemClicked:
//                        {
//                            if (!current)
//                                selectLog("Service")
//                        }
//                    }

                    SelectorItem
                    {
                        id: selectorGUI
                        text: qsTr("Dashboard logs")
                        current: false
                        onItemClicked:
                        {
                            if (!current)
                                selectLog("GUI")
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                    }

                    Image{
                        id: indicator
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 16
                        mipmap: true
                        source: logsModule.flagLogUpdate ? "qrc:/Resources/BlackTheme/icons/other/icon_reload.svg"
                                                         : "qrc:/Resources/BlackTheme/icons/other/icon_pause.svg"

                        function reset()
                        {
                            if(logsModule.flagLogUpdate)
                            {
                                indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_reload.svg"
                                animation.start()
                            }
                            else
                            {
                                indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_pause.svg"
                                animation.stop()
                            }
                        }

                        RotationAnimator {
                            id: animation
                            target: indicator
                            running: logsModule.flagLogUpdate
                            from: 0
                            to: 360
                            loops: Animation.Infinite
                            duration: 1000

                            onRunningChanged: if(!running) indicator.rotation = 0
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                logsModule.flagLogUpdate = !logsModule.flagLogUpdate
                                animation.stop()

                                if(logsModule.flagLogUpdate)
                                {
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_pause_hover.svg"
                                }
                                else
                                {
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_reload_hover.svg"
                                }
                            }

                            onEntered:
                            {
                                if(logsModule.flagLogUpdate)
                                {
                                    animation.stop()
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_pause_hover.svg"
                                }
                                else
                                {
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_reload_hover.svg"
                                }
                            }
                            onExited:
                            {
                                if(logsModule.flagLogUpdate)
                                {
                                    animation.start()
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_reload.svg"
                                }
                                else
                                {
                                    indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_pause.svg"
                                }
                            }
                        }
                    }
                }

                ListView
                {
                    id: dapLogsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
//                    model: dapLogsModel
                    model: logModel

//                    highlight: Rectangle{color: currTheme.rowHover; opacity: 0.12}
//                    highlightMoveDuration: 0

                    delegate: delegateLogs

                    section.property: "date"
                    section.criteria: ViewSection.FullString
                    section.delegate: delegateLogsHeader
//                    cacheBuffer: 15000

                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }

                    onCurrentIndexChanged: {
                        if(currentIndex >= 0)
                            //stop update
                            logsModule.flagLogUpdate = false
                        else
                            //start update
                            logsModule.flagLogUpdate = true

                        indicator.reset()
                    }
                }
            }

        ColumnLayout{
            anchors.fill: parent
            spacing: 16
            visible: !logsModule.statusInit

            Item{Layout.fillHeight: true}

            DapLoadIndicator {
                Layout.alignment: Qt.AlignHCenter

                indicatorSize: 64
                countElements: 8
                elementSize: 10

                running: !logsModule.statusInit
            }


            Text
            {
                Layout.alignment: Qt.AlignHCenter

                font: mainFont.dapFont.medium18
                color: currTheme.white
                text: qsTr("Logs data loading...")
            }
            Item{Layout.fillHeight: true}
        }

//        DapLoadIndicator {
////            x: parent.width / 2
////            y: parent.height / 2

//            anchors.centerIn: parent

//            indicatorSize: 64
//            countElements: 8
//            elementSize: 10

//            running: !logsModule.statusInit
//        }

//        ScrollBar {
//            id: vertBar
//            hoverEnabled: true
//            active: true
//            orientation: Qt.Vertical
////            size: frame.height / content.height
//            anchors.top: parent.top
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
//            anchors.topMargin: titleItem.height
//            policy: ScrollBar.AlwaysOn

//            Component.onCompleted:
//            {
//                size = logsModule.getScrollSize()
//            }

//            onPositionChanged:
//            {
//                if (pressed)
//                {
////                    console.log("ScrollBar onPositionChanged", position)
//                    logsModule.setPosition(position)
//                }
//            }
//        }

//        MouseArea
//        {
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.right: vertBar.left
//            preventStealing: true
//            acceptedButtons: Qt.NoButton
//            onWheel:
//            {
//                var change = -0.125*wheel.angleDelta.y/120

////                console.log("MouseArea onWheel", wheel.angleDelta.y, change)

//                logsModule.changePosition(change)

//                vertBar.position = logsModule.getPosition()

////                console.log("vertBar.position", vertBar.position,
////                            logsModule.getPosition())
//            }
////            onPositionChanged:
////            {
////                console.log("MouseArea onDragChanged", wheel.angleDelta)
////            }
//        }
    }

    //Creates a list model for the example
    Component.onCompleted:
    {
        isModelLoaded = true
        dapLogsListViewIndex = -1

        selectorNode.current = (logsModule.currentType === 0)
//        selectorService.current = (logsModule.currentType === 1)
        selectorGUI.current = (logsModule.currentType === 1)
//        var timeString = new Date();
//        var day = new Date(86400);
    }

    Component.onDestruction:
    {
        dapLogsListViewIndex = -1
    }

    Component
    {
        id: delegateLogsHeader
        Rectangle
        {
            height: 30
            width: parent.width
            color: currTheme.mainBackground

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: {
//                    console.log(dateWorker.getDateString(section), section)
                    return dateWorker.getDateString(section)
                }
                font: mainFont.dapFont.regular12
            }
        }
    }

    //The component delegate
    Component
    {
        id: delegateLogs

        //Frame delegate
        Rectangle
        {
//            anchors.left: parent.left
//            anchors.right: parent.right
            width: dapLogsList.width
            color: area.containsMouse || dapLogsList.currentIndex === index  ? currTheme.rowHover :"transparent"
            height: row.implicitHeight < 36 ? 50 : row.implicitHeight + 27

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
            }

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
                    color: type === "WRN" ? currTheme.darkYellow :
                           type === "ERR" ? currTheme.red :
                           type === "DBG" ? currTheme.gray :
                           type === "INF" || type === "*" ?
                           currTheme.neon : currTheme.white
                    text: type
                }

                Text
                {
                    id: textLog
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 30
                    verticalAlignment: Qt.AlignVCenter
                    wrapMode: Text.WrapAnywhere
                    font:  mainFont.dapFont.regular14
                    color: currTheme.white
                    text: info
                }

                Text
                {
                    id: fileLog
                    Layout.minimumWidth: 150
                    Layout.maximumWidth: 150
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 40
                    verticalAlignment: Qt.AlignVCenter
                    wrapMode: Text.WrapAnywhere
                    font:  mainFont.dapFont.regular13
                    color: currTheme.white
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
                    color: currTheme.white
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
                color: currTheme.mainBackground
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (dapLogsListViewIndex !== index)
                        dapLogsListViewIndex = index
                    else
                        dapLogsListViewIndex = -1
                }
            }

            Rectangle{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16

                width: 32
                height: 32

                color: copyArea.containsMouse ? currTheme.lime
                                              : currTheme.mainBackground
                radius: 4

                visible: dapLogsList.currentIndex === index

                MouseArea
                {
                    id: copyArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
//                        console.log("copyButton text",
//                                    logsModule.getLineText(index))

                        clipboard.setText(logsModule.getLineText(index))

                        dapMainWindow.infoItem.showInfo(
                                    196,0,
                                    dapMainWindow.width*0.5,
                                    8,
                                    qsTr("Copied to clipboard"),
                                    "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
                    }
                }

                Image
                {
                    id: copyButton

                    anchors.centerIn: parent
                    smooth: false
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit

                    source: copyArea.containsMouse ? "qrc:/Resources/"+ pathTheme +"/icons/other/ic_copy_black.svg"
                                                   : "qrc:/Resources/"+ pathTheme +"/icons/other/ic_copy_white.svg"


                    mipmap: true
                }
            }
        }
    }

    function selectLog(name)
    {
        selectorNode.current = (name === "Node")
//        selectorService.current = (name === "Service")
        selectorGUI.current = (name === "GUI")

        logsModule.selectLog(name)

        dapLogsListViewIndex = -1;
        dapLogsList.positionViewAtIndex(0, ListView.Beginning)

        indicator.source = "qrc:/Resources/BlackTheme/icons/other/icon_reload.svg"
        animation.start()

//        logsModule.updateLog()

//        vertBar.size = logsModule.getScrollSize()
//        vertBar.position = 0
//        logsModule.setPosition(0)

//        dapLogsListViewIndex = -1;
    }
}
