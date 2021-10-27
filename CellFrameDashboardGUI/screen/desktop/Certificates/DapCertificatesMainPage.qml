import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import "qrc:/widgets"
import "parts"


Rectangle
{
    id: dapCertificatesMainPage


    Utils {
        id: utils
    }




    CertificatesModels {
        id: models
    }

    CertificatesLogic{
        id: logics
    }


    HeaderItem {
        id: headerItem
        x: 3 * pt
        width: parent.width
        height: 60 * pt

        onFindHandler: {    //text
            models.certificatesFind.findString = text
            models.certificatesFind.update()
        }
    }



    CertificatesListView {
        id: certificatesListView
        x: 24 * pt
        y: 84 * pt
        height: parent.height - y - 24 * pt
        width: 678 * pt
        infoTitleTextVisible: models.certificates.isSelected


        Component.onCompleted: {
            //need bind delegate with delegateModel
            models.certificatesFind.delegate = delegateComponent
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Public           //default open access type is public
            models.certificatesFind.update()
            model = models.certificatesFind  //original
//            delegate = delegateComponent
//            model = models.certificates
        }

        onSelectedIndex: {   //index
//            if (models.certificates.selectedIndex === index)       //clear selected with repeat click
//                models.certificates.clearSelected()
//            else
              models.certificates.setSelectedIndex(index)
        }

        onInfoClicked: {     //index
            logics.dumpCertificate(index)
            rightPanel.sourceComponent = certificateInfoComponent
        }

    }   //certificatesListView


    Loader {
        id: rightPanel
        anchors {
            right: parent.right
            rightMargin: 26 * pt
        }
        asynchronous: true
        y: certificatesListView.y
        width: 348 * pt
        height: certificatesListView.height
        sourceComponent: certificatesActionsComponent

        onLoaded: {
            item.visible = true
        }

    }  //rightPanel



    Component {
        id: certificatesActionsComponent

        CertificatesActionsButtonList {
            certificateSelected: models.certificates.isSelected
            bothAccessTypeCertificateSelected: models.accessKeyType.bothTypeCertificateSelected
            certificateAccessTypeRepeater.model: models.accessKeyType


            onSelectedAccessKeyType: {               //index
                models.accessKeyType.setSelectedIndex(index)
                models.certificates.clearSelected()
                switch (index) {
                    case 0:      //"public"
                        certificatesListView.seletedCertificateAccessType = qsTr("Public")
                        models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Public
                        models.certificatesFind.update()
                        break;
                    case 1:      //"private"
                        certificatesListView.seletedCertificateAccessType = qsTr("Private")
                        models.certificatesFind.accessKeyTypeIndex = DapCertificateType.PublicAndPrivate
                        models.certificatesFind.update()
                        break;
                    case 2:      //"both"
                        certificatesListView.seletedCertificateAccessType = qsTr("Both")
                        models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Both
                        models.certificatesFind.update()
                        break;
                    default:
                        console.error("Unknown index", index)
                        break;
                }
            }


            createCertificateButton.onClicked: {
                rightPanel.sourceComponent = createCertificateComponent
            }

            exportPublicCertificateToFileButton.onClicked: {
                logics.exportPublicCertificateToFile(models.certificates.selectedIndex)
            }

            exportPublicCertificateToMempoolButton.onClicked: {
                logics.exportPublicCertificateToMempool(models.certificates.selectedIndex)
            }

            deleteCertificateButton.onClicked: {
                 logics.deleteCertificate(models.certificates.selectedIndex)
            }

            //TODO
//            importCertificateButton
//            addSignatureToCertificateButton

        }  //
    }  //certificatesActionsComponent


    Component {
        id: createCertificateComponent
        CreateCertificateItem {
            optionalModel: models.createCertificateOptional
            signatureTypeCertificateComboBox.model: models.signatureType
            requiredFieldValid: false //TODO

            function checkRequiredField(){
                requiredFieldValid = titleCertificateTextInput.text.length > 0
                                     && signatureTypeCertificateComboBox.currentIndex >= 0
            }

            function checkOptionalField(){
                for (var i = 0; i < models.createCertificateOptional.count; ++i) {
                    var optionalField = models.createCertificateOptional.get(i)
                    var data = optionalField.data
                    switch (optionalField.key) {
                        case "domain":
                            if (data !== "" && !utils.validDomain(optionalField.data)) {
                                messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                                       , "Please fill field correctly.")
                                return false;
                            }
                            break;
                        case "expiration_date":
                            if (data !== "" && !utils.validDate(optionalField.data)) {
                                messagePopup.smartOpen(qsTr("%1 not correct").arg(optionalField.placeHolderText)
                                                       , "Please fill field correctly.")
                                return false;
                            }
                            break;
                        case "email":
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

            signatureTypeCertificateComboBox.onCurrentIndexChanged: {
                checkRequiredField()
            }

            closeButton.onClicked: {
                rightPanel.sourceComponent = certificatesActionsComponent
            }

            createButton.onClicked: {   //enabled when requiredFieldValid
                if (checkOptionalField())
                    logics.createCertificate(titleCertificateTextInput.text
                                             , models.signatureType.get(signatureTypeCertificateComboBox.currentIndex).signature
                                             , models.createCertificateOptional.getDataToJson())
                else
                    console.warn("not valid optional field")
            }

            titleCertificateTextInput.onEditingFinished: {
                checkRequiredField()
            }

            titleCertificateTextInput.onTextChanged: {
                checkRequiredField()
            }


        }
    }  //createCertificateComponent

    Component {
        id: createFinishedItemComponent
        CreateFinishedItem {
            doneButton.onClicked: {
                rightPanel.sourceComponent = certificatesActionsComponent
            }
        }
    }

    Component {
        id: certificateInfoComponent
        CertificateInfoItem {
            certificateDataListView.model: models.certificateInfo
            closeButton.onClicked: {
                rightPanel.sourceComponent = certificatesActionsComponent
            }
        }
    }


    Popup{
        id: messagePopup
        closePolicy: "NoAutoClose"
        padding: 0
        background: Item { }
        width: dapMessageBox.width
        height: dapMessageBox.height
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true

        function smartOpen(title, contentText) {
            dapMessageBox.dapTitleText.text = title
            dapMessageBox.dapContentText.text = contentText
            open()
        }

        DapMessageBox {
            id: dapMessageBox
            width: 240 * pt
            height: 240 * pt
            dapButtonOk.onClicked: {
                messagePopup.close()
            }
        }
    }





    Loader {
        id: blockBusyIndicatorLoader
        active: logics.requestRunning
        width: parent.width
        height: parent.height
        sourceComponent: Component {
            Popup{
                id: messagePopup
                closePolicy: "NoAutoClose"
                padding: 0
                background: Rectangle{
                    width: parent.width
                    height: parent.height
                    radius: 12 * pt
                }
                width: dapMessageBox.width
                height: dapMessageBox.height
                x: (blockBusyIndicatorLoader.width - width) / 2
                y: (blockBusyIndicatorLoader.height - height) / 2
                modal: true

                BusyIndicator {
                    anchors.centerIn: parent
                    width: 120 * pt
                    height: 120 * pt
                    running: true
                }
            }
        }

        onLoaded: {
            item.parent = dapCertificatesMainPage
            item.open()
        }
    }   //





}   //dapCertificatesMainPage
