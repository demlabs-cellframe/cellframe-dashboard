import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Component
{
    Item
    {
        width:  parent.width
        height: 50 

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 20 
            anchors.rightMargin: 20 
            spacing: 10 

            // Wallet name
            Text
            {
                id: textWalletName
                Layout.minimumWidth: 100 
                text: wallet
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignLeft
            }

            // Network name
            Text
            {
                id: textNetworkName
                Layout.minimumWidth: 80 
                text: network
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignLeft
            }

            // Token name
            Text
            {
                id: textTokenName
                Layout.minimumWidth: 60 
                text: name
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignLeft
            }

            // Status
            Text
            {
                id: textSatus
                Layout.minimumWidth: 60 
                text: status
                color: status === "Sent" ? "#4B8BEB" : status === "Error" ? "#EB4D4B" : status === "Received"  ? "#6F9F00" : "#FFBC00"
                font.family: "Quicksand"
                font.pixelSize: 14
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
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
            }

        }

        //  Underline
        Rectangle
        {
            x: 20 
            y: parent.height - 1 
            width: parent.width - 40 
            height: 1 
            color: "#292929"
        }
    }
}
