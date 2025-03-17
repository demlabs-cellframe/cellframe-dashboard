import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "../../"
import "../controls"

Page
{
    property alias dapDefaultRightPanel: defaultRightPanel
    property alias dapScreen: certificatesListView

    anchors.fill: parent

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 24 
        CertificatesListView {
            id: certificatesListView
            Layout.fillWidth: true
            Layout.fillHeight: true

            seletedCertificateAccessType: models.certificatesFind.accessKeyTypeIndex == 0 ? qsTr("Public") :
                                          models.certificatesFind.accessKeyTypeIndex == 1 ? qsTr("Private") : qsTr("Both")

            //infoTitleTextVisible: models.certificates.isSelected
            Component.onCompleted: {
                models.certificatesFind.delegate = delegateComponent
                models.certificatesFind.accessKeyTypeIndex = DapCertificateType.Public           //default open access type is public
                models.certificatesFind.update()
                model = models.certificatesFind  //original
            }

            onSelectedIndex: {
                  models.certificates.setSelectedIndex(index)
            }

            onInfoClicked: {     //index
                logics.dumpCertificate(index)
                if (!(openedRightPanelPage == "Info" && infoIndex == index))
                    certificateNavigator.openInfoItem(index)
            }

        }   //certificatesListView

        DapCertificateAtcions
        {
            id:defaultRightPanel
            Layout.fillHeight: true
            Layout.minimumWidth: 350 
            Layout.maximumWidth: 350
            visible: true
        }
    }
}
