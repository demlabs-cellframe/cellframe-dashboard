import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12 as Controls
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../parts"
import "../models"
import "../../controls"


DapRectangleLitAndShaded {
    id: root
    property alias closeButton: itemButtonClose
    property alias createButton: createButton
    property alias optionalModel: optionalRepeater.model
    property alias signatureTypeCertificateComboBox: signatureTypeCertificateComboBox
    property alias titleCertificateTextInput: titleCertificateTextInput

    property bool requiredFieldValid: false

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0

    function checkRequiredField()
    {
        requiredFieldValid = titleCertificateTextInput.text.length > 0 && titleCertificateTextInput.text.length < 40
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
                                           {"accept": false, "titleText": qsTr("Certificate not created."),
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
                                           {"accept": false, "titleText": qsTr("Certificate not created."),
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
                                           {"accept": false, "titleText": qsTr("Certificate not created."),
                                           "contentText": qsTr("%1 not correct. Please fill field correctly.").arg(optionalField.placeHolderText)})
                        return false;
                    }
                    break;
            }
        }

        return true;
    }

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 
            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: certificateNavigator.clearRightPanel()
            }

            Text
            {
                id: textHeader
                text: qsTr("Create certificate")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        Rectangle {
            id: requiredTitle
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Required")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        ColumnLayout {
            id: requiredBody
            Layout.fillWidth: true
            height: 139 
            spacing: 0

            DapCertificatesComboBox
            {
                id: signatureTypeCertificateComboBox
                height: 42
                Layout.topMargin: 10
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 18

                onCurrentIndexChanged:
                {
                    checkRequiredField()
                }
            }

            DapTextField
            {
                id: titleCertificateTextInput
                placeholderText: qsTr("Title")
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                height: 28
                Layout.fillWidth: true
                Layout.leftMargin: 31
                Layout.rightMargin: 18
                Layout.topMargin: 5

                selectByMouse: true
                DapContextMenu{}

                onTextChanged: checkRequiredField()
                onEditingFinished: {
                        checkRequiredField()
                    }


                validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\.\-]+/ }

            }
            Rectangle //bottom line
            {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 5
                Layout.leftMargin: 39
                Layout.rightMargin: 39
                height: 1
                color: currTheme.input
            }
        }  //requiredBody

        Rectangle {
            id: optionalTitle
            color: currTheme.mainBackground
            height: 30 
            Layout.fillWidth: true
            Layout.topMargin: 20

            Text {
                color: currTheme.white
                text: qsTr("Optional")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }   //optionalTitle


        Item {
            id: optionalBody
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 20

            ColumnLayout {
                id: optionalBodyLayout
                spacing: 16
                anchors.left: parent.left
                anchors.right: parent.right

                Repeater {
                    id: optionalRepeater
                    model: models.createCertificateOptional

                    DapTextField {
                        Layout.leftMargin: 31
                        Layout.rightMargin: 31
                        Layout.preferredHeight: 29
                        Layout.fillWidth: true
                        placeholderText: model.placeHolderText
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\_\:\(\)\?\@\.\-]+/ }

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

                        bottomLineVisible: true
                        bottomLineSpacing: 5
                        bottomLineLeftRightMargins: 8

                        selectByMouse: true
                        DapContextMenu{}
                    }
                }  //
            }  //optionalBodyeLayout
        }  //optionalBody

        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        DapButton {
            id: createButton
            implicitHeight: 36
            implicitWidth: 132

            enabled: root.requiredFieldValid

            Layout.bottomMargin: 20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Create")
            horizontalAligmentText: Text.AlignHCenter
            indentTextRight: 0
            fontButton: mainFont.dapFont.medium14

            onClicked: {   //enabled when requiredFieldValid
                if (checkOptionalField())
                    logics.createCertificate(titleCertificateTextInput.text
                                             , signatureTypeCertificateComboBox.selectedSignature
                                             , models.createCertificateOptional.getDataToJson())
                else
                    console.warn("not valid optional field")
            }
        }
    }
}   //root
