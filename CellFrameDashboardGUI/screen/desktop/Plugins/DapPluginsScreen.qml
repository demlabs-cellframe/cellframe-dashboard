import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../"

import "../SettingsWallet.js" as SettingsWallet


DapAbstractScreen
{
    property string installPlugin:""

    id: dapPluginsScreen
    anchors
    {
        top: parent.top
        topMargin: 6 * pt
        right: parent.right
        rightMargin: 44 * pt
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
//                tabsMovable: true
//                tab: Rectangle {
//                    id:rect
//                    color: styleData.selected? currTheme.buttonColorHover : currTheme.buttonColorNormal
//                    implicitWidth: Math.max(text.width + 4, 80)
//                    implicitHeight: 20
////                    border.width: 2
//                    radius: 2

//                    Text {
//                        id: text
//                        anchors.centerIn: parent
//                        text: styleData.title
//                        color: currTheme.textColor
//                    }
//                }

                tab: Item {
                    implicitWidth: Math.round(text.implicitWidth + 20)
                    implicitHeight: 30

                    Rectangle{

                        anchors.fill: parent
                        anchors.leftMargin: 5
                        border.width: 1
                        border.color: currTheme.lineSeparatorColor
//                        anchors.rightMargin: 2

                        color: styleData.selected? currTheme.buttonColorNoActive : currTheme.buttonColorNormal

    //                    border.width: 2
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
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                {
                    installPlugin = dapModelPlugins.get(i).path
                    pluginsTabView.addTab(dapModelPlugins.get(i).name,tabComponent)
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
                source: installPlugin

            }
        }
    }
}
