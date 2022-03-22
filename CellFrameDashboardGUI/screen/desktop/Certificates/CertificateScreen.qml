import QtQuick 2.9
import QtQuick.Controls 2.2
import DapCertificateManager.Commands 1.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "parts"
import "../../"
import "qrc:/screen/controls"

RowLayout
    {
        anchors.fill: parent

        spacing: 24 * pt


        DapRectangleLitAndShaded
        {
            id:frameListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
            CertificatesListView {
                id: certificatesListView
                anchors.fill: parent

                seletedCertificateAccessType: models.certificatesFind.accessKeyTypeIndex == 0 ? qsTr("Public") :
                                              models.certificatesFind.accessKeyTypeIndex == 1 ? qsTr("Private") : qsTr("Both")

                infoTitleTextVisible: models.certificates.isSelected
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
                    rightPanel.sourceComponent = certificateInfoComponent
                }

            }   //certificatesListView

        }
    }
