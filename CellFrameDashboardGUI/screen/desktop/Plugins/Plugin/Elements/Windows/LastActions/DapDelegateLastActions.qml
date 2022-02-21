import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Component
{
    id: delegateToken
    Item
    {
        width:  parent.width
        height: 50 * pt

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 20 * pt
            anchors.rightMargin: 20 * pt
            spacing: 10 * pt

            // Wallet name
            Text
            {
                id: textWalletName
                Layout.minimumWidth: 120 * pt
                text: wallet
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignLeft
            }

            // Network name
            Text
            {
                id: textNetworkName
                Layout.minimumWidth: 120 * pt
                text: network
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignLeft
            }

            // Token name
            Text
            {
                id: textTokenName
                Layout.minimumWidth: 100 * pt
                text: name
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignLeft
            }

            // Status
            Text
            {
                id: textSatus
                Layout.minimumWidth: 100 * pt
                text: status
                color: status === "Sent" ? "#4B8BEB" : status === "Error" ? "#EB4D4B" : status === "Received"  ? "#6F9F00" : "#FFBC00"
                font.family: "Quicksand"
                font.pixelSize: 16
            }


            // Balance
            //  Token currency
            Text
            {
                id: lblAmount
                Layout.fillWidth: true
                property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                text: sign + amount + " " + name
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignRight
            }

        }

        //  Underline
        Rectangle
        {
            x: 20 * pt
            y: parent.height - 1 * pt
            width: parent.width - 40 * pt
            height: 1 * pt
            color: "#292929"
        }
    }
}
