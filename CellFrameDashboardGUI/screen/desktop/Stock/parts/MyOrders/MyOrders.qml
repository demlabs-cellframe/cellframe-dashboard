import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "parts"
import "qrc:/widgets"

Item
{
    anchors.fill: parent

    Component.onCompleted:
    {
        walletModule.startUpdateFee()
    }

    Component.onDestruction:
    {
        walletModule.stopUpdateFee()
    }

    // Header
    Item
    {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 42
        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            verticalAlignment: Qt.AlignVCenter
            text: qsTr("My orders")
            font:  mainFont.dapFont.bold14
            color: currTheme.white
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
        model: ordersModel

        highlight: Rectangle{color: currTheme.inputActive; opacity: 0.12}
        highlightMoveDuration: 0

        headerPositioning: ListView.OverlayHeader
        header: Rectangle{
            width:parent.width
            height: 30
            color: currTheme.mainBackground
            z:10

            RowLayout{
                anchors.fill: parent
                spacing: 0
                HeaderLabel{
                    Layout.preferredWidth: 135
                    label.text: qsTr("Date")
                    label.anchors.leftMargin: 16
                }
                HeaderLabel{
                    Layout.preferredWidth: 102
                    label.text: qsTr("Pair")
                }
//                HeaderLabel{
//                    Layout.preferredWidth: 96
//                    label.text: qsTr("Network")
//                }
                HeaderLabel{
                    Layout.preferredWidth: 61
                    label.text: qsTr("Side")
                }
                HeaderLabel{
                    Layout.preferredWidth: 150
                    label.text: qsTr("Amount")
                }
                HeaderLabel{
                    Layout.preferredWidth: 150
                    label.text: qsTr("Price")
                }
                HeaderLabel{
                    Layout.preferredWidth: 49
                    label.text: qsTr("Filled")
                }
                Item{
                    Layout.preferredWidth: 69
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
            width: list.width
            height: 50

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
                        frameDelegate.color = currTheme.inputActive;
                onExited:
                        frameDelegate.color = "transparent";

            }
            RowLayout
            {
                anchors.fill: parent
                spacing: 0
                HeaderLabel{
                    Layout.minimumWidth: 135
                    label.text: date
                    label.anchors.leftMargin: 16
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 102
                    label.text: pair
                    label.font: mainFont.dapFont.regular13
                }
//                HeaderLabel{
//                    Layout.minimumWidth: 96
//                    label.text: network
//                    label.font: mainFont.dapFont.regular13
//                }
                HeaderLabel{
                    Layout.minimumWidth: 61
                    label.text: side
                    label.font: mainFont.dapFont.regular13
                    label.color: side === "Sell" ? currTheme.red : currTheme.green
                }
                HeaderLabel{
                    Layout.minimumWidth: 150
                    label.text: amount
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 150
                    label.text: price
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    Layout.minimumWidth: 49
                    label.text: filled
                    label.font: mainFont.dapFont.regular13
                }
                HeaderLabel{
                    id: cancel
                    Layout.maximumWidth: 69
                    Layout.minimumWidth: 69
                    label.text: qsTr("Cancel")
                    label.font: mainFont.dapFont.regular13
                    label.color: mouseArea.containsMouse ?
                                     currTheme.red :
                                     currTheme.lime
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            removeOrderPopup.show(model)

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
                height: 1
                color: currTheme.input
            }
        }
    }

    Connections{
        target: myOrdersTab
        function onClosedDetailsSignal(){
            list.currentIndex = -1
        }
    }
}
