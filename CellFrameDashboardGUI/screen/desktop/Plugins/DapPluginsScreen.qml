import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../"

DapAbstractScreen
{
    id: dapPluginsScreen
    anchors
    {
        top: parent.top
        topMargin: 6 * pt
        right: parent.right
        rightMargin: 24 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt

    }
    color: currTheme.backgroundMainScreen

    TabView
    {
        id:pluginsTabView
        anchors.fill: parent

        style: TabViewStyle {
                frameOverlap: 1
                tabsAlignment: Qt.AlignHCenter

                tab: Item {
                    implicitWidth: Math.round(text.implicitWidth + 20)
                    implicitHeight: 30

                    Rectangle{

                        anchors.fill: parent
                        anchors.leftMargin: 5
                        border.width: 1
                        border.color: currTheme.lineSeparatorColor
                        color: styleData.selected? currTheme.buttonColorNoActive : currTheme.buttonColorNormal
                        radius: 2

                        Text {
                            id: text
                            anchors.fill: parent
                            anchors.leftMargin: 4
                            anchors.rightMargin: 4
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: styleData.title
                            color: currTheme.textColor
                            elide: Text.ElideMiddle
                        }

                    }
                }
                frame: Rectangle {
                    color: currTheme.backgroundMainScreen
                    radius: 16 * pt
                }
            }

        Component.onCompleted:
        {
            //initial tabs
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                {
                    pluginsTabView.addTab(dapModelPlugins.get(i).name,tabComponent)
                }
            }

            for(var j = 0; j < dapModelPlugins.count; j++)
            {
                //load sourse in tabs
                for(var q = 0; q < pluginsTabView.count; q++)
                {
                    if(dapModelPlugins.get(j).name === pluginsTabView.getTab(q).title)
                        pluginsTabView.getTab(q).source = dapModelPlugins.get(j).path
                }
            }
        }
    }

    Component
    {
        id:tabComponent
        Rectangle
        {
            id:pluginsShowFrame
            anchors.fill: parent
            color: currTheme.backgroundElements
            radius: 16*pt

            Loader{
                anchors.fill: parent
                anchors.margins: 10 * pt
            }
        }
    }
}
