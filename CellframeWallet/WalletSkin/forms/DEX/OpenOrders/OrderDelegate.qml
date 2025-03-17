import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Component
{
    Item
    {
        visible: filterSide === side || filterSide === "Both"
        width: parent.width
        height: visible ? itemRect.height+16 : 0

        Rectangle
        {
            id: itemRect
            x: 0
            y: 0
            width: parent.width
            height: 60

            color: mouseArea.containsMouse ? currTheme.mainButtonColorNormal0 :"#32363D"
            radius: 12

            ColumnLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 0

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.topMargin: 7
                    Layout.minimumHeight: height
                    Layout.maximumHeight: height
                    height: 25

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: token1+"/"+token2
                        font: mainFont.dapFont.medium16
                        color: currTheme.white
                    }

                    Text {
                        Layout.fillHeight: true

                        text: qsTr("Filled: ") + filled + "%"
                        font: mainFont.dapFont.medium16
                        color: currTheme.white
                    }
                }

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.minimumHeight: height
                    Layout.maximumHeight: height
                    height: 10

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: date
                        font: mainFont.dapFont.medium12
                        color: currTheme.gray
                    }

                    Text {
                        Layout.fillHeight: true

                        text: side
                        font: mainFont.dapFont.medium12
                        color: side === "Buy" ?
                                   currTheme.green :
                                   currTheme.red
                    }
                }

                Item
                {
                    Layout.fillHeight: true
                }
            }


            MouseArea
            {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    orderItem.modelData = orderView.model.get(index)
                    dapBottomPopup.show(orderItem)

//                    console.log("OrderDelegate onClicked",
//                                orderView.model.get(index))

                }
            }

        }

        DropShadow {
            anchors.fill: itemRect
            radius: 10
            samples: 10
            horizontalOffset: 4
            verticalOffset: 4
            color: "#08070D"
            opacity: 0.18
            source: itemRect
        }
        InnerShadow {
            id: shadow
            anchors.fill: itemRect
            radius: 3
            samples: 10
            horizontalOffset: 2
            verticalOffset: 2
            color: "#515763"
            opacity: 0.51
            source: itemRect
        }

    }
}
