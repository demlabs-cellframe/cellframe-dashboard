import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"




Rectangle {
    id: root

    signal selectedAccessKeyType(int index)

    property alias certificateAccessTypeRepeater: certificateAccessTypeRepeater

    property alias createCertificateButton: createCertificateButton
    property alias importCertificateButton: importCertificateButton
    property alias exportPublicCertificateToFileButton: exportPublicCertificateToFileButton
    property alias exportPublicCertificateToMempoolButton: exportPublicCertificateToMempoolButton
    property alias addSignatureToCertificateButton: addSignatureToCertificateButton
    property alias deleteCertificateButton: deleteCertificateButton

    property bool certificateSelected: false
    property bool bothAccessTypeCertificateSelected: false
    color: currTheme.backgroundMainScreen
    radius: currTheme.radiusRectangle

    implicitWidth: 270 * pt
    implicitHeight: 166 * pt

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    function setAccessTypeSeletedIndex(index) {
            //TODO выделять нужную кнопку
    }


    ButtonGroup {
        id: buttonGroup
    }

    Item
    {
        id:frameRightPanel
        anchors.fill: parent
//        color: parent.color
//        radius: parent.radius

        Item {
            id: radioButtonFrame
            y: 12 * pt
            width: parent.width - x
            height: 166 * pt

            Text {
                id: filterTitleText
                x: 15 * pt
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
                text: qsTr("Filter")
            }

            ColumnLayout {
                id: certificateAccessTypeLayout
                spacing: 32 * pt
                y: filterTitleText.y + filterTitleText.height + 24 * pt
                x: 3 * pt
                width: parent.width - x

                Repeater {
                    id: certificateAccessTypeRepeater

                    DapRadioButton {    //qrc:/screen/desktop/Certificates/CertificatesActionsButtonList.qml:73:17: QML DapRadioButtonForm.ui: Binding loop detected for property "baselineOffset"
                        id: buttonSelectionNothing
                        nameRadioButton: model.name
                        Layout.preferredHeight: 16 * pt
                        Layout.fillWidth: true
                        implicitHeight: indicatorInnerSize
                        indicatorSize: 16 * pt
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 18 * pt
                        fontRadioButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        ButtonGroup.group: buttonGroup
                        checked: model.selected
                        onClicked: {
                            root.selectedAccessKeyType(model.index)
                        }
                    }  //
                }  //
            }  //
        }  //radioButtonFrame


        Text {
            id: actionsTitleText
            x: 15 * pt
            y: radioButtonFrame.y + radioButtonFrame.height + 44 * pt
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            text: qsTr("Actions")
        }


        ColumnLayout {
            id: actionButtonsLayout
            spacing: 24 * pt
            y: actionsTitleText.y + actionsTitleText.height + 24 * pt
            width: parent.width

            DapButton {
                id: createCertificateButton
                textButton: qsTr("Create certificate")

                Layout.preferredHeight: 36 * pt

                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }

            DapButton {
                id: importCertificateButton
                textButton: qsTr("Import certificate")
    //            Layout.fillWidth: true
                Layout.preferredHeight: 36 * pt
                visible: true   //TODO need clarification of the requirements

                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }


            DapButton {
                id: exportPublicCertificateToFileButton
                textButton: qsTr("Export public certificate to file")
    //            Layout.fillWidth: true
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected && bothAccessTypeCertificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }


            DapButton {
                id: exportPublicCertificateToMempoolButton
                textButton: qsTr("Export public certificate to mempool")
    //            Layout.fillWidth: true
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }


            DapButton {
                id: addSignatureToCertificateButton
                textButton: qsTr("Add signature to certificate")
    //            Layout.fillWidth: true
                Layout.preferredHeight: 36 * pt
                visible: true   //TODO need clarification of the requirements

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }

            DapButton {
                id: deleteCertificateButton
                textButton: qsTr("Delete certificate")
    //            Layout.fillWidth: true
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }


        }   //actionButtonsLayout
    } //frameRightPanel
//    InnerShadow {
//        id: topLeftSadow
//        anchors.fill: frameRightPanel
//        cached: true
//        horizontalOffset: 5
//        verticalOffset: 5
//        radius: 4
//        samples: 32
//        color: "#2A2C33"
//        smooth: true
//        source: frameRightPanel
//        visible: frameRightPanel.visible
//    }
//    InnerShadow {
//        anchors.fill: frameRightPanel
//        cached: true
//        horizontalOffset: -1
//        verticalOffset: -1
//        radius: 1
//        samples: 32
//        color: "#4C4B5A"
//        source: topLeftSadow
//        visible: frameRightPanel.visible
//    }
}  //root
