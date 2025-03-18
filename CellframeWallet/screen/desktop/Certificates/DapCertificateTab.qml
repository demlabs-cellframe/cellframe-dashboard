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
    property string openedRightPanelPage: "emptyRightPanel"
    property int infoIndex: -1

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
            openedRightPanelPage = "createCertificate"
        }

        function openCreateFinishedItem() {
            certScreen.dapDefaultRightPanel.visible = false
            certScreen.dapScreen.infoTitleTextVisibleClick = false
            dapRightPanelFrame.visible = true
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CreateFinishedItem.qml", {"accept": "true", "titleText": "Certificate created\nsuccessfully"})
            openedRightPanelPage = "createFinished"
        }

        function openInfoItem(index) {
            dapRightPanel.pop()

            if(!dapRightPanelFrame.visible)
            {
                dapRightPanelFrame.visible = true
                certScreen.dapDefaultRightPanel.visible = false
            }

            dapRightPanelFrame.visible = true
            certScreen.dapDefaultRightPanel.visible = false
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanels/CertificateInfoItem.qml")
            openedRightPanelPage = "Info"
            infoIndex = index
        }

        function clearRightPanel() {
            dapRightPanelFrame.visible = false
            certScreen.dapDefaultRightPanel.visible = true
            dapRightPanel.clear()
            dapRightPanel.push(emptyRightPanel)
            openedRightPanelPage = "emptyRightPanel"
            infoIndex = -1
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
        target:certificatesModule
        function onSignalImportFinished(status)
        {
            certScreen.dapScreen.infoTitleTextVisibleClick = false
            if(status)
            {
                dapMainWindow.infoItem.showInfo(
                            220,0,
                            dapMainWindow.width*0.5,
                            8,
                            "Certificate is imported",
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")

                certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})
                // logicMainApp.requestToService(DapCertificateCommands.serviceName
                //                             , DapCertificateCommands.GetSertificateList);
            }
            else
            {
                dapMainWindow.infoItem.showInfo(
                            240,0,
                            dapMainWindow.width*0.5,
                            8,
                            "Certificate is not imported",
                            "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
            }
        }
    }
}
