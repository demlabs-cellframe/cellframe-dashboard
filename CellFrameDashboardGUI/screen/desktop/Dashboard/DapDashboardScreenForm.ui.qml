import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    id: dapdashboard
    dapFrame.color: "#FFFFFF"
    textTest.text: "Here text"
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

        Rectangle
        {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 20 * pt
            anchors.left: parent.left
            anchors.right: parent.right
            height: 36 * pt

            Row
            {
                anchors.fill: parent

                Text
                {
                    anchors.left: parent.left
                    font.pixelSize: 20 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    verticalAlignment: Qt.AlignVCenter
                    text: "My first wallet"
                }

                DapButton
                {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    widthButton: 132 * pt
                    heightButton: 36 * pt
                    textButton: "New payment"
                    // fontSizeButton: 12 * pt
                    colorBackgroundButton: "#3E3853"
                    normalImageButton: "qrc:/res/icons/new-payment_icon.png"
                    hoverImageButton: "qrc:/res/icons/new-payment_icon.png"
                    widthImageButton: 20 * pt
                    heightImageButton: 20 * pt
                }
            }
        }

        ListView {
            anchors.top: title.bottom
            anchors.topMargin: 20 * pt
            anchors.bottom: parent.bottom
            width: parent.width
            spacing: 5 * pt
            clip: true
            model: 10
            delegate:
                Column {
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
                        anchors.leftMargin: 16
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
                        width: 16
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
                        font.pixelSize: 12 * pt
                        font.family: "Roboto"
                        font.styleName: "Normal"
                        font.weight: Font.Normal
                        color: "#908D9D"
                        text: qsTr("KLJHuhlkjshfausdh7865lksfahHKLUIH")
                    }

                    Rectangle
                    {
                        id: networkAddressCopyButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20
                        height: 20
                        color: "red"
                    }

                }

                Repeater
                {
                    width: parent.width
                    model: 5

                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        height: 80

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

                            Rectangle
                            {
                                id: currencyIcon
                                height: 40
                                width: 40
                                Layout.alignment: Qt.AlignLeft
                                color: "blue"
                            }

                            Item {
                                height: parent.height
                                width: 10
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

                            Item {
                                height: parent.height
                                width: 16
                            }


                            Item {
                                Layout.fillWidth: true
                            }


                            Item {
                                height: parent.height
                                width: 16
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

                            Text {
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
                                text: "$ 23458"
                            }
                        }
                    }
                }
            }
        }
}
