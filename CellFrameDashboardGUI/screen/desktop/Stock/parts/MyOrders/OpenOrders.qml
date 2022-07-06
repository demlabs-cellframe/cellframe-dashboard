import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "parts"
import "qrc:/widgets"

Item
{
    anchors.fill: parent

    // Header
    Item
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 38 * pt
        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt

            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Open orders")
            font:  mainFont.dapFont.bold14
            color: currTheme.textColor
        }
    }

    ListView
    {
        id: list
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        model: openModel

        highlight: Rectangle{color: currTheme.placeHolderTextColor; opacity: 0.12}
        highlightMoveDuration: 0

        headerPositioning: ListView.OverlayHeader
        header: Rectangle{
            width:parent.width
            height: 30 * pt
            color: currTheme.backgroundMainScreen
            z:10

            RowLayout{
                anchors.fill: parent
                spacing: 0
                HeaderLabel{
                    Layout.preferredWidth: 135 * pt
                    label.text: qsTr("Date")
                    label.anchors.leftMargin: 16
                }
                HeaderLabel{
                    Layout.preferredWidth: 102 * pt
                    label.text: qsTr("Pair")
                }
                HeaderLabel{
                    Layout.preferredWidth: 96 * pt
                    label.text: qsTr("Type")
                }
                HeaderLabel{
                    Layout.preferredWidth: 61 * pt
                    label.text: qsTr("Side")
                }
                HeaderLabel{
//                    Layout.fillWidth: true
                    Layout.preferredWidth: 150 * pt
                    label.text: qsTr("Price")
                }
                HeaderLabel{
                    Layout.preferredWidth: 49 * pt
                    label.text: qsTr("Filled")
                }
                Item{
                    Layout.preferredWidth: 69 * pt
                }
            }
        }
        delegate: openOrdersdelegate
        Component.onCompleted: currentIndex = -1
    }

    Component{
        id: openOrdersdelegate
        Item{
            id: delegate
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50 * pt

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    list.currentIndex = index
                    frameDelegate.color = "transparent";
                    logic.openOrdersDetails("open", model)
                }
                onEntered:
                    if(list.currentIndex !== index)
                        frameDelegate.color = currTheme.placeHolderTextColor;
                onExited:
                        frameDelegate.color = "transparent";

            }
            RowLayout
            {
                anchors.fill: parent
                spacing: 0
                HeaderLabel{
                    Layout.minimumWidth: 135 * pt
                    label.text: date
                    label.anchors.leftMargin: 16
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 102 * pt
                    label.text: pair
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 96 * pt
                    label.text: type
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 61 * pt
                    label.text: side
                    label.font: mainFont.dapFont.regular13
                    label.color: side === "Sell" ? currTheme.textColorRed : currTheme.textColorGreen
                }
                HeaderLabel{
                    Layout.minimumWidth: 150 * pt
                    label.text: price
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 49 * pt
                    label.text: filled
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    id: cancel
                    Layout.maximumWidth: 69 * pt
                    Layout.minimumWidth: 69 * pt
                    label.text: qsTr("Cancel")
                    label.font: mainFont.dapFont.regular13
                    label.color: mouseArea.containsMouse ?
                                     currTheme.textColorRed :
                                     currTheme.hilightColorComboBox
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            logicStock.cancelationOrder(index)
                            logic.initOrdersModels()
                        }
                    }
                }
            }

            Rectangle{
                id:frameDelegate
                anchors.fill: parent
                color: "transparent"
                opacity: 0.12
            }

            Rectangle{
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                height: 1 * pt
                color: currTheme.lineSeparatorColor
            }
        }
    }

    Connections{
        target: myOrdersTab
        onClosedDetailsSignal:{
            list.currentIndex = -1
        }
    }
}
