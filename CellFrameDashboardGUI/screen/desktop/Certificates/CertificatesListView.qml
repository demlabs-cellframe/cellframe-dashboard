import QtQuick 2.9
import QtQuick.Controls 2.5
import "parts"
import "qrc:/widgets"



ListView {
    id: root
    property alias delegateComponent: delegateComponent
    signal selectedIndex(int index)
    signal infoClicked(int index)

    property string seletedCertificateAccessType: qsTr("Public")
    property bool infoTitleTextVisible: false

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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: qsTr("Info")
                visible: root.infoTitleTextVisible
                color: currTheme.textColor
            }
        }

    }  //header

    Component {
        id: delegateComponent

        Rectangle {
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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: model.completeBaseName   //model.fileName
                color: (model.selected || delegateClicked._entered) ? currTheme.hilightColorComboBox : currTheme.textColor
                elide: Text.ElideRight
                maximumLineCount: 1
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
                }

                onDoubleClicked: {
                    root.infoClicked(model.index)
                }
            }

            Item {
                id: infoButton
                anchors {
                    left: certificateNameText.right
                    right: parent.right
                }
                height: parent.height
                visible: model.selected || delegateClicked._entered

                DapImageLoader{
                    anchors.right: infoButton.right
                    anchors.rightMargin: 14 * pt
                    innerWidth: 30 * pt
                    innerHeight: 30 * pt
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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                height: 1 * pt
                color: currTheme.lineSeparatorColor
            }
        }  //
    }  //delegateComponent
}  //root
