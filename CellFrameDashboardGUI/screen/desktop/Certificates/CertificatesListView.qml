import QtQuick 2.9
import QtQuick.Controls 2.5
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

    ScrollBar.vertical: ScrollBar {
        active: true
    }

    header: Rectangle {
        width: parent.width
        height: certificatesTitle.height + tableTitle.height + spacing
        z:10
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle

        Rectangle {
            id: certificatesTitle
            width: parent.width
            height: 40 * pt
            color: currTheme.backgroundElements
            anchors.left: parent.left
            anchors.leftMargin: 10 * pt
            anchors.right: parent.right
            anchors.rightMargin: 10 * pt
            radius: currTheme.radiusRectangle

            Text {
                id: certificatesTitleText
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
                text: qsTr("Certificates")
            }
        }


        Rectangle {
            id: tableTitle
            width: parent.width
            height: 30 * pt

            anchors.top: certificatesTitle.bottom
            color: currTheme.backgroundMainScreen

            Text {
                x: 15 * pt
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 25 * pt
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: root.seletedCertificateAccessType
                color: currTheme.textColor
            }

            Text {
                id: infoTitleText
                x: 15 * pt
                anchors {
                    right: parent.right
                    rightMargin: 31 * pt
                }
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: qsTr("Info")
                visible: root.infoTitleTextVisible
                color: currTheme.textColor
            }
        }

    }  //header


    Component {
        id: delegateComponent

        Rectangle {
            //this property need set from root
            width: root.width
            anchors.left: parent.left
            anchors.leftMargin: 10 * pt
            anchors.right: parent.right
            anchors.rightMargin: 10 * pt
            height: 40 * pt
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle

            Text {
                id: certificateNameText
                x: 14 * pt
                width: 612 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: model.completeBaseName   //model.fileName
                color: model.selected ? "#FF0080" : currTheme.textColor
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
//                y: parent.height
//                width: 644 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                anchors.leftMargin: 14 * pt
                anchors.rightMargin: 15 * pt
                height: 1 * pt
                color: currTheme.lineSeparatorColor
            }

        }  //

    }  //delegateComponent



//    Rectangle {  //border frame
//        width: parent.width
//        height: parent.height
//        border.color: currTheme.backgroundElements
//        border.width: 1 * pt
//        radius: 8 * pt
//        color: "transparent"
//        z: 1
//    }





}  //root
