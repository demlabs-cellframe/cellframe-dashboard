import QtQuick 2.9
import QtQuick.Layouts 1.3


Component {
    id: delegateComponent

    Rectangle {

        anchors.left: parent.left
        anchors.right: parent.right
        height: 300 * pt
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

            anchors {
                left: parent.left;
                top: headerFrame.bottom;
                right: parent.right;
                bottom: parent.bottom
                topMargin: 10 * pt
            }

            Column {
                spacing: 12 * pt

                Repeater
                {
                    id:netRepeat
                    model: dapModelWallets.get(0).networks.count

                    ColumnLayout
                    {
//                        anchors.fill: parent
                        DapWalletsInfo
                        {
                            Layout.fillWidth: true
                            width: infoFrame.width
    //                        anchors.left: infoFrame.left
    //                        anchors.right: infoFrame.right

                            name: dapModelWallets.get(index).networks.get(index).name
                            value: dapModelWallets.get(index).networks.get(index).address
                            color: "#2D3037"
                        }

                        Repeater
                        {
                            property var count : dapModelWallets.get(netRepeat.index).networks.get(netRepeat.index).tokens.count
                            model:
                            {
                                dapModelWallets.get(netRepeat.index).networks.get(netRepeat.index).tokens.count
                                console.log(dapModelWallets.get(netRepeat.index).networks.get(netRepeat.index).tokens.count)
                            }


                            ColumnLayout
                            {

                                DapWalletsInfo
                                {
                                    Layout.fillWidth: true
                                    width: infoFrame.width
            //                        anchors.left: infoFrame.left
            //                        anchors.right: infoFrame.right

        //                            name: dapModelWallets.get(netRepeat.index).networks.get(netRepeat.index).name
        //                            value: dapModelWallets.get(netRepeat.index).networks.get(netRepeat.index).address
                                    name: "8"
                                    value: "1"
                                    color: "white"
                                }
                            }
                        }
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


