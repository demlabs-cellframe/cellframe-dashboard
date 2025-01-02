import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "../../../"
import "../"
import "../controls"


CertificatesActionsButtonList
{
    certificateSelected: models.certificates.isSelected
    bothAccessTypeCertificateSelected: models.accessKeyType.bothTypeCertificateSelected
    certificateAccessTypeRepeater.model: models.accessKeyType

    onSelectedAccessKeyType:
    {
        //index
        models.accessKeyType.setSelectedIndex(index)
        dapCertScreen.dapScreen.infoTitleTextVisible = false
        dapCertScreen.dapScreen.infoTitleTextVisibleClick = false
        models.certificates.clearSelected()
        switch (index) {
        case 0:      //"public"
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Public
            models.certificatesFind.update()
            break;
        case 1:      //"private"
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.PublicAndPrivate
            models.certificatesFind.update()
            break;
        case 2:      //"both"
            models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Both
            models.certificatesFind.update()
            break;
        default:
            console.error("Unknown index", index)
            break;
        }
    }

    createCertificateButton.onClicked:
    {
        certificateNavigator.openCreateCertificateItem()
    }

    exportPublicCertificateToFileButton.onClicked:
    {
        logics.exportPublicCertificateToFile(models.certificates.selectedIndex)
    }

//    exportPublicCertificateToMempoolButton.onClicked:
//    {
//        logics.exportPublicCertificateToMempool(models.certificates.selectedIndex)
//    }

    deleteCertificateButton.onClicked:
    {
        certScreen.dapScreen.infoTitleTextVisibleClick = false
        logics.deleteCertificate(models.certificates.selectedIndex)
    }
}

