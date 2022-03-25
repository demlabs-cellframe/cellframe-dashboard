import QtQuick 2.0
import DapCertificateManager.Commands 1.0


/*
      reply from service format
      result = {
                    command: <enumcommand>
                    status: "OK" | "FAIL",
                    errorMessage: "",            //optional when error
                    data: ...                    //empty or object or array
               }
*/



Item {
    id: root

    //сигнализирует о выполнении запроса когда запущен реквест
    property bool requestRunning: false


    Component.onCompleted: {
        dapServiceController.requestToService(DapCertificateCommands.serviceName
                                              , DapCertificateCommands.GetSertificateList
                                              );
    }



    Connections
    {
        target: dapServiceController

        onCertificateManagerOperationResult: {   //const QVariant& result
            if (!result) {
                console.error("result is empty")
                return
            }

            utils.beatifulerJSONKeys(result, "onCertificateManagerOperationResult");    //for test
            //messagePopup.smartOpen("Certificate", "result.errorMessage")

            requestRunning = false

            //common error message box
            if (result.status !== DapCertificateCommands.statusOK) {
                console.error("execute command %1, message %2"
                              .arg(DapCertificateCommands.commandToString(result.command)).arg(result.errorMessage))
                messagePopup.smartOpen("Certificate", result.errorMessage)
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
                    //utils.beatifulerJSON(result.data, "DapCertificateCommands.CreateCertificate")   //for test
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.prependFromObject(result.data)
                        models.certificates.clearSelected()
                        certificateNavigator.openCreateFinishedItem()
                    }
                    break;
                case DapCertificateCommands.DumpCertifiacate:
                    //utils.beatifulerJSON(result, "DapCertificateCommands.DumpCertifiacate");    //for test
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
//                            switch (metadataElement.key) {      //date format
//                                case "creation_date":
//                                case "expiration_date": {
//                                      //TODO need save date to ISO
//                                    metadataElement.value = Qt.formatDate(new Date(metadataElement.value, '.', '-'), "dd MMM, yyyy")
//                                    }
//                                    break;
//                            }

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
                    //utils.beatifulerJSON(result.data, "DapCertificateCommands.ExportPublicCertificateToFile")   //for test
                    if (!(typeof result.data === "object")) {
                        console.error("result.data not object")
                        return
                    }
                    if (result.status === DapCertificateCommands.statusOK) {
                        models.certificates.clearSelected()
                        models.certificates.prependFromObject(result.data)
                        messagePopup.smartOpen("Certificate", "Public certificate created, file path:\n%1".arg(result.data.filePath))
                    }

                    break;
                case DapCertificateCommands.ExportPublicCertificateToMempool:
                    //utils.beatifulerJSON(result, "DapCertificateCommands.ExportPublicCertificateToMempool")     //for test

                    if (!(typeof result.data === "object")) {
                        console.error("result.data not object")
                        return
                    }

                    if (result.status === DapCertificateCommands.statusOK) {
                        messagePopup.smartOpen("Certificate", "Success export to mempool\ncertificate: %1\nnetwork: %2"
                                               .arg(result.data.certName).arg(result.data.network))
                    }

                    break;
                case DapCertificateCommands.AddSignatureToCertificate:
                    //TODO
                    break;
                case DapCertificateCommands.DeleteCertificate:
                    //utils.beatifulerJSON(result.data, "DapCertificateCommands.DeleteCertificate");    //for test                   
                    if (result.status === DapCertificateCommands.statusOK) {
                        messagePopup.smartOpen("Certificate", qsTr("Certificate deleted\n%1").arg(result.data.deletedFilePath))
                        models.certificates.removeByProperty("filePath", result.data.deletedFilePath)
                        models.certificates.clearSelected()
                        return
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


   //format "id", "fileName", "completeBaseName", "filePath", "dirType", "accessKeyType"

    function createCertificate(certName, certType, metaData){     //metaData  is array of { type, , value }
        console.info("FLOWPOINT createCertificate", certName, certType)

        dapServiceController.requestToService(DapCertificateCommands.serviceName
                                              , DapCertificateCommands.CreateCertificate
                                              , certName, certType
                                              , JSON.stringify(metaData));
    }


    //получение информации о сертификате
    function dumpCertificate(index){
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT dumpCertificate, index", index)

        if (cert) {
            dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                  , DapCertificateCommands.DumpCertifiacate
                                                  , cert.completeBaseName, cert.filePath);   //completeBaseName
        } else
            console.error("not valid index", index)
    }


    function exportPublicCertificateToFile(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT exportPublicCertificateToFile")

        if (cert) {
            var certName = cert.completeBaseName
            dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                  , DapCertificateCommands.ExportPublicCertificateToFile
                                                  , certName, certName + "_public" );
        } else
            console.error("not valid index", index)
    }


    function exportPublicCertificateToMempool(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT exportPublicCertificateToMempool, index", index)

        if (cert && dapServiceController.CurrentNetwork !== "") {
            requestRunning = true           //долгий запрос, требует индикации
            dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                  , DapCertificateCommands.ExportPublicCertificateToMempool
                                                  , dapServiceController.CurrentNetwork, cert.completeBaseName);
        } else
            console.error("not valid index or network", index, dapServiceController.CurrentNetwork)
    }



    function deleteCertificate(index){     //index from certificates model
        var cert = models.certificates.get(index)
        console.info("FLOWPOINT deleteCertificate, index", index)

        if (cert)
            dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                  , DapCertificateCommands.DeleteCertificate
                                                  , cert.filePath);
        else
            console.error("not valid index", index)         //
    }


    //TODO Import certificate
    //TODO Add signature to certificate



}  //root



/* simple stress test rpc


    property int count: 10000
    property int calcCount: 0
    property var commandQueue: []


    Component.onCompleted: {
        for (var i = 0; i < count; ++i) {
            var comand =  Math.floor(Math.random() * 10000 % DapCertificateCommands.UpdateCertificateList)
            //console.info("send comand:", comand)
            commandQueue.push(comand)

            dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                  , comand);
        }
    }


    Connections
    {
        target: dapServiceController
        onCertificateManagerOperationResult: {   //const QVariant& result
            if (commandQueue[root.calcCount] === comand)
                calcCount++
            if (root.count === root.calcCount)
                console.info("stress test success")
        }

    }   //target: dapServiceController

*/
