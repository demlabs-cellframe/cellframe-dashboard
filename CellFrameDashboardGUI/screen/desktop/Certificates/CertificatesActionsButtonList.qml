import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import "qrc:/widgets"




Item {
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


    Item {
        id: radioButtonFrame
        y: 12 * pt
        width: parent.width - x
        height: 166 * pt

        Text {
            id: filterTitleText
            x: 15 * pt
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: "#3E3853"
            text: qsTr("Filter")
        }

        ColumnLayout {
            id: certificateAccessTypeLayout
            spacing: 35 * pt
            y: filterTitleText.y + filterTitleText.height + 24 * pt
            x: 15 * pt
            width: parent.width - x

            Repeater {
                id: certificateAccessTypeRepeater

                DapRadioButton {    //qrc:/screen/desktop/Certificates/CertificatesActionsButtonList.qml:73:17: QML DapRadioButtonForm.ui: Binding loop detected for property "baselineOffset"
                    id: buttonSelectionNothing
                    nameRadioButton: model.name
                    Layout.preferredHeight: 16 * pt
                    Layout.fillWidth: true
                    indicatorSize: 16 * pt
                    indicatorInnerSize: 7 * pt
                    spaceIndicatorText: 18 * pt
                    fontRadioButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    indicatorBackgroundColor: "transparent"
                    indicatorBorder.width: 2 * pt
                    indicatorBorderColor: "#211A3A"
                    indicatorInnerColorActiv: "#211A3A"
                    indicatorInnerColorNormal: "transparent"
                    nameTextColor: "#070023"
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
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
        color: "#3E3853"
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
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt

            colorBackgroundNormal: "#271C4E"
            colorBackgroundHover: "#D2145D"
            colorButtonTextNormal: "#FFFFFF"
            colorButtonTextHover: "#FFFFFF"
            borderColorButton: "#000000"
            borderWidthButton: 0
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }

        DapButton {
            id: importCertificateButton
            textButton: qsTr("Import certificate")
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt
            visible: false   //TODO need clarification of the requirements

            colorBackgroundNormal: "#271C4E"
            colorBackgroundHover: "#D2145D"
            colorButtonTextNormal: "#FFFFFF"
            colorButtonTextHover: "#FFFFFF"
            borderColorButton: "#000000"
            borderWidthButton: 0
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }


        DapButton {
            id: exportPublicCertificateToFileButton
            textButton: qsTr("Export public certificate to file")
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt

            enabled: root.certificateSelected && bothAccessTypeCertificateSelected
            colorBackgroundNormal: enabled ? "#271C4E" : "white"
            colorBackgroundHover: enabled ? "#D2145D" : "white"
            colorButtonTextNormal: enabled ? "#FFFFFF" : "#211A3A"
            colorButtonTextHover: enabled ? "#FFFFFF" : "#211A3A"
            borderColorButton: enabled ? "#000000" : "#211A3A"
            borderWidthButton: enabled ? 0 : (1 * pt)
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }


        DapButton {
            id: exportPublicCertificateToMempoolButton
            textButton: qsTr("Export public certificate to mempool")
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt

            enabled: root.certificateSelected
            colorBackgroundNormal: enabled ? "#271C4E" : "white"
            colorBackgroundHover: enabled ? "#D2145D" : "white"
            colorButtonTextNormal: enabled ? "#FFFFFF" : "#211A3A"
            colorButtonTextHover: enabled ? "#FFFFFF" : "#211A3A"
            borderColorButton: enabled ? "#000000" : "#211A3A"
            borderWidthButton: enabled ? 0 : (1 * pt)
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }


        DapButton {
            id: addSignatureToCertificateButton
            textButton: qsTr("Add signature to certificate")
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt
            visible: false   //TODO need clarification of the requirements

            enabled: root.certificateSelected
            colorBackgroundNormal: enabled ? "#271C4E" : "white"
            colorBackgroundHover: enabled ? "#D2145D" : "white"
            colorButtonTextNormal: enabled ? "#FFFFFF" : "#211A3A"
            colorButtonTextHover: enabled ? "#FFFFFF" : "#211A3A"
            borderColorButton: enabled ? "#000000" : "#211A3A"
            borderWidthButton: enabled ? 0 : (1 * pt)
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }

        DapButton {
            id: deleteCertificateButton
            textButton: qsTr("Delete certificate")
            Layout.fillWidth: true
            Layout.preferredHeight: 36 * pt

            enabled: root.certificateSelected
            colorBackgroundNormal: enabled ? "#271C4E" : "white"
            colorBackgroundHover: enabled ? "#D2145D" : "white"
            colorButtonTextNormal: enabled ? "#FFFFFF" : "#211A3A"
            colorButtonTextHover: enabled ? "#FFFFFF" : "#211A3A"
            borderColorButton: enabled ? "#000000" : "#211A3A"
            borderWidthButton: enabled ? 0 : (1 * pt)
            radius: 4 * pt
            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            horizontalAligmentText: Qt.AlignHCenter
        }


    }   //actionButtonsLayout




}  //root
