import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"

DapHistoryScreenForm
{
    id: historyScreen

    Component
    {
        id: delegateDate
        Rectangle
        {
            width:  parent.width
            height: 30 * pt
            color: "#908D9D"

            Text
            {
                anchors.fill: parent
                verticalAlignment: Qt.AlignVCenter
                anchors.leftMargin: 16 * pt
                color: "#FFFFFF"
                text: section
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pixelSize: 12 * pt
            }
        }
    }


    Component
    {
        id: delegateToken
        Column
        {
            width: parent.width
            Rectangle
            {
                id: frameContentToken
                height: 66 * pt
                width: parent.width
                color: "transparent"

                //  Icon token
                Rectangle
                {
                    id: frameIconToken
                    width: 26 * pt
                    height: 26 * pt
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * pt
                    anchors.verticalCenter: parent.verticalCenter

                    Image
                    {
                        id: iconToken
                        anchors.fill: parent
                        source: "qrc:/res/icons/ic_cellframe.png"
                    }
                }

                // Token name
                Rectangle
                {
                    id: frameTokenName
                    width: 246 * pt
                    height: textTokenName.contentHeight
                    anchors.left: frameIconToken.right
                    anchors.leftMargin: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter

                    Text
                    {
                        id: textTokenName
                        anchors.fill: parent
                        text: name
                        color: "#070023"
                        font.family: "Roboto"
                        font.styleName: "Normal"
                        font.weight: Font.Normal
                        font.pixelSize: 16 * pt
                        Layout.alignment: Qt.AlignLeft
                    }
                }

                // Wallet number
                Rectangle
                {
                    id: frameNumberWallet
                    anchors.left: frameTokenName.right
                    anchors.leftMargin: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Status
                Rectangle
                {
                    id: frameStatus
                    width: 100 * pt
                    height: textSatus.contentHeight
                    anchors.left: frameNumberWallet.right
                    anchors.leftMargin: 20 * pt
                    anchors.right: frameBalance.left
                    anchors.rightMargin: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter

                    Text
                    {
                        id: textSatus
                        anchors.fill: parent
                        text: status
                        color: status === "Sent" ? "#4B8BEB" : status === "Error" ? "#EB4D4B" : status === "Received"  ? "#6F9F00" : "#FFBC00"
                        font.family: "Roboto"
                        font.styleName: "Normal"
                        font.weight: Font.Normal
                        font.pixelSize: 14 * pt
                    }
                }

                // Balance
                Rectangle
                {
                    id: frameBalance
                    width: 264 * pt
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter

                    ColumnLayout
                    {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        //  Token currency
                        Text
                        {
                            id: lblAmount
                            width: parent.width
                            property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                            text: sign + amount + " " + name
                            color: "#070023"
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            font.pixelSize: 16 * pt
                            Layout.alignment: Qt.AlignRight
                        }

                        //  Equivalent currency
                        Text
                        {
                            id: lblEquivalent
                            width: parent.width
                            property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                            text: sign + "$ " + 0.5 * amount + " USD"
                            color: "#C2CAD1"
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            font.pixelSize: 12 * pt
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }
            //  Underline
            Rectangle
            {
                width: parent.width
                height: 1
                color: "#C2CAD1"
            }
        }

    }


    //  Address wallet tip
    Label
    {
        id: lblAddressWallet
        padding: 3 * pt
        color: "#4F5357"
        font.family: "Regular"
        font.pixelSize: 14 * pt
        background:
            Rectangle
            {
                anchors.fill: parent
                color: "#FFFFFF";
                border.color: "#80000000"
                border.width: 1 * pt
            }

        visible: false
    }
}
