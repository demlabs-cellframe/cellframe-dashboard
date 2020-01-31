import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapDashboardScreenForm
{
    Component
    {
        id: dashboardDelegate

        Column
        {
            width: parent.width

            Rectangle
            {
                id: stockNameBlock
                height: 30 * pt
                width: parent.width
                color: "#908D9D"

                Text
                {
                    id: stockNameText
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    color: "#FFFFFF"
                    verticalAlignment: Qt.AlignVCenter
                    text: name
                }
            }

            Row
            {
                id: networkAddressBlock
                height: 40 * pt
                width: parent.width

                Item
                {
                    width: 16 * pt
                    height: parent.height
                }

                Text
                {
                    id: networkAddressLabel
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    color: "#908D9D"
                    text: qsTr("Network address")
                }

                Item
                {
                    width: 36 * pt
                    height: parent.height
                }

                DapText
                {
                    id: networkAddressValue
                    anchors.verticalCenter: parent.verticalCenter
                    width: 400 * pt
                    font.pixelSize: 10 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    color: "#908D9D"
                    text: address
                    elide: Text.ElideRight
                }

                MouseArea
                {
                    id: networkAddressCopyButton
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16 * pt
                    height: 16 * pt
                    hoverEnabled: true

                    onClicked: networkAddressValue.copy()

                    Image
                    {
                        id: networkAddressCopyButtonImage
                        anchors.fill: parent
                        source: parent.containsMouse ? "qrc:/res/icons/ic_copy_hover.png" : "qrc:/res/icons/ic_copy.png"
                        sourceSize.width: width
                        sourceSize.height: height

                    }
                }
            }

            Repeater
            {
                width: parent.width
                model: money

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 16 * pt
                    height: 56 * pt

                    Rectangle
                    {
                        anchors.top: parent.top
                        width: parent.width
                        height: 1 * pt
                        color: "#908D9D"
                    }

                    RowLayout
                    {
                        anchors.fill: parent

                        Image
                        {
                            id: currencyIcon
                            height: 40 * pt
                            width: 40 * pt
                            Layout.alignment: Qt.AlignLeft
                            source: (type === "bitCoin") ? bitCoinImagePath : (type === "ether") ? ethereumImagePath : newGoldImagePath // Don't know how to deal with it yet
                            sourceSize.width: width
                            sourceSize.height: height
                        }

                        Item
                        {
                            height: parent.height
                            width: 10 * pt
                            Layout.alignment: Qt.AlignLeft
                        }

                        Text
                        {
                            id: currencyName
                            Layout.alignment: Qt.AlignLeft
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: type
                        }
                        // Delimiters - see design
                        Item
                        {
                            height: parent.height
                            width: 16 * pt
                        }


                        Item
                        {
                            Layout.fillWidth: true
                        }


                        Item
                        {
                            height: parent.height
                            width: 16 * pt
                        }

                        Text
                        {
                            id: currencySum
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: sum
                        }

                        Text
                        {
                            id: currencyCode
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: (type === "bitCoin") ? "BTC" : (type === "ether") ? "ETH" : (type === "newGold") ? "NGD" : "KLVN"
                        }

                        Item
                        {
                            Layout.fillWidth: true
                        }

                        Text
                        {
                            id: currencyDollarEqv
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: eq
                        }
                    }
                }
            }
        }
    }
}
