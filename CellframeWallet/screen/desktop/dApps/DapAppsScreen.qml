import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import QtQuick.Controls 2.2
import "qrc:/widgets"
import "../../"
import "RightPanel"

Page
{
    property alias dapFrameApps: frameApps
    property alias dapListViewApps: listViewApps
    property alias dapDownloadPanel: downloadRightPanel
    property alias dapDefaultRightPanel: defaultRightPanel

    property string currentPlugin:""
    property string currentFiltr:"Both"

    signal updateFiltr(string status)

    anchors.fill: parent

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    RowLayout
    {
        id:frameApps
        anchors.fill: parent

        spacing: 24 

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                ColumnLayout
                {
                    anchors.fill: parent
                    spacing: 0

                    Item
                    {
                        id: tokensShowHeader
                        Layout.fillWidth: true
                        height: 42
                        Text
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            font: mainFont.dapFont.bold14
                            color: currTheme.white
                            verticalAlignment: Qt.AlignVCenter
                            text: qsTr("Available apps")
                        }
                    }

                    Component {
                        id: highlight

                        Rectangle {
                            id:controlHighligh
                            property var isHover
                            width: 180 ; height: 40 
                            color: currTheme.gray
                            opacity: 0.12
                        }
                    }

                    ListView
                    {
                        id: listViewApps
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: dapAppsModel

                        delegate: delegateApp

//                        highlight: highlight
                        highlight: Rectangle{color: currTheme.gray; opacity: 0.12}
                        highlightResizeDuration: 0
                        highlightMoveDuration: 0

                        onCurrentIndexChanged:
                        {
                            dapAppsTab.updateButtons();
                        }

                        headerPositioning: ListView.OverlayHeader
                        header: Rectangle
                        {
//                            id: dAppsHeader
                            width:parent.width
                            height: 30
                            color: currTheme.mainBackground
                            z:10

                            RowLayout
                            {
                                anchors.fill: parent
    //                            anchors.leftMargin: 18 
                                spacing: 0

                                Item {
                                    Layout.preferredWidth: 438 
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 16
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Name")
                                        font:  mainFont.dapFont.medium11
                                        color: currTheme.white
                                    }
                                }

                                Item {
                                    Layout.preferredWidth: 90 
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 18 
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Verified")
                                        font:  mainFont.dapFont.medium11
                                        color: currTheme.white
                                    }
                                }
                                Item {
                                    Layout.preferredWidth: 149 
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 15 
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Status")
                                        font:  mainFont.dapFont.medium11
                                        color: currTheme.white
                                    }

                                }
                            }
                        }
                    }

                    Component
                    {
                        id:delegateApp
                        Rectangle
                        {
                            width: listViewApps.width
                            color: "transparent"
                            height: 50 

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                spacing: 0

                                // path plugin
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: 438 
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                                        Text{
                                            id:namePlugin
                                            anchors{
                                                topMargin: 10
                                                top: parent.top
                                                left: parent.left
                                                right: parent.right
                                            }

                                            text: name
                                            color: currTheme.white
                                            font:  mainFont.dapFont.regular11
                                            elide: Text.ElideMiddle

                                            DapCustomToolTip{
                                                visible: area.containsMouse ?  namePlugin.implicitWidth > namePlugin.width ? true : false : false
                                                contentText: namePlugin.text
                                                textFont: namePlugin.font
                                                onVisibleChanged: updatePos()
                                            }
                                        }


                                        Text{
                                            id:url
                                            anchors{
                                                top: namePlugin.bottom
                                                topMargin: 5
                                                left: parent.left
                                                right: parent.right
                                                bottom: parent.bottom
                                                bottomMargin: 8
                                            }
                                            elide: Text.ElideMiddle
                                            text: urlPath
                                            color: "#B2B2B2"
                                            font:  mainFont.dapFont.light12
                                            verticalAlignment: Qt.AlignVCenter
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: { listViewApps.currentIndex = index}
                                        }
//                                        Rectangle
//                                        {
//                                            anchors.right: parent.right
//                                            anchors.top: parent.top
//                                            anchors.bottom: parent.bottom
//                                            width: 2 
//                                            color: currTheme.lineSeparatorColor
//                                        }
                                    }
                                // verifed plugin
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: 90 
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        RowLayout
                                        {
                                            anchors.fill: parent

                                            Item {

                                                Layout.minimumHeight: 20
                                                Layout.minimumWidth: 20
                                                Layout.leftMargin: 25 
                                                Layout.rightMargin: 42 
                                                Layout.topMargin: 17 
                                                Layout.bottomMargin: 15 
                                                width: 20 
                                                height: 20 

                                                Image{
                                                    id:indicatorRadioButton
                                                    anchors.fill: parent
                                                    width: 20 
                                                    height: 20 
                                                    mipmap: true
                                                    source: verifed === "0" ? "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png" :
                                                                              "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png"
                                                }
                                            }
                                        }
                                    }
                                // status plugin
                                    Item {
                                        Layout.fillWidth: true
//                                        Layout.minimumWidth: 100 
//                                        Layout.maximumWidth: 100 
                                        Layout.preferredWidth: 149 
                                        Layout.fillHeight: true
                                        Text{
                                            id: statusPlugin

                                            anchors.fill: parent
//                                            anchors.centerIn: parent
                                            verticalAlignment: Text.AlignLeft
                                            anchors.topMargin: 16 
                                            anchors.leftMargin: 14 
//                                            horizontalAlignment: Text.AlignLeft

                                            text: status === "1" ? qsTr("Activated") : qsTr("Unactivated")
                                            color: currTheme.white
                                            font:  mainFont.dapFont.regular12
                                        }
                                    }
                            }
                            Rectangle
                            {
                                anchors.right: parent.right
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                height: 1 
                                color: currTheme.mainBackground
                            }

                            Rectangle
                            {
                                id:frameDelegate
                                anchors.fill: parent
                                color: "transparent"
                                MouseArea
                                {
                                    id: area
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {
                                        if(listViewApps.currentIndex !== index)
                                        {
                                            frameDelegate.color = currTheme.gray;
                                            frameDelegate.opacity = 0.12;
                                        }
                                    }
                                    onExited: {
                                            frameDelegate.color = "transparent";
                                            frameDelegate.opacity = 1;
                                    }

                                    onClicked:
                                    {
                                        listViewApps.currentIndex = index
                                        frameDelegate.color = "transparent";
                                        frameDelegate.opacity = 1;
                                    }
                                }
                            }
                        }
                    }
                }
        }

        DapAppsDefaultRightPanel
        {
            id:defaultRightPanel
            Layout.fillHeight: true
            Layout.minimumWidth: 350 

            Connections
            {
                target:dapAppsTab
                function onUpdateButtons()
                {
                    defaultRightPanel.setEnableButtons()
                }
            }
            onCurrentStatusSelected:
            {
                currentFiltr = status
                updateFiltr(status)
            }
        }

        DapAppsDownloadRightPanel
        {
            id:downloadRightPanel
            Layout.fillHeight: true
            Layout.minimumWidth: 350 
            Layout.maximumWidth: 350 
        }
    }
}
