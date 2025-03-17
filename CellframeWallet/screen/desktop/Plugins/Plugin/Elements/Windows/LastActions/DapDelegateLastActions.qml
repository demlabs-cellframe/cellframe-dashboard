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
                text: wallet_name
                color: "#ffffff"
                font.family: "Quicksand"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignLeft
            }

            // Network name
            Text
            {
                id: textNetworkName
                Layout.minimumWidth: 120
                Layout.maximumWidth: 120
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
                text: token
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
                text: getStatusName(tx_status, status)
                color: getStatusColor(tx_status, status)
//                color: text === "Sent" ?      "#FFCD44" :
//                       text === "Error" ||
//                       text === "Declined" ?  "#FF5F5F" :
//                       text === "Received"  ? "#CAFC33" : "#ffffff"
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
                text: sign + value + " " + token
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

    function getStatusName(tx_status, status)
    {
        if (tx_status !== "ACCEPTED")
            return qsTr("Declined")
        if (status === "Sent")
            return qsTr("Sent")
        if (status === "Error")
            return qsTr("Error")
        if (status === "Declined")
            return qsTr("Declined")
        if (status === "Received")
            return qsTr("Received")
        return status
    }

    function getStatusColor(tx_status, status)
    {
        if (tx_status !== "ACCEPTED" || status === "Error")
            return "#FF5F5F"
        if (status === "Sent")
            return "#FFCD44"
        if (status === "Received")
            return "#CAFC33"
        return "#ffffff"
    }
}
