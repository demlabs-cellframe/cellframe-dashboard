import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"
import "../../"
import "qrc:/logic"
import "qrc:/screen"

ColumnLayout
{
    id:control
    anchors.fill: parent

    spacing: 0

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
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Connections")
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.mainBackground

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Connected with wallet")
        }
    }

    ListView
    {
        id:listMenuLinked
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model: dapWebSites
        clip: true
        delegate: delegateList
    }


    Component{
        id:delegateList

        ColumnLayout
        {
            id:columnMenuTab
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            onHeightChanged: listMenuLinked.contentHeight = height

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout
                {
                    anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        elide: Text.ElideMiddle

                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        verticalAlignment: Qt.AlignVCenter
                        text: site

                        ToolTip
                        {
                            id:toolTip
                            visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
                            text: parent.text
                            scale: mainWindow.scale

                            contentItem: Text {
                                    text: toolTip.text
                                    font: mainFont.dapFont.regular14
                                    color: currTheme.white
                                }
                            background: Rectangle{color:currTheme.mainBackground}
                        }
                        MouseArea
                        {
                            id:area
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                    DapSwitch
                    {
                        id: switchTab
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 26
                        Layout.preferredWidth: 46
                        indicatorSize: 30

                        backgroundColor: currTheme.mainBackground
                        borderColor: currTheme.reflectionLight
                        shadowColor: currTheme.shadowColor

                        checked: dapWebSites.get(index).enabled
                        onToggled: {
                            dapWebSites.get(index).enabled = checked
                            dapServiceController.webConnectRespond(checked, index)
                            // banSettings.webSites = logicMainApp.serializeWebSite()
                        }
                    }
                }
                Rectangle
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.mainBackground
                }
            }
        }
    }
}
