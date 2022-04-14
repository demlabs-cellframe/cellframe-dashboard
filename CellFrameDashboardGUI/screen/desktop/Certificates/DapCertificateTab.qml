import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "../../"
import "../controls"
import "RightPanels"

DapPage
{
    Utils {
        id: utils
    }

    CertificatesModels {
        id: models
    }

    CertificatesLogic{
        id: logics
    }

    QtObject {
        id: certificateNavigator

        function openCreateCertificateItem() {
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateCertificateItem.qml")
        }

        function openCreateFinishedItem() {
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml", {"accept": "true", "titleText": "Certificate created\nsuccessfully"})
        }

        function clearRightPanel() {
            dapRightPanel.pop(null)
        }

        function openInfoItem() {
            if (dapRightPanel.depth > 0)
                dapRightPanel.pop(null)
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CertificateInfoItem.qml")
        }
    }

    dapHeader.initialItem: DapSearchTopPanel
    {
        onFindHandler: {    //text
            models.certificatesFind.findString = text
            models.certificatesFind.accessKeyTypeIndex = models.accessKeyType.selectedIndex
            models.certificatesFind.update()
        }
    }

    dapScreen.initialItem: DapCertificateScreen {}

    dapRightPanel.initialItem: DapCertificateAtcions {}

    Connections{
        target:importCertificate
        onSignalImportFinished:
        {
            if(status)
                dapServiceController.requestToService(DapCertificateCommands.serviceName
                                                      , DapCertificateCommands.GetSertificateList
                                                      );
        }
    }
}
