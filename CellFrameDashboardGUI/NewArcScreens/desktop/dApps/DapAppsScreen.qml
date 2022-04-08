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
        color: currTheme.backgroundMainScreen
    }

    RowLayout
    {
        id:frameApps
        anchors
        {
            fill: parent
//            margins: 12 * pt
//            rightMargin: 8 * pt
//            bottomMargin: 8 * pt
        }

        spacing: 24 * pt

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                        id: dAppsTitle
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
                            text: qsTr("Available apps")
                            font:  _dapQuicksandFonts.dapFont.bold14
                            color: currTheme.textColor
                        }
                    }

                    Component {
                        id: highlight

                        Rectangle {
                            id:controlHighligh
                            property var isHover
                            width: 180 * pt; height: 40 * pt
                            color: currTheme.placeHolderTextColor
                            opacity: 0.12
                        }
                    }

                    ListView
                    {
                        id: listViewApps
                        anchors.top: dAppsTitle.bottom
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        clip: true
                        model: dapAppsModel

                        delegate: delegateApp

//                        highlight: highlight
                        highlight: Rectangle{color: currTheme.placeHolderTextColor; opacity: 0.12}
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
                            height: 30 * pt
                            color: currTheme.backgroundMainScreen
                            z:10

                            RowLayout
                            {
                                anchors.fill: parent
    //                            anchors.leftMargin: 18 * pt
                                spacing: 0

                                Item {
                                    Layout.preferredWidth: 438 * pt
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 15 * pt
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Name")
                                        font:  _dapQuicksandFonts.dapFont.medium11
                                        color: currTheme.textColor
                                    }
                                }

                                Item {
                                    Layout.preferredWidth: 90 * pt
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 18 * pt
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Verified")
                                        font:  _dapQuicksandFonts.dapFont.medium11
                                        color: currTheme.textColor
                                    }
                                }
                                Item {
                                    Layout.preferredWidth: 149 * pt
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text
                                    {
                                        anchors.fill: parent
                                        anchors.leftMargin: 15 * pt
                                        verticalAlignment: Qt.AlignVCenter
        //                                horizontalAlignment: Qt.AlignLeft
                                        text: qsTr("Status")
                                        font:  _dapQuicksandFonts.dapFont.medium11
                                        color: currTheme.textColor
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
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: "transparent"
                            height: 50 * pt

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 14 * pt
                                spacing: 0

                                // path plugin
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: 438 * pt
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                                        Text{
                                            id:namePlugin
//                                            anchors.fill: parent
                                            anchors{
                                                topMargin: 10 * pt
                                                top: parent.top
                                                left: parent.left
                                                right: parent.right
                                            }

                                            text: name
                                            color: currTheme.textColor
                                            font:  _dapQuicksandFonts.dapFont.regular11
    //                                        wrapMode: Text.WordWrap
                                            elide: Text.ElideMiddle
                                        }

                                        Text{
                                            id:url
                                            anchors{
                                                top: namePlugin.bottom
                                                topMargin: 5 * pt
                                                left: parent.left
                                                right: parent.right
                                                bottom: parent.bottom
                                                bottomMargin: 8 * pt
                                            }
                                            elide: Text.ElideMiddle
                                            text: urlPath
                                            color: "#B2B2B2"
                                            font:  _dapQuicksandFonts.dapFont.light12
    //                                        wrapMode: Text.WordWrap
                                            verticalAlignment: Qt.AlignVCenter

                                            ToolTip
                                            {
                                                id: id_tooltip
                                                contentItem: Text{
                                                    color: currTheme.textColor
                                                    text: urlPath
                                                    font: _dapQuicksandFonts.dapFont.regular12
                                                }
                                                background: Rectangle {
                                                    border.color: currTheme.lineSeparatorColor
                                                    color: currTheme.backgroundElements
                                                }
                                                visible: false
                                                delay: 500
                                            }
                                            MouseArea
                                            {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onEntered: id_tooltip.visible = true;
                                                onExited: id_tooltip.visible = false

                                            }
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
//                                            width: 2 * pt
//                                            color: currTheme.lineSeparatorColor
//                                        }
                                    }
                                // verifed plugin
                                    Item {
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: 90 * pt
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                        RowLayout
                                        {
                                            anchors.fill: parent

                                            Item {

                                                Layout.minimumHeight: 20
                                                Layout.minimumWidth: 20
                                                Layout.leftMargin: 25 * pt
                                                Layout.rightMargin: 42 * pt
                                                Layout.topMargin: 17 * pt
                                                Layout.bottomMargin: 15 * pt
                                                width: 20 * pt
                                                height: 20 * pt

                                                DapImageLoader{
                                                    id:indicatorRadioButton
                                                    anchors.fill: parent
                                                    innerWidth: 20 * pt
                                                    innerHeight: 20 * pt
                                                    source: verifed === "0" ? "qrc:/resources/icons/" + pathTheme + "/no_icon.png" : "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
                                                }
                                            }
                                        }
                                    }
                                // status plugin
                                    Item {
                                        Layout.fillWidth: true
//                                        Layout.minimumWidth: 100 * pt
//                                        Layout.maximumWidth: 100 * pt
                                        Layout.preferredWidth: 149 * pt
                                        Layout.fillHeight: true
                                        Text{
                                            id: statusPlugin

                                            anchors.fill: parent
//                                            anchors.centerIn: parent
                                            verticalAlignment: Text.AlignLeft
                                            anchors.topMargin: 16 * pt
                                            anchors.leftMargin: 14 * pt
//                                            horizontalAlignment: Text.AlignLeft

                                            text: status === "1" ? "Activated":"Unactivated"
                                            color: currTheme.textColor
                                            font:  _dapQuicksandFonts.dapFont.regular12
                                        }
                                    }
                            }
                            Rectangle
                            {
                                anchors.right: parent.right
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                height: 2 * pt
                                color: currTheme.lineSeparatorColor
                            }

                            Rectangle
                            {
                                id:frameDelegate
                                anchors.fill: parent
                                color: "transparent"
                                MouseArea
                                {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {
                                        if(listViewApps.currentIndex !== index)
                                        {
                                            frameDelegate.color = currTheme.placeHolderTextColor;
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
            Layout.minimumWidth: 350 * pt

            Connections
            {
                target:dapAppsTab
                onUpdateButtons:
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
            Layout.minimumWidth: 350 * pt
            Layout.maximumWidth: 350 * pt
        }
    }
}
