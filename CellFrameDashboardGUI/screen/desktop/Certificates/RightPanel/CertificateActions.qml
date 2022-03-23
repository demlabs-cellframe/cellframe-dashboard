import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../parts"
import "../../../"
import "../"
import "qrc:/screen/controls"



CertificatesActionsButtonList
{
    certificateSelected: models.certificates.isSelected
    bothAccessTypeCertificateSelected: models.accessKeyType.bothTypeCertificateSelected
    certificateAccessTypeRepeater.model: models.accessKeyType


    onSelectedAccessKeyType: {
        //index
        models.accessKeyType.setSelectedIndex(index)
        models.certificates.clearSelected()
        switch (index) {
        case 0:      //"public"
            //certificatesListView.seletedCertificateAccessType = qsTr("Public")
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Public
            models.certificatesFind.update()
            break;
        case 1:      //"private"
            //certificatesListView.seletedCertificateAccessType = qsTr("Private")
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.PublicAndPrivate
            models.certificatesFind.update()
            break;
        case 2:      //"both"
            //certificatesListView.seletedCertificateAccessType = qsTr("Both")
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Both
            models.certificatesFind.update()
            break;
        default:
            console.error("Unknown index", index)
            break;
        }
    }

    createCertificateButton.onClicked: {
        dapRightPanel.push("qrc:/screen/desktop/Certificates/RightPanel/CreateCertificateItem.qml")
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
}

