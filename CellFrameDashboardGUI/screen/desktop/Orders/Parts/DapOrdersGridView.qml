import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.2
import "qrc:/widgets"

GridView {
    id: control

    property int delegateMargin: 12
    property int delegateContentMargin: 11
    property int delegateWidth: 327
    property int delegateHeight: 174

    signal orderDetailsShow(var index)


//    model: testOrdersModel

    cellWidth: delegateWidth + delegateMargin * 2
    cellHeight: delegateHeight + delegateMargin * 2

    clip: true
    currentIndex: -1
    focus: true

    //TODO: scrolling is hidden behind the right border
    ScrollBar.vertical: ScrollBar {
        active: true
    }


    delegate: logicOrders.currentTabTechName === "VPN" ? vpn_component:
              logicOrders.currentTabTechName === "DEX" ? dex_component: stake_component


    Component
    {
        id: vpn_component

        DapOrderHeader
        {
            width: delegateWidth
            height: delegateHeight

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            focus: true

            ColumnLayout {

                anchors.fill: parent
                anchors.topMargin: 30 + delegateContentMargin //header height + margin
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                anchors.bottomMargin: 12

                spacing: delegateContentMargin

                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Network")
                    value: network
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Direction")
                    value: direction
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Price")
                    value: price
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Location")
                    value: node_location
                    visible: node_location === "None-None" ? false : true
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Node address")
                    value: node_addr
                }

                Item{
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component
    {
        id: dex_component

        DapOrderHeader
        {
            width: delegateWidth
            height: delegateHeight

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            focus: true

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 30 + delegateContentMargin //header height + margin
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                anchors.bottomMargin: 12

                spacing: delegateContentMargin

                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Network")
                    value: network
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Pair")
                    value: buyToken + "/" + sellToken
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: status === "OPENED" ? qsTr("Amount") : qsTr("Status")
                    value: status === "OPENED" ? amount : status
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Filled")
                    value: filled
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Rate")
                    value: rate
                }

                Item{
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component
    {
        id: stake_component

        DapOrderHeader
        {
            width: delegateWidth
            height: delegateHeight

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            focus: true

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 30 + delegateContentMargin //header height + margin
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                anchors.bottomMargin: 12

                spacing: delegateContentMargin

                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Network")
                    value: network
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Created")
                    value: created
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Price")
                    value: price
                }
                DapOrderInfoLine {
                    Layout.fillWidth: true
                    name: qsTr("Node address")
                    value: node_addr
                }
                Item{
                    Layout.fillHeight: true
                }
            }
        }
    }
}
