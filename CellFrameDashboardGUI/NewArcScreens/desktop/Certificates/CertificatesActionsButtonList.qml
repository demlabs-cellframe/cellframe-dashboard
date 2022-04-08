import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
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

        Item {
            id: radioButtonFrame
            y: 12 * pt
            width: parent.width - x
            height: 166 * pt

            Text {
                id: filterTitleText
                x: 15 * pt
                font: _dapQuicksandFonts.dapFont.bold14
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

                    DapRadioButton {
                        id: buttonSelectionNothing
                        nameRadioButton: model.name
                        Layout.preferredHeight: 20 * pt
                        Layout.fillWidth: true
                        implicitHeight: indicatorInnerSize
                        indicatorSize: 16 * pt
                        indicatorInnerSize: 46 * pt

                        fontRadioButton: _dapQuicksandFonts.dapFont.regular16
                        ButtonGroup.group: buttonGroup
                        checked: model.selected

                        onClicked: {
                            root.selectedAccessKeyType(model.index)
                        }
                    }  //
                }  //
            }
        }  //radioButtonFrame

        Text {
            id: actionsTitleText
            x: 16 * pt
            y: radioButtonFrame.y + radioButtonFrame.height + 44 * pt
            font: _dapQuicksandFonts.dapFont.bold14
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
                fontButton: _dapQuicksandFonts.dapFont.regular16
            }

            DapButton {
                id: importCertificateButton
                textButton: qsTr("Import certificate")
                Layout.preferredHeight: 36 * pt
                visible: true   //TODO need clarification of the requirements

                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapFont.regular16

                onClicked:
                {
                    importFileDialog.open()
                }
            }
            FileDialog {
                visible: false
                id: importFileDialog
                title: qsTr("Import certificate...")
                folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
                nameFilters: qsTr("Certificate (*.dcert)")
                defaultSuffix: "dcert"
                onAccepted:
                {
                    var ind = 0;
                    importCertificate.import(importFileDialog.files[ind])
                }
            }


            DapButton {
                id: exportPublicCertificateToFileButton
                textButton: qsTr("Export private certificate to public")
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected && bothAccessTypeCertificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapFont.regular16
            }

            DapButton {
                id: exportPublicCertificateToMempoolButton
                textButton: qsTr("Export certificate to mempool")
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapFont.regular16
            }


            DapButton {
                id: addSignatureToCertificateButton
                textButton: qsTr("Add signature to certificate")
                Layout.preferredHeight: 36 * pt
                visible: false

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapFont.regular16
            }

            DapButton {
                id: deleteCertificateButton
                textButton: qsTr("Delete certificate")
                Layout.preferredHeight: 36 * pt

                enabled: root.certificateSelected
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36 * pt
                implicitWidth: 350 * pt

                horizontalAligmentText: Text.AlignHCenter

                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapFont.regular16
            }
        }   //actionButtonsLayout
    } //frameRightPanel
}  //root
