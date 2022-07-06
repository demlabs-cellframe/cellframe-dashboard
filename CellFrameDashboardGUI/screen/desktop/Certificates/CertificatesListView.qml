import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.5
import "parts"
import "qrc:/widgets"



ListView {
    id: root
    property alias delegateComponent: delegateComponent
    signal selectedIndex(int index)
    signal infoClicked(int index)

    property string seletedCertificateAccessType: qsTr("Public")
//    property alias infoText: infoTitleText
    property bool infoTitleTextVisible: false
    property bool infoTitleTextVisibleClick: false

    //interactive: contentHeight > height
    headerPositioning: ListView.OverlayHeader
    spacing: 17 * pt
    clip: true

    ScrollBar.vertical: ScrollBar {
        active: true
    }

    header: Rectangle {
        width: parent.width
        height: certificatesTitle.height + tableTitle.height + spacing - 6 * pt
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
                x: 3 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: mainFont.dapFont.bold14
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
                verticalAlignment: Text.AlignVCenter
                font: mainFont.dapFont.medium11
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
                font: mainFont.dapFont.medium11
                text: qsTr("Info")
                opacity: if (root.infoTitleTextVisible || root.infoTitleTextVisibleClick) return 1; else return 0
                color: currTheme.textColor

                Behavior on opacity {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
        }

    }  //header

    Component {
        id: delegateComponent

        Rectangle {
            //this property need set from root
            width: root.width
            anchors.left: parent.left
            anchors.leftMargin: 14 * pt
            anchors.right: parent.right
            anchors.rightMargin: 14 * pt
            height: 38 * pt
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle

            Text {
                id: certificateNameText
                //x: 14 * pt
                width: 597 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: mainFont.dapFont.regular16
                text: model.completeBaseName   //model.fileName
                elide: Text.ElideRight
                maximumLineCount: 1
                color: currTheme.textColor

                property string colorProperty: (model.selected || delegateClicked._entered) ? currTheme.hilightColorComboBox : currTheme.textColor

                onColorPropertyChanged: textTimer.start()

                Timer {
                    id: textTimer
                        interval: 300
                        onTriggered: certificateNameText.color = certificateNameText.colorProperty
                    }
            }


            MouseArea{
                id: delegateClicked
                width: parent.width
                height: parent.height
                hoverEnabled: true
                property bool _entered: false
                onEntered:
                {
                    _entered = true
                }

                onExited:
                {
                    _entered = false
                }
                onClicked: {
                    root.selectedIndex(model.index)
                    models.selectedAccessKeyType = model.accessKeyType
                    root.infoTitleTextVisibleClick = true
                    if (openedRightPanelPage == "Info" && model.index !== infoIndex)
                        certificateNavigator.clearRightPanel()
                }

                onDoubleClicked: {
                    root.infoClicked(model.index)
                    //root.selectedIndex(model.index)
                }
            }


            Item {
                id: infoButton
                anchors {
                    right: parent.right
                }
                height: parent.height
                width: 58 * pt
                opacity: if (model.selected || delegateClicked._entered) return 1; else return 0

                onOpacityChanged: root.infoTitleTextVisible = opacity

                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                    }
                }

                Image{
                    anchors.right: infoButton.right
                    anchors.rightMargin: 14 * pt
                    y: 3 * pt
                    width: 30 * pt
                    height: 30 * pt
                    mipmap: true
                    source: "qrc:/resources/icons/Certificates/ic_info.png"
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        root.infoClicked(model.index)
                    }
                }

            }  //


            Rectangle {
                id: bottomLine
                //x: certificateNameText.x
//                y: parent.height
//                width: 644 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                //anchors.leftMargin: 14 * pt
                //anchors.rightMargin: 15 * pt
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
