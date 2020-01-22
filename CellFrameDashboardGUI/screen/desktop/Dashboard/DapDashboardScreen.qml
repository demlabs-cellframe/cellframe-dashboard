import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapDashboardScreenForm
{
    buttonTest.onClicked: textTest.text = "DESKTOP " + textTest.font.pointSize + " " + textTest.font.pixelSize

    walletNameEditButtonArea.onEntered:
    {
        walletNameEditButton.isHovered = true
    }

    walletNameEditButtonArea.onExited:
    {
        walletNameEditButton.isHovered = false
    }

    Component
    {
        id: _delegate

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
                    text: "Kelvin Testnet"
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

                Text
                {
                    id: networkAddressValue
                    anchors.verticalCenter: parent.verticalCenter
                    width: 200 * pt
                    font.pixelSize: 12 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    color: "#908D9D"
                    text: "KLJHuhlkjshfausdh7865lksfahHKLUIHKJFHKLUESAHFILKUHEWKUAFHjkhfdkslusfkhgs"
                    elide: Text.ElideRight
                }

                Image
                {
                    property bool isHovered: false
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20 * pt
                    height: 20 * pt
                    source: isHovered ? "qrc:/res/icons/ic_copy_hover.png" : "qrc:/res/icons/ic_copy.png"
                    sourceSize.width: width
                    sourceSize.height: height

                    MouseArea
                    {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered:
                        {
                            parent.isHovered = true
                        }

                        onExited:
                        {
                            parent.isHovered = false
                        }
                    }
                }
            }

            Repeater
            {
                width: parent.width
                model: 5

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 16 * pt
                    height: 80 * pt

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
                            source: bitCoinImage
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
                            text: qsTr("BitCoin")
                        }

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
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: "34287569.834986"
                        }

                        Text
                        {
                            id: currencyCode
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: "BTC"
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
                            text: "$ 23458.678"
                        }
                    }
                }
            }
        }
    }
}
