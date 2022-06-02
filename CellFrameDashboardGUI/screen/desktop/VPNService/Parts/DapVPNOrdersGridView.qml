import QtQuick 2.7
import QtGraphicalEffects 1.0
import "qrc:/widgets"

GridView {
    id: control

    property int delegateMargin
    property int delegateWidth: 300 * pt
    property int delegateHeight: 164 * pt
    property int delegateContentMargin: 16 * pt
//    property alias currentIndex_ : currentIndex

    signal orderDetailsShow(var index)

    //model: dapModelOrders

    cellWidth: delegateMargin * 2 + delegateWidth
    cellHeight: delegateMargin * 2 + delegateHeight

    clip: true
    currentIndex: -1
    focus: true

    delegate: Item {
        id: cell

        width: control.cellWidth
        height: control.cellHeight

        GridView.onRemove: {
            if (GridView.isCurrentItem) {
                control.currentIndex = -1;
            }
        }

        DapRectangleLitAndShaded {
            id: contentFrame

            x: control.delegateMargin
            y: control.delegateMargin
            width: parent.width - x * 2
            height: parent.height - y * 2

            color: currTheme.backgroundMainScreen
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.reflectionLight
            lightColor: currTheme.shadowColor

            focus: true

            contentData:
                Item {
                anchors.fill: parent

                    Rectangle {
                        id: headerFrame

                        width: parent.width
                        height: 30 * pt

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
                                        color: cell.GridView.isCurrentItem ? currTheme.buttonColorHoverPosition0 :
                                                                   currTheme.backgroundMainScreen
                                    }
                                    GradientStop
                                    {
                                        position: 1;
                                        color: cell.GridView.isCurrentItem ? currTheme.buttonColorHoverPosition1 :
                                                                   currTheme.backgroundMainScreen

                                    }
                                }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: control.delegateContentMargin
                            anchors.right: orderIcon.right
                            font:  mainFont.dapFont.medium12
                            elide: Text.ElideRight
                            color: currTheme.textColor
                            text: modelData.Name
                        }

                        Image {
                            id: orderIcon
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: (control.delegateContentMargin / 2) * pt  // / 2 - ic_info_order.svg have space right
                            sourceSize: Qt.size(parent.height, parent.height)
                            source: "qrc:/resources/icons/ic_info_order.svg"
                        }
                        Rectangle
                        {
                            anchors.top: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 1 * pt
                            color: currTheme.lineSeparatorColor
                        }
                    }

                    Item {
                        id: infoFrame

                        anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }
                        anchors.margins: control.delegateContentMargin

                        Column {
                            spacing: 12 * pt

                            DapVPNOrderInfoLine {
                                width: infoFrame.width
                                name: qsTr("Units ")
                                value: modelData.PriceUnits
                            }
                            DapVPNOrderInfoLine {
                                width: infoFrame.width
                                name: qsTr("Location")
                                value: modelData.Location
                            }
                            DapVPNOrderInfoLine {
                                width: infoFrame.width
                                name: qsTr("Price")
                                value: modelData.Price
                            }
                            DapVPNOrderInfoLine {
                                width: infoFrame.width
                                name: qsTr("Token")
                                value: modelData.PriceToken
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            cell.forceActiveFocus();
                            control.currentIndex = index-1;
                            orderDetailsShow(model.index)
                        }
                    }
            }
        }
    }
}
