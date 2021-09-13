import QtQuick 2.9
import "parts"



ListView {
    id: root
    property alias delegateComponent: delegateComponent
    signal selectedIndex(int index)
    signal infoClicked(int index)

    property string seletedCertificateAccessType: qsTr("Public")
    property bool infoTitleTextVisible: false


    //interactive: contentHeight > height
    headerPositioning: ListView.OverlayHeader
    spacing: 14 * pt
    clip: true


    header: Item {
        width: parent.width
        height: certificatesTitle.height + tableTitle.height + spacing
        z: 10

        Rectangle {
            id: certificatesTitle
            width: parent.width
            height: 40 * pt

            Text {
                id: certificatesTitleText
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: "#3E3853"
                text: qsTr("Certificates")
            }
        }


        Rectangle {
            id: tableTitle
            width: parent.width
            height: 30 * pt
            y: 40 * pt
            color: "#3E3853"

            Text {
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: root.seletedCertificateAccessType
                color: "white"
            }

            Text {
                id: infoTitleText
                x: 15 * pt
                anchors {
                    right: parent.right
                    rightMargin: 21 * pt
                }
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: qsTr("Info")
                visible: root.infoTitleTextVisible
                color: "white"
            }
        }

    }  //header


    Component {
        id: delegateComponent

        Item {
            //this property need set from root
            width: root.width
            height: 40 * pt

            Text {
                id: certificateNameText
                x: 14 * pt
                width: 612 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: model.selected ? dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMediumBold16 : dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: model.completeBaseName   //model.fileName
                color: model.selected ? "#D51F5D" : "#070023"
                elide: Text.ElideRight
                maximumLineCount: 1
            }


            MouseArea{
                id: delegateClicked
                width: parent.width
                height: parent.height
                onClicked: {
                    root.selectedIndex(model.index)
                }

                onDoubleClicked: {
                    root.infoClicked(model.index)
                    //root.selectedIndex(model.index)
                }
            }


            ToolButton {
                id: infoButton
                anchors {
                    left: certificateNameText.right
                    right: parent.right
                }
                height: parent.height
                visible: model.selected

                image.anchors {
                    right: infoButton.right
                    rightMargin: 14 * pt
                }
                image.source: "qrc:/resources/icons/Certificates/ic_info.svg"
                image.width: 30 * pt
                image.height: 30 * pt

                onClicked: {
                    root.infoClicked(model.index)
                }

            }  //


            Rectangle {
                id: bottomLine
                x: certificateNameText.x
                y: parent.height
                width: 648 * pt
                height: 1 * pt
                color: "#E3E2E6"
            }

        }  //

    }  //delegateComponent



    Rectangle {  //border frame
        width: parent.width
        height: parent.height
        border.color: "#E2E1E6"
        border.width: 1 * pt
        radius: 8 * pt
        color: "transparent"
        z: 1
    }





}  //root
