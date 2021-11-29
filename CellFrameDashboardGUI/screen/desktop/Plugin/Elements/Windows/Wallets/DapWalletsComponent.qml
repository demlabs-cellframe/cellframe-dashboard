import QtQuick 2.9
import QtQuick.Layouts 1.3


Component {
    id: delegateComponent

//    ColumnLayout
//    {
//        anchors.left: parent.left
//        anchors.right: parent.right

        Rectangle {

            id:control
            property var modelNetworks: model.networks

            anchors.left: parent.left
            anchors.right: parent.right
//            Layout.fillWidth: true
            height: list.contentHeight + headerFrame.height + 10 * pt
//            height: repeater.implicitHeight
            color: "#363A42"
//            radius: 16 * pt
//            border.width: 2
//            border.color: "#292929"

            Rectangle {
                id: headerFrame
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 40 * pt
                color: "#D01E67"
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

            ListView{
                id: list
                anchors {
                    left: parent.left;
                    right: parent.right;
                    top: headerFrame.bottom;
                    bottom: parent.bottom

                }
                clip: true
                focus: true

                model:modelNetworks
                delegate: delegateTokenView
            }

            Component
            {

                id: delegateTokenView
                Column
                {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    onHeightChanged: list.contentHeight = height

                    Rectangle
                    {
                        id: stockNameBlock
                        height: 30 * pt
                        anchors.left: parent.left
                        anchors.right: parent.right
                        color: currTheme.backgroundMainScreen

                        DapWalletsInfo
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
//                            width: infoFrame.width
                            name: model.name
                            value: model.address
                            color: "#2D3037"
                        }
                    }

                    Repeater
                    {
                        id:repeater
                        anchors.left: parent.left
                        anchors.right: parent.right
                        model: tokens

                        Rectangle
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 50 * pt
                            color: currTheme.backgroundElements

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 20 * pt
                                anchors.rightMargin: 20 * pt
                                spacing: 10 * pt

                                DapWalletsInfo
                                {
                                    Layout.fillWidth: true
                                    name: model.name
                                    value: balance.toFixed(9)
                                    color: "transparent"
                                }
                            }
                            //  Underline
                            Rectangle
                            {
                                x: 20 * pt
                                y: parent.height - 1 * pt
                                width: parent.width - 40 * pt
                                height: 1 * pt
                                color: currTheme.lineSeparatorColor
                            }
                        }
                    }
                }
            }
        }  //
//    }
}  //delegateComponent


