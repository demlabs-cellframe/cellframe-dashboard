import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import "qrc:/widgets"
import "parts"




Rectangle {
    id: root
    property alias closeButton: closeButton
    property alias createButton: createButton
    property alias optionalModel: optionalRepeater.model
    property alias signatureTypeCertificateComboBox: signatureTypeCertificateComboBox
    property alias titleCertificateTextInput: titleCertificateTextInput

    property bool requiredFieldValid: false

    implicitWidth: 100
    implicitHeight: 200

    border.color: "#E2E1E6"
    border.width: 1 * pt
    radius: 8 * pt
    color: "transparent"

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }


    Item {
        id: titleRectangle
        width: parent.width
        height: 40 * pt

        CloseButton {
            id: closeButton
        }

        Text {
            id: certificateTitleText
            anchors{
                left: closeButton.right
                leftMargin: 18 * pt
                verticalCenter: closeButton.verticalCenter
            }
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: "#3E3853"
            text: qsTr("Create certificate")
        }
    }  //titleRectangle


    Rectangle {
        id: requiredTitle
        width: parent.width
        height: 30 * pt
        y: 38 * pt
        color: "#3E3853"

        Text {
            x: 15 * pt
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
            text: qsTr("Required")
            color: "white"
        }

    }


    Item {
        id: requiredBody
        y: requiredTitle.y + requiredTitle.height
        width: parent.width
        height: 138 * pt

        DapComboBox {
            id: signatureTypeCertificateComboBox
            // x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal    //???

            anchors.verticalCenter: undefined
            x: (parent.width - width) / 2
            y: 13 * pt
            widthPopupComboBoxNormal: 280 * pt
            widthPopupComboBoxActive: 313 * pt
            heightComboBoxNormal: 32 * pt
            heightComboBoxActive: 42 * pt

            comboBoxTextRole: ["name"]
            mainLineText: qsTr("Signature type")
            indicatorImageNormal: "qrc:/resources/icons/Certificates/icon_arrow_down.svg"  //"qrc:/resources/icons/ic_arrow_drop_down_dark.png"
            indicatorImageActive: "qrc:/resources/icons/Certificates/ic_arrow_up.svg"   //qrc:/resources/icons/ic_arrow_drop_up.png"
            sidePaddingNormal: 0 * pt
            sidePaddingActive: 20 * pt
            bottomIntervalListElement: 8 * pt
            paddingTopItemDelegate: 8 * pt
            heightListElement: 42 * pt
            //intervalListElement: 10 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            indicatorLeftInterval: 20 * pt

            normalColorText: "#070023"      //#B4B1B placeholder color
            hilightColorText: "#FFFFFF"
            normalColorTopText: "#070023"
            hilightColorTopText: "#070023"
            hilightColor: "#D51F5D"   //"#330F54"
            normalTopColor: "transparent"
            topEffect: false
            normalColor: "#FFFFFF"
            hilightTopColor: normalColor
            colorTopNormalDropShadow: "#00000000"
            colorDropShadow: "#40ABABAB"
            fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16]
            colorMainTextComboBox: [["#070023", "#070023"]]
            colorTextComboBox: [["#070023", "#FFFFFF"]]
        }


        InputField {
            id: titleCertificateTextInput
            x: (parent.width - width) / 2
            y: 78 * pt
            height: 28 * pt
            width: 277 * pt
            leftPadding: 0
            smartPlaceHolderText: qsTr("Title")
            color: focus ? "#D51F5D" : "#070023"
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
        }


    }  //requiredBody


    Rectangle {
        id: optionalTitle
        width: parent.width
        height: 30 * pt
        y: requiredBody.y + requiredBody.height
        color: "#3E3853"

        Text {
            x: 15 * pt
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
            text: qsTr("Optional")
            color: "white"
        }

    }   //optionalTitle


    Item {
        id: optionalBody
        y: optionalTitle.y + optionalTitle.height
        width: parent.width
        height: parent.height - y

        ColumnLayout {
            id: optionalBodyLayout
            spacing: 24 * pt
            y: spacing
            x: 15 * pt
            width: parent.width - x

            Repeater {
                id: optionalRepeater

                InputField {
                    Layout.preferredHeight: 28 * pt
                    Layout.preferredWidth: 277 * pt
                    leftPadding: 0
                    smartPlaceHolderText: model.placeHolderText
                    color: focus ? "#D51F5D" : "#070023"
                    inputMask: model.inputFieldMask

                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    onEditingFinished: {
                        text = text.trim()
                        optionalRepeater.model.setProperty(model.index, "data", text)
                    }
                }

            }  //


            DapButton {
                id: createButton
                textButton: qsTr("Create")
                Layout.preferredWidth: 132 * pt
                Layout.preferredHeight: 36 * pt
                Layout.alignment: Qt.AlignHCenter

                enabled: root.requiredFieldValid
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


        }  //optionalBodyeLayout


    }  //optionalBody






}   //root



