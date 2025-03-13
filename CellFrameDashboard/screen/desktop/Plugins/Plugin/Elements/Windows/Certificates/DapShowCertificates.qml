import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent
    id:controlCertificates

    Rectangle
    {
        id: viewCertificates
        anchors.fill: parent
        color: "#363A42"
        radius: 16 

        Rectangle
        {
            anchors.fill: parent
            color: viewCertificates.color
            radius: viewCertificates.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewCertificates.width
                    height: viewCertificates.height
                    radius: viewCertificates.radius
                }
            }

            // Header
            Item
            {
                id: certificatesHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 38 

                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 
                    anchors.topMargin: 10 
                    anchors.bottomMargin: 10 
                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Certificates")
                    font.family: "Quicksand"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                }
            }

            ListView
            {
                id: listViewCertificates
                anchors.top: certificatesHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true

                model: ListModel{
                    id: certificatesModel
                }

                delegate: DapCertificatesComponent { }
            }
        }
    }

    Component.onCompleted: {
        certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList}) // 1 - Get List Certificates
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewCertificates
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewCertificates
        visible: viewCertificates.visible
    }
    InnerShadow {
        anchors.fill: viewCertificates
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewCertificates.visible
    }

    Connections
    {
        target: dapServiceController
        onCertificateManagerOperationResult:
        {
            for (var i = 0; i < result.data.length; ++i) {
                certificatesModel.append(result.data[i])
            }
        }
    }
}
