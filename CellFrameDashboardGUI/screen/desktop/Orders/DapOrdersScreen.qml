import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../controls"
import "../../"
import "Parts"
import "qrc:/widgets"

Page {
    id: dapOrdersScreen

    property string currentTabName: "VPN"

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    ListModel
    {
        id: tabsModel

        ListElement
        {
            name: "VPN"
        }
        ListElement
        {
            name: "DEX"
        }
        ListElement
        {
            name: "Stake"
        }
    }

    ColumnLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 24

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            height: 42

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:

            ListView
            {
                id: tabsView
                anchors.fill: parent
                orientation: ListView.Horizontal
                model: tabsModel
                interactive: false

                currentIndex: 0
                onCurrentIndexChanged:
                {
                    currentTabName = tabsModel.get(currentIndex).name
                    ordersModule.currentTab = currentIndex
                }

                delegate:
                Item{
                    property int textWidth: tabName.implicitWidth
                    property int spacing: 24
                    height: 42
                    width: textWidth + spacing*2

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: tabsView.currentIndex = index
                    }

                    Text{
                        id: tabName
                        anchors.centerIn: parent
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        color: tabsView.currentIndex === index ? currTheme.white : currTheme.gray
                        font:  mainFont.dapFont.medium14
                        text: name

                        Behavior on color {ColorAnimation{duration: 200}}
                    }
                }

                Rectangle
                {
                    anchors.top: parent.bottom
                    anchors.topMargin: -3
                    width: tabsView.currentItem.width
                    height: 2

                    radius: 8
                    x: tabsView.currentItem.x
                    color: currTheme.lime

                    Behavior on x {NumberAnimation{duration: 200}}
                    Behavior on width {NumberAnimation{duration: 200}}
                }
            }
        }

        DapOrdersGridView {
            id: ordersView
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.rightMargin: -24

            model: modelOrders
        }
    }
}
