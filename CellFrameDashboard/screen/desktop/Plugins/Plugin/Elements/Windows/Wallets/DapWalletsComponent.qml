import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


Component {
    id: delegateComponent

    Item {

        id:control
        property var modelNetworks: model.networks

        anchors.left: parent.left
        anchors.right: parent.right
        height: list.contentHeight + headerFrame.height + 10 

        Rectangle {
            id: headerFrame
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 40 
//            color: "#7930DE"

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
                            color: "#7930DE"
                        }
                        GradientStop
                        {
                            position: 1;
                            color: "#7F65FF"
                        }
                    }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 14 
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
//            focus: true

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
                    height: 30 
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "#2E3138"



                        DapWalletsInfo
                        {
                            id: textInfo
                            anchors.left: parent.left
                            anchors.right: parent.right
                            name: model.name
                            value: model.address
                            color: "#2D3037"
                            valueObject.color: area.containsMouse? "#DBFF71":"#ffffff"

                            ToolTip
                            {
                                id:toolTip
                                visible: area.containsMouse? true : false
                                text: qsTr("Click to Copy Address")
                                scale: mainWindow.scale

                                contentItem: Text {
                                        text: toolTip.text
                                        font: textInfo.valueObject.font
                                        color: "#ffffff"
                                    }

                                background: Rectangle{color:"#363A42"}
                            }

                        }
                        TextEdit
                        {
                            id:textCopy
                            visible: false
                        }


                        MouseArea
                        {
                            id:area
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked:
                            {
                                textCopy.text = textInfo.value
                                textCopy.selectAll()
                                textCopy.copy()
                                textCopy.deselect()
                                textCopy.text = ""
                            }
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
                        height: 50 
                        color: "#363A42"

                        RowLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 20 
                            anchors.rightMargin: 20 
                            spacing: 10 

                            DapWalletsInfo
                            {
                                Layout.fillWidth: true
                                name: model.name
                                value: model.coins
                                color: "transparent"
                            }
                        }
                        //  Underline
                        Rectangle
                        {
                            x: 20 
                            y: parent.height - 1 
                            width: parent.width - 40 
                            height: 1 
                            color: "#292929"
                        }
                    }
                }
            }
        }
    }  //
}  //delegateComponent


