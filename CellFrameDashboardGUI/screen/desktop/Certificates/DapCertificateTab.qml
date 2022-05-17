import QtQuick 2.9
import QtQml 2.12
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

    property alias dapCertScreen: certScreen

    Component{id: emptyRightPanel; Item{}}

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
            certScreen.dapDefaultRightPanel.visible = false
            dapRightPanelFrame.visible = true
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateCertificateItem.qml")
        }

        function openCreateFinishedItem() {
            certScreen.dapDefaultRightPanel.visible = false
            dapRightPanelFrame.visible = true
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml", {"accept": "true", "titleText": "Certificate created\nsuccessfully"})
        }

        function openInfoItem() {
            dapRightPanel.pop()

            if(!dapRightPanelFrame.visible)
            {
                dapRightPanelFrame.visible = true
                certScreen.dapDefaultRightPanel.visible = false
            }

            dapRightPanelFrame.visible = true
            certScreen.dapDefaultRightPanel.visible = false
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CertificateInfoItem.qml")
        }

        function clearRightPanel() {
            dapRightPanelFrame.visible = false
            certScreen.dapDefaultRightPanel.visible = true
            dapRightPanel.clear()
            dapRightPanel.push(emptyRightPanel)
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

    dapScreen.initialItem: DapCertificateScreen {id: certScreen}

    dapRightPanel.initialItem: emptyRightPanel
//    dapRightPanel.initialItem: DapCertificateAtcions {}

    dapRightPanelFrame.visible: false

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
