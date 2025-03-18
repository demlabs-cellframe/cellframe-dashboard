import QtQuick 2.0
import DapCertificateManager.Commands 1.0


Item {
    id: root

    //сигнализирует о выполнении запроса когда запущен реквест
//    property bool requestRunning: false

    Component.onCompleted: {
        certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})
    }

    Connections
    {
        target: dapServiceController

        function onCertificateManagerOperationResult(rcvData) {
            var jsonDocument = JSON.parse(rcvData)
            var result = jsonDocument.result
            
            if (!result) {
                console.error("result is empty")
                return
            }

//            utils.beatifulerJSONKeys(result, "onCertificateManagerOperationResult");    //for test

//            requestRunning = false

            //common error message box
            if (result.status !== DapCertificateCommands.statusOK) {
                console.error("execute command %1, message %2"
                              .arg(DapCertificateCommands.commandToString(result.command)).arg(result.errorMessage))
                messagePopup.smartOpen("Error", result.errorMessage)
            }


            switch (result.command) {
                case DapCertificateCommands.UnknownCommand:    //0
                    console.warn("DapCertificateCommands.UnknownCommand")
                    break;
                case DapCertificateCommands.GetSertificateList:
                    if (!Array.isArray(result.data)) {
                        console.error("result.data not array")
                        return
                    }

                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.parseFromCertList(result.data)
                    }

                    break;
                case DapCertificateCommands.CreateCertificate:
                    if (!(typeof result.data === "object")) {
                        console.error("result.data not object")
                        return
                    }
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.prependFromObject(result.data)
                        models.certificates.clearSelected()
                        certificateNavigator.openCreateFinishedItem()
                    }
                    break;
                case DapCertificateCommands.DumpCertifiacate:
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificateInfo.clear()

                        models.certificateInfo.append({   key: "signature",
                                                          keyView: qsTr("Signature type")
                                                        , value: models.signatureKeyToViewName[result.data.signature] } )
                        models.certificateInfo.append({   key: "name",
                                                          keyView: qsTr("Title")
                                                        , value: result.data.name } )

                        for (var i in result.data.metadata) {
                            var metadataElement = result.data.metadata[i]

                            var keyView = models.metadataKeyToViewKey[metadataElement.key]
                             models.certificateInfo.append({
                                                                 key: metadataElement.key
                                                               , keyView: keyView ? keyView : metadataElement.key
                                                               , value: metadataElement.value
                                                           })
                        }
                    }
                    break;
                case DapCertificateCommands.ImportCertificate:
                    //TODO
                    break;
                case DapCertificateCommands.ExportPublicCertificateToFile:
                    if (!(typeof result.data === "object")) {
                        console.error("result.data not object")
                        return
                    }
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.clearSelected()
                        models.certificates.prependFromObject(result.data)
                        showResultPopup(true, qsTr("Certificate exported"), 210)
                    }
                    else
                    {
                        showResultPopup(false, qsTr("Error export certificate"), 210)
                    }



                    break;
                case DapCertificateCommands.ExportPublicCertificateToMempool:

                    if (!(typeof result.data === "object")) {
                        console.error("result.data not object")
                        return
                    }

                    if (result.status === DapCertificateCommands.statusOK) {
//                        messagePopup.smartOpen("Certificate", "Success export to mempool\ncertificate: %1\nnetwork: %2"
//                                               .arg(result.data.certName).arg(result.data.network))
                    }

                    break;
                case DapCertificateCommands.AddSignatureToCertificate:
                    //TODO
                    break;
                case DapCertificateCommands.DeleteCertificate:
                    if (result.status === DapCertificateCommands.statusOK) {
//                        messagePopup.smartOpen("Certificate", qsTr("Certificate deleted\n%1").arg(result.data.deletedFilePath))
                        models.certificates.removeByProperty("filePath", result.data.deletedFilePath)
                        models.certificates.clearSelected()
                        showResultPopup(true, qsTr("Certificate deleted"), 210)

                        return
                    }
                    else
                    {
                        showResultPopup(false, qsTr("Error delete certificate"), 210)
                    }

                    break;

                    //пока что неиспользуемый сценарий
                case DapCertificateCommands.UpdateCertificateList:    //уведомление только если изменяется папка сертификатов вручную
                    if (!Array.isArray(result.data)) {
                        console.error("result.data not array")
                        return
                    }
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.parseFromCertList(result.data)
                    }

                    break;
                default:
                    console.error("onCertificateManagerOperationResult not valid command")
                    break;
            }   //switch
        }   //onCertificateManagerOperationResult:
    }   //target: dapServiceController

    function createCertificate(certName, certType, metaData){     //metaData  is array of { type, , value }
        console.info("FLOWPOINT createCertificate", certName, certType)

        var createCertRequest = {"certCommandNumber": DapCertificateCommands.CreateCertificate,
                                "certName": certName,
                                "signCert": certType
                                }

        for (var key in metaData) {
            createCertRequest[key] = metaData[key]
        }
        certificatesModule.requestCommand(createCertRequest)
        certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})

    }


    //получение информации о сертификате
    function dumpCertificate(index){
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT dumpCertificate, index", index)

        if (cert) {

            certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.DumpCertifiacate,
                                              "certName": cert.completeBaseName,
                                              "pathCert": cert.filePath})
        } else
            console.error("not valid index", index)
    }


    function exportPublicCertificateToFile(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT exportPublicCertificateToFile")

        if (cert) {
            var certName = cert.completeBaseName

            certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.ExportPublicCertificateToFile,
                                              "certName": certName,
                                              "newCertName": certName + "_public"})
            certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})
        } else
            console.error("not valid index", index)
    }


    function exportPublicCertificateToMempool(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT exportPublicCertificateToMempool, index", index)

        if (cert && dapServiceController.CurrentNetwork !== "") {
//            requestRunning = true           //долгий запрос, требует индикации

            // logicMainApp.requestToService(DapCertificateCommands.serviceName
            //                                       , DapCertificateCommands.ExportPublicCertificateToMempool
            //                                       , dapServiceController.CurrentNetwork, cert.completeBaseName);
            // logicMainApp.requestToService(DapCertificateCommands.serviceName
            //                                       , DapCertificateCommands.GetSertificateList
            //                                       );
        } else
            console.error("not valid index or network", index, dapServiceController.CurrentNetwork)
    }



    function deleteCertificate(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT deleteCertificate, index", index)

        if (cert)
        {
            certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.ExportPublicCertificateToFile,
                                              "pathCert": cert.filePath})
            certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})

        }

        else
            console.error("not valid index", index)         //
    }

    function showResultPopup(status, text, width)
    {
        if(status)
        {
            dapMainWindow.infoItem.showInfo(
                        width,0,
                        dapMainWindow.width*0.5,
                        8,
                        text,
                        "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
        }
        else
        {
            dapMainWindow.infoItem.showInfo(
                        width,0,
                        dapMainWindow.width*0.5,
                        8,
                        text,
                        "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
        }
    }


    //TODO Import certificate
    //TODO Add signature to certificate



}  //root
