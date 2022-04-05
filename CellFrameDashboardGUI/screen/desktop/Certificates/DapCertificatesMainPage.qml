import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "../../"
import "qrc:/screen/controls"
import "RightPanel"

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
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanel/CreateCertificateItem.qml")
        }

        function openCreateFinishedItem() {
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanel/CreateFinishedItem.qml")
        }

        function clearRightPanel() {
            dapRightPanel.pop(null)
        }

        function openInfoItem() {
            dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanel/CertificateInfoItem.qml")
        }
    }

    dapHeader.initialItem: CertificateTopPanel {}

    dapScreen.initialItem: CertificateScreen {}

    dapRightPanel.initialItem: CertificateActions {}
}
