import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

Rectangle {
    anchors.fill: parent
    color: "#2E3138"
    id:controlCertificates

    Rectangle
    {
        id: viewCertificates
        anchors.fill: parent
        color: "#363A42"
        radius: 16 * pt

        // Header
        Item
        {
            id: certificatesHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
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

    Component.onCompleted: {
        dapServiceController.requestToService("DapCertificateManagerCommands", 1); // 1 - Get List Certificates
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewCertificates
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: viewCertificates
        visible: viewCertificates.visible
    }
    InnerShadow {
        anchors.fill: viewCertificates
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
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
