import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import "qrc:/widgets"

Item {
    id: root

    signal selectedAccessKeyType(int index)

    property alias certificateAccessTypeRepeater: certificateAccessTypeRepeater

    property alias createCertificateButton: createCertificateButton
    property alias importCertificateButton: importCertificateButton
    property alias exportPublicCertificateToFileButton: exportPublicCertificateToFileButton
//    property alias exportPublicCertificateToMempoolButton: exportPublicCertificateToMempoolButton
    property alias addSignatureToCertificateButton: addSignatureToCertificateButton
    property alias deleteCertificateButton: deleteCertificateButton

    property bool certificateSelected: false
    property bool bothAccessTypeCertificateSelected: false

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    ButtonGroup {
        id: buttonGroup
    }

    ColumnLayout {
        id:frameRightPanel
        anchors.fill: parent
        spacing: 0

        Text {
            Layout.minimumHeight: 35
            Layout.maximumHeight: 35
            Layout.leftMargin: 16
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Filter")
        }

        ColumnLayout
        {
            Layout.leftMargin: 3
            Layout.topMargin: 5
            spacing: 6

            Repeater {
                id: certificateAccessTypeRepeater

                DapRadioButton {
                    id: buttonSelectionNothing
                    nameRadioButton: model.name
                    Layout.preferredHeight: 46
                    Layout.fillWidth: true
                    implicitHeight: indicatorInnerSize
                    indicatorSize: 16
                    indicatorInnerSize: 46
                    //spaceIndicatorText: 18
                    fontRadioButton: mainFont.dapFont.regular16
                    ButtonGroup.group: buttonGroup
                    checked: model.selected

                    onClicked: {
                        root.selectedAccessKeyType(model.index)
                    }
                }  //
            }  //
        }
        Text {
            id: actionsTitleText
            Layout.topMargin: 27
            Layout.leftMargin: 16
            Layout.minimumHeight: 18
            Layout.maximumHeight: 18
            verticalAlignment: Text.AlignVCenter
            font: mainFont.dapFont.bold14
            color: currTheme.white
            text: qsTr("Actions")
        }

        ColumnLayout
        {
            Layout.leftMargin: 16
            Layout.topMargin: 24
            spacing: 20

            DapButton {
                id: createCertificateButton
                textButton: qsTr("Create certificate")

                Layout.preferredHeight: 36

                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36
                implicitWidth: 318

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: modulesController.isNodeWorking

                DapCustomToolTip{
                    contentText: qsTr("Create certificate")
                }
            }

            DapButton {
                id: importCertificateButton
                textButton: qsTr("Import certificate")
                Layout.preferredHeight: 36
                visible: true   //TODO need clarification of the requirements

                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36
                implicitWidth: 318

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14
                enabled: modulesController.isNodeWorking

                onClicked:
                {
                    importFileDialog.open()
                }

                DapCustomToolTip{
                    contentText: qsTr("Import certificate")
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
                    certificatesModule.import(importFileDialog.files[ind])
                }
            }

            DapButton {
                id: exportPublicCertificateToFileButton
                textButton: qsTr("Export private certificate to public")
                Layout.preferredHeight: 36

                enabled: root.certificateSelected && bothAccessTypeCertificateSelected && modulesController.isNodeWorking
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36
                implicitWidth: 318

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                DapCustomToolTip{
                    contentText: qsTr("Export private certificate to public")
                }
            }


//            DapButton {
//                id: exportPublicCertificateToMempoolButton
//                textButton: qsTr("Export certificate to mempool") // qsTr("Export public certificate to mempool")
//                Layout.preferredHeight: 36

//                enabled: root.certificateSelected && modulesController.isNodeWorking
//                Layout.alignment: Qt.AlignHCenter
//                implicitHeight: 36
//                implicitWidth: 318

//                horizontalAligmentText: Text.AlignHCenter
//                indentTextRight: 0
//                fontButton: mainFont.dapFont.medium14

//                DapCustomToolTip{
//                    contentText: qsTr("Export certificate to mempool")
//                }
//            }


            DapButton {
                id: addSignatureToCertificateButton //#373A42
                textButton: qsTr("Add signature to certificate")
                Layout.preferredHeight: 36
                visible: false

                enabled: root.certificateSelected && modulesController.isNodeWorking
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36
                implicitWidth: 318

                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                DapCustomToolTip{
                    contentText: qsTr("Add signature to certificate")
                }
            }

            DapButton {
                id: deleteCertificateButton
                textButton: qsTr("Delete certificate")
                Layout.preferredHeight: 36

                enabled: root.certificateSelected && modulesController.isNodeWorking
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 36
                implicitWidth: 318

                horizontalAligmentText: Text.AlignHCenter

                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                DapCustomToolTip{
                    contentText: qsTr("Delete certificate")
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}  //root
