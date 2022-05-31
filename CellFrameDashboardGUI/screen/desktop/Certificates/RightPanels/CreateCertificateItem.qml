import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12 as Controls
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../parts"
import "../models"


Controls.Page {
    id: root
    property alias closeButton: itemButtonClose
    property alias createButton: createButton
    property alias optionalModel: optionalRepeater.model
    property alias signatureTypeCertificateComboBox: signatureTypeCertificateComboBox
    property alias titleCertificateTextInput: titleCertificateTextInput

    property bool requiredFieldValid: false

    background: Rectangle {
        color: "transparent"
    }

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0

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
                        //messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                          //                     , "Please fill field correctly.")
                        dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml",
                                           {"accept": false, "titleText": "Certificate not created.",
                                           "contentText": qsTr("%1 not correct. Please fill field correctly.").arg(optionalField.placeHolderText)})

                        return false;
                    }
                    break;
                case "a1_expiration_date":
                {
                    if (data === "..")
                    {
                        models.createCertificateOptional.setProperty(i, "data", "")
                        data = ""
                    }

                    var locale = Qt.locale()
                    var dataDate = Date.fromLocaleDateString(locale, data, "dd.MM.yyyy")
                    var day = new Date()
                    var nextDay = new Date(day)
                    nextDay.setDate(day.getDate() + 1)

                    if (data !== "" && (!utils.validDate(optionalField.data) || dataDate < nextDay || data.length !== 10)) {
                        //messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                          //                     , "Please fill field correctly.")
                        dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml",
                                           {"accept": false, "titleText": "Certificate not created.",
                                           "contentText": qsTr("%1 not correct. Please fill field correctly.").arg(optionalField.placeHolderText)})
                        return false;
                    }
                }
                    break;
                case "a5_email":
                    if (data !== "" && !utils.validEmail(optionalField.data)) {
                        //messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                               //, "Please fill field correctly.")
                        dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml",
                                           {"accept": false, "titleText": "Certificate not created.",
                                           "contentText": qsTr("%1 not correct. Please fill field correctly.").arg(optionalField.placeHolderText)})
                        return false;
                    }
                    break;
            }
        }

        return true;
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt
            DapButton
            {
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 9 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
                onClicked: certificateNavigator.clearRightPanel()
            }

            Text
            {
                id: textHeader
                text: qsTr("Create certificate")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        Rectangle {
            id: requiredTitle
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Required")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item {
            id: requiredBody
            Layout.fillWidth: true
            height: 139 * pt

            DapComboBox {
                id: signatureTypeCertificateComboBox

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
                heightListElement: 42 * pt
                indicatorWidth: 24 * pt
                indicatorHeight: indicatorWidth
                indicatorLeftInterval: 20 * pt
                roleInterval: 15
                normalColor: currTheme.backgroundMainScreen
                normalTopColor: currTheme.backgroundElements
                hilightTopColor: currTheme.backgroundMainScreen

                topEffect: false
                colorTopNormalDropShadow: "#00000000"
                colorDropShadow: currTheme.shadowColor

                fontComboBox: [mainFont.dapFont.regular16]
                colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
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

                font: mainFont.dapFont.regular18
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
            color: currTheme.backgroundMainScreen
            height: 30 * pt
            Layout.fillWidth: true

            Text {
                color: currTheme.textColor
                text: qsTr("Optional")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 21 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 7 * pt
            }

        }   //optionalTitle


        Item {
            id: optionalBody
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

                        onFocusChanged:
                        {
                            if (focus)
                                inputMask = model.inputFieldMask;
                            else if (text == "..")
                                inputMask = ""
                        }

                        onTextChanged: {optionalRepeater.model.setProperty(model.index, "data", text)}

                        onVisibleChanged: {optionalRepeater.model.setProperty(model.index, "data", text)}

                        font: mainFont.dapFont.regular16
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
                        width: 132 * pt
                        height: 36 * pt
                        x: parent.width * 0.5 - width * 0.5
                        y: parent.height - height

                        enabled: root.requiredFieldValid

                        fontButton: mainFont.dapFont.regular16
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
}   //root
