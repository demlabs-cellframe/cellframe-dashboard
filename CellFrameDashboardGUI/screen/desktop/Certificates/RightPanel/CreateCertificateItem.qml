import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../parts"
import "../models"


Rectangle {
    id: root
    //property var models
    //property var dapRightPanel
    property alias closeButton: closeButton
    property alias createButton: createButton
    property alias optionalModel: optionalRepeater.model
    property alias signatureTypeCertificateComboBox: signatureTypeCertificateComboBox
    property alias titleCertificateTextInput: titleCertificateTextInput


    //optionalModel: certModels.createCertificateOptional

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

    function checkRequiredField(){
        requiredFieldValid = titleCertificateTextInput.text.length > 0
                             && signatureTypeCertificateComboBox.currentIndex >= 0
    }


    function checkOptionalField(){
        for (var i = 0; i < models.createCertificateOptional.count; ++i) {
            var optionalField = models.createCertificateOptional.get(i)
            var data = optionalField.data
            switch (optionalField.key) {
                case "a2_domain":
                    if (data !== "" && !utils.validDomain(optionalField.data)) {
                        messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                               , "Please fill field correctly.")
                        return false;
                    }
                    break;
                case "a1_expiration_date":
                {
                    var locale = Qt.locale()
                    var dataDate = Date.fromLocaleDateString(locale, data, "dd.MM.yyyy")
                    var day = new Date()
                    var nextDay = new Date(day)
                    nextDay.setDate(day.getDate() + 1)

                    if (data !== "" && (!utils.validDate(optionalField.data) || dataDate < nextDay)) {
                        messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                               , "Please fill field correctly.")
                        return false;
                    }
                }
                    break;
                case "a5_email":
                    if (data !== "" && !utils.validEmail(optionalField.data)) {
                        messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                               , "Please fill field correctly.")
                        return false;
                    }
                    break;
            }
        }

        return true;
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        Item
        {
            anchors.fill: parent

            Item {
                id: titleRectangle
                width: parent.width
                height: 35 * pt

                CloseButton {
                    id: closeButton

                    onClicked: {
                           dapRightPanel.pop()
                        }
                }

                Text {
                    id: certificateTitleText
                    anchors{
                        left: closeButton.right
                        leftMargin: 13 * pt
                        verticalCenter: parent.verticalCenter
                    }
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                    color: currTheme.textColor
                    text: qsTr("Create certificate")
                }

            }  //titleRectangle


            Rectangle {
                id: requiredTitle
                width: parent.width
                height: 30 * pt
                y: 35 * pt
                color: currTheme.backgroundMainScreen

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium13
                    text: qsTr("Required")
                    color: currTheme.textColor
                }

            }


            Item {
                id: requiredBody
                y: requiredTitle.y + requiredTitle.height
                width: parent.width
                height: 139 * pt

                DapComboBox {
                    id: signatureTypeCertificateComboBox
                    // x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal    //???

                    anchors.verticalCenter: undefined
                    x: (parent.width - width) / 2
                    y: 15 * pt
                    widthPopupComboBoxNormal: 316 * pt
                    widthPopupComboBoxActive: 316 * pt
                    heightComboBoxNormal: 42 * pt
                    heightComboBoxActive: 42 * pt
                    model: models.signatureType

                    onCurrentIndexChanged: {
                            checkRequiredField()
                        }

                    comboBoxTextRole: ["name"]
                    mainLineText: qsTr("Signature type")
                    indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                    indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                    sidePaddingNormal: 19 * pt
                    sidePaddingActive: 19 * pt
                    paddingTopItemDelegate: 11 * pt
                    currentIndex: -1
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
                    //recomendedText: "Crystal-Dylithium"

                    topEffect: false
                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: currTheme.shadowColor

                    fontComboBox: [_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16]
                    colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
//                    colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                }


                InputField {
                    id: titleCertificateTextInput
                    x: parent.width * 0.5 - width * 0.5
                    y: parent. height - height - 33 * pt
                    height: 28 * pt
                    width: 280 * pt
                    leftPadding: 0
                    smartPlaceHolderText: qsTr("Title")
                    validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }
                    maximumLength: 39

                    onTextChanged: checkRequiredField()
                    onEditingFinished: {
                            checkRequiredField()
                        }

                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                }


/*                TextField {
                    id: titleCertificateTextInput
                    x: 35 * pt
                    y: 78 * pt
                    height: 28 * pt
                    width: 277 * pt
                    placeholderText: qsTr("Title")
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
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
                }*/
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
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium13
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
                    y: spacing - 3 * pt
                    //x: 15 * pt
                    width: parent.width - x

                    Repeater {
                        id: optionalRepeater
                        model: models.createCertificateOptional

                        InputField {
                            Layout.leftMargin: 39 * pt
                            Layout.preferredHeight: 28 * pt
                            Layout.preferredWidth: 277 * pt
                            leftPadding: 0
                            smartPlaceHolderText: model.placeHolderText
                            textAndLineSpacing: 3 * pt
        //                    color: focus ? currTheme.textColor : "#C7C6CE"
                            //inputMask: model.inputFieldMask

                            onFocusChanged:
                            {
                                if (focus)
                                    inputMask = model.inputFieldMask;
                                else if (text == "..")
                                    inputMask = ""
                            }


                            onVisibleChanged: {optionalRepeater.model.setProperty(model.index, "data", "")}

                            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                            onEditingFinished: {
                                text = text.trim()
                                optionalRepeater.model.setProperty(model.index, "data", text)
                            }
                        }

                    }  //

                    Item
                    {
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: createButton.height + 10 * pt

                    DapButton {
                        id: createButton
                        textButton: qsTr("Create")
                        //Layout.preferredWidth: 132 * pt
                        //Layout.preferredHeight: 36 * pt
                        //Layout.alignment: Qt.AlignHCenter
                        width: 132 * pt
                        height: 36 * pt
                        x: parent.width * 0.5 - width * 0.5
                        y: parent.height - height

                        enabled: root.requiredFieldValid

                        fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                        horizontalAligmentText: Qt.AlignHCenter

                        onClicked: {   //enabled when requiredFieldValid
                                if (checkOptionalField())
                                    logics.createCertificate(titleCertificateTextInput.text
                                                             , models.signatureType.get(signatureTypeCertificateComboBox.currentIndex).signature
                                                             , models.createCertificateOptional.getDataToJson())
                                else
                                    console.warn("not valid optional field")
                            }
                    }
                    }

                }  //optionalBodyeLayout

            }  //optionalBody
        }
    } //frameRightPanel

}   //root
