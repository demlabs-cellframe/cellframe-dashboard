import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
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
    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle

    implicitWidth: 100
    implicitHeight: 200

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    Rectangle
    {
        id:frameRightPanel
        anchors.fill: parent
        color: parent.color
        radius: parent.radius


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
                    leftMargin: 8 * pt
                    verticalCenter: closeButton.verticalCenter
                }
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
                text: qsTr("Create certificate")
            }
        }  //titleRectangle


        Rectangle {
            id: requiredTitle
            width: parent.width
            height: 30 * pt
            y: 38 * pt
            color: currTheme.backgroundMainScreen

            Text {
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: qsTr("Required")
                color: currTheme.textColor
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
                widthPopupComboBoxNormal: 300 * pt
                widthPopupComboBoxActive: 300 * pt
                heightComboBoxNormal: 42 * pt
                heightComboBoxActive: 42 * pt

                comboBoxTextRole: ["name"]
                mainLineText: qsTr("Signature type")
                indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                sidePaddingNormal: 19 * pt
                sidePaddingActive: 19 * pt
                paddingTopItemDelegate: 8 * pt
    //            bottomIntervalListElement: 8 * pt
                heightListElement: 42 * pt
                //intervalListElement: 10 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                indicatorLeftInterval: 20 * pt
                roleInterval: 15

                normalColor: currTheme.backgroundMainScreen
                normalTopColor: currTheme.backgroundElements
                hilightTopColor: currTheme.backgroundMainScreen
                hilightColor: currTheme.buttonColorNormal

                topEffect: false
                colorTopNormalDropShadow: "#00000000"
                colorDropShadow: currTheme.shadowColor

                fontComboBox: [dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]

            }


            TextField {
                id: titleCertificateTextInput
                x: (parent.width - width) / 2
                y: 78 * pt
                height: 28 * pt
                width: 277 * pt
                placeholderText: qsTr("Title")
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                style:
                    TextFieldStyle
                    {
                        textColor: currTheme.textColor
                        placeholderTextColor: currTheme.textColor
                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: currTheme.backgroundElements
                            }
                    }
            }
            Rectangle //bottom line
            {
                anchors
                {
                    left: titleCertificateTextInput.left
                    right: titleCertificateTextInput.right
                    top: titleCertificateTextInput.bottom
                }
                height: 1 * pt
                color: currTheme.borderColor
            }


        }  //requiredBody


        Rectangle {
            id: optionalTitle
            width: parent.width
            height: 30 * pt
            y: requiredBody.y + requiredBody.height
            color: currTheme.backgroundMainScreen

            Text {
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                text: qsTr("Optional")
                color: currTheme.textColor
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
                        Layout.leftMargin: 20 * pt
                        Layout.preferredHeight: 28 * pt
                        Layout.preferredWidth: 277 * pt
                        leftPadding: 0
                        smartPlaceHolderText: model.placeHolderText
    //                    color: focus ? currTheme.textColor : currTheme.textColor
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

                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    horizontalAligmentText: Qt.AlignHCenter
                }


            }  //optionalBodyeLayout


        }  //optionalBody
    } //frameRightPanel
    InnerShadow {
        id: topLeftSadow
        anchors.fill: frameRightPanel
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: frameRightPanel
        visible: frameRightPanel.visible
    }
    InnerShadow {
        anchors.fill: frameRightPanel
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: frameRightPanel.visible
    }

}   //root



