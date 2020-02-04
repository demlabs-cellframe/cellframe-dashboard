import QtQuick 2.4
import QtQuick.Controls 2.0

DapSettingsScreenForm
{

    ///@detalis Settings item model.
    VisualItemModel
    {
        id: modelSettings

        // Network settings section
        Rectangle
        {
            id: itemNetwork
            height: networkHeader.height + contentNetwork.height
            width: dapListViewSettings.width

            // Header
            Rectangle
            {
                id: networkHeader
                color: "#DFE1E6"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * pt
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    verticalAlignment: Qt.AlignVCenter
                    text:"Network"
                    font.family: "Roboto"
                    font.pixelSize: 12 * pt
                    color: "#5F5F63"
                }
            }

            // Content
            Rectangle
            {
                id: contentNetwork
                anchors.top: networkHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 60 * pt
                ComboBox
                {
                    id: comboBoxNetwork
                    width: 150
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 18 * pt
                    anchors.topMargin: 10 * pt
                    anchors.bottomMargin: 10 * pt
                    model: dapNetworkModel
                    onCurrentTextChanged:
                    {
                        dapServiceController.CurrentNetwork = currentText
                        dapServiceController.IndexCurrentNetwork = currentIndex
                    }
                }
            }
        }

        // VPN settings section
        Rectangle
        {
            id: itemVPN
            height: vpnHeader.height
            width: dapListViewSettings.width
            color: "blue"
            // Header
            Rectangle
            {
                id: vpnHeader
                color: "#DFE1E6"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * pt
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    verticalAlignment: Qt.AlignVCenter
                    text: "VPN"
                    font.family: "Roboto"
                    font.pixelSize: 12 * pt
                    color: "#5F5F63"
                }
            }
        }
    }
}
