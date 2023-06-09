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

    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    QMLClipboard{
        id: clipboard
    }

    LogicTxExplorer
    {
        id: logicExplorer
    }

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

                    SelectorItem
                    {
                        id: selectorService
                        text: qsTr("Dashboard service logs")
                        current: false
                        onItemClicked:
                        {
                            if (!current)
                                selectLog("Service")
                        }
                    }

                    SelectorItem
                    {
                        id: selectorGUI
                        text: qsTr("Dashboard GUI logs")
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
                }

                ListView
                {
                    id: dapLogsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
//                    model: dapLogsModel
                    model: logModel
                    delegate: delegateLogs
                    section.property: "date"
                    section.criteria: ViewSection.FullString
                    section.delegate: delegateLogsHeader
//                    cacheBuffer: 15000
                    highlight: Rectangle{color: currTheme.gray; opacity: 0.12}
                    highlightMoveDuration: 0
                    interactive: false

//                    ScrollBar.vertical: ScrollBar {
//                        active: true
//                    }
                }
            }

        DapLoadIndicator {
//            x: parent.width / 2
//            y: parent.height / 2

            anchors.centerIn: parent

            indicatorSize: 64
            countElements: 8
            elementSize: 10

            running: !isModelLoaded
        }

        ScrollBar {
            id: vertBar
            hoverEnabled: true
            active: true
            orientation: Qt.Vertical
//            size: frame.height / content.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: titleItem.height
            policy: ScrollBar.AlwaysOn

            Component.onCompleted:
            {
                size = logsModule.getScrollSize()
            }

            onPositionChanged:
            {
                if (pressed)
                {
//                    console.log("ScrollBar onPositionChanged", position)
                    logsModule.setPosition(position)
                }
            }
        }

        MouseArea
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: vertBar.left
            preventStealing: true
            acceptedButtons: Qt.NoButton
            onWheel:
            {
                var change = -0.125*wheel.angleDelta.y/120

//                console.log("MouseArea onWheel", wheel.angleDelta.y, change)

                logsModule.changePosition(change)

                vertBar.position = logsModule.getPosition()

//                console.log("vertBar.position", vertBar.position,
//                            logsModule.getPosition())
            }
//            onPositionChanged:
//            {
//                console.log("MouseArea onDragChanged", wheel.angleDelta)
//            }
        }
    }

    //Creates a list model for the example
    Component.onCompleted:
    {
        isModelLoaded = true
        dapLogsListViewIndex = -1;
        var timeString = new Date();
        var day = new Date(86400);
    }

    Component
    {
        id: delegateLogsHeader
        Rectangle
        {
            height: 30
            width: parent.width
            color: currTheme.mainBackground

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: logicExplorer.getDateString(payDate)
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

            Image
            {
                id: copyButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16

                sourceSize: Qt.size(32,32)
                smooth: false
                antialiasing: true
                fillMode: Image.PreserveAspectFit
                visible: dapLogsListViewIndex === index

                source: "qrc:/Resources/"+ pathTheme +"/icons/other/copy_off.svg"

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log("copyButton text",
                                    logsModule.getLineText(index))

                        clipboard.setText(logsModule.getLineText(index))

                        dapMainWindow.infoItem.showInfo(
                                    0,0,
                                    dapMainWindow.width*0.5,
                                    8,
                                    qsTr("Copied to clipboard"),
                                    "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
                    }

                    onEntered:
                        copyButton.source =
                            "qrc:/Resources/"+ pathTheme +"/icons/other/copy_on.svg"

                    onExited:
                        copyButton.source =
                            "qrc:/Resources/"+ pathTheme +"/icons/other/copy_off.svg"
                }
            }
        }
    }

    function selectLog(name)
    {
        selectorNode.current = (name === "Node")
        selectorService.current = (name === "Service")
        selectorGUI.current = (name === "GUI")

        logsModule.selectLog(name)

        vertBar.size = logsModule.getScrollSize()
        vertBar.position = 0

        dapLogsListViewIndex = -1;
    }
}
