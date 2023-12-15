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


    model: testOrdersModel

    cellWidth: delegateWidth + delegateMargin * 2
    cellHeight: delegateHeight + delegateMargin * 2

    clip: true
    currentIndex: -1
    focus: true

    //TODO: scrolling is hidden behind the right border
    ScrollBar.vertical: ScrollBar {
        active: true
    }


    delegate: DapRectangleLitAndShaded {
        id: cell

        width: delegateWidth
        height: delegateHeight

        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        focus: true

        contentData:
        Item {
            anchors.fill: parent

            Rectangle {
                id: headerFrame

                width: parent.width
                height: 30

                LinearGradient
                {
                    anchors.fill: parent
                    source: parent
                    start: Qt.point(0,parent.height/2)
                    end: Qt.point(parent.width,parent.height/2)
                    gradient:
                        Gradient {
                            GradientStop
                            {
                                position: 0;
                                color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover0 :
                                                           currTheme.mainBackground
                            }
                            GradientStop
                            {
                                position: 1;
                                color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover1 :
                                                           currTheme.mainBackground

                            }
                        }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    font:  mainFont.dapFont.medium12
                    elide: Text.ElideRight
                    color: currTheme.white
                    text: (currentTabName + qsTr(" Order ") + model.index)
                }

                Image {
                    id: orderIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    mipmap: true
                    source: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info.svg"
                }
            }

            Loader
            {
                anchors.fill: parent
                anchors.topMargin: delegateContentMargin + headerFrame.height

                sourceComponent: currentTabName === "VPN" ? vpn_component:
                                 currentTabName === "DEX" ? dex_component:
                                                            stake_component

                onLoaded: item.orderModel = model

            }


            MouseArea {
                anchors.fill: parent

                onClicked: {
                    cell.forceActiveFocus();
                    if(control.currentIndex === index)
                       control.currentIndex = -1
                    else
                    {
                        control.currentIndex = index;
                        orderDetailsShow(model.index)
                    }
                }
            }
        }
    }


    Component
    {
        id: vpn_component

        ColumnLayout {

            property var orderModel

            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 12

            spacing: delegateContentMargin

            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Service uid")
                value: orderModel.service_uid
            }
            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Direction")
                value: orderModel.direction
            }
            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Price")
                value: orderModel.location
            }
            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Location")
                value: orderModel.location
                visible: orderModel.location === "None-None" ? false : true
            }
            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Node address")
                value: orderModel.node_addr
            }
        }
    }

    Component
    {
        id: dex_component

        ColumnLayout {

            property var orderModel

            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 12

            spacing: delegateContentMargin

            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Network")
                value: orderModel.network
            }
        }
    }

    Component
    {
        id: stake_component

        ColumnLayout {

            property var orderModel

            anchors.fill: parent
            anchors.rightMargin: 15
            anchors.leftMargin: 15
            anchors.bottomMargin: 12

            spacing: delegateContentMargin

            DapOrderInfoLine {
                Layout.fillWidth: true
                name: qsTr("Price")
                value: orderModel.price
            }
        }
    }
}
