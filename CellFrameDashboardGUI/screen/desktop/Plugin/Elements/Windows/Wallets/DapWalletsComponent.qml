import QtQuick 2.9


Component {
    id: delegateComponent

    Rectangle {

        anchors.left: parent.left
        anchors.right: parent.right
        height: 60 * pt
        color: "#363A42"
        radius: 16 * pt
        border.width: 1
        border.color: "#666E7D"

        Rectangle {
            id: headerFrame
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 40 * pt
            color: "#2E3138"

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 14 * pt
                anchors.right: parent.right
                font.family: "Quicksand"
                font.pixelSize: 16
                elide: Text.ElideRight
                color: "#ffffff"
                text:  model.name
            }
        }

        Item {
            id: infoFrame

            anchors { left: parent.left; top: headerFrame.bottom; right: parent.right; bottom: parent.bottom }

            Column {
                spacing: 12 * pt

                Repeater
                {
                    model: dapModelWallets.get(0).networks.count
                    Rectangle
                    {
                        width: 50
                        height: 50
                    }
                }

//                DapOrdersInfo {
//                    width: infoFrame.width
//                    name: qsTr("Location ")
//                    value: model.location
//                    visible: model.location === "None-None" ? false : true
//                }
//                DapOrdersInfo {
//                    width: infoFrame.width
//                    name: qsTr("Network")
//                    value: model.network
//                }
//                DapOrdersInfo {
//                    width: infoFrame.width
//                    name: qsTr("Node Addr")
//                    value: model.node_addr
//                    visible: model.node_addr === "" ? false : true

//                }
//                DapOrdersInfo {
//                    width: infoFrame.width
//                    name: qsTr("Price")
//                    value: model.price
//                }
            }
        }

//        Rectangle {
//            id: bottomLine

//            anchors.top: headerFrame.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.leftMargin: 14 * pt
//            anchors.rightMargin: 15 * pt
//            height: 1 * pt
//            color: currTheme.lineSeparatorColor
//        }

    }  //

}  //delegateComponent


