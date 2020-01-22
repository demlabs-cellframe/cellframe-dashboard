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

    property string bitCoinImage: "qrc:/res/icons/tkn1_icon_light.png"
    property string ethereumImage: "qrc:/res/icons/tkn2_icon.png"
    property string newGoldImage: "qrc:/res/icons/ng_icon.png"
    property string kelvinImage: "qrc:/res/icons/ic_klvn.png"

        Rectangle
        {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 20 * pt
            anchors.bottomMargin: 20 * pt
            anchors.left: parent.left
            anchors.right: parent.right
            height: 36 * pt

            RowLayout
            {
                anchors.fill: parent

                Text
                {
                    font.pixelSize: 20 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    text: "My first wallet"
                }

                Image
                {
                    id: walletNameEditButton
                    property bool isHovered: false
                    width: 20 * pt
                    height: 20 * pt
                    source: isHovered ? "qrc:/res/icons/ic_edit_hover.png" : "qrc:/res/icons/ic_edit.png"
                    sourceSize.width: width
                    sourceSize.height: height

                    MouseArea
                    {
                        id: walletNameEditButtonArea
                        anchors.fill: parent
                    }
                }

                Item
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                DapButton
                {
                    widthButton: 132 * pt
                    heightButton: 36 * pt
                    textButton: "New payment"
                    colorBackgroundButton: "#3E3853"
                    colorBackgroundHover: "red"
                    colorButtonTextNormal: "#FFFFFF"
                    colorButtonTextHover: "#FFFFFF"
                    normalImageButton: "qrc:/res/icons/new-payment_icon.png"
                    hoverImageButton: "qrc:/res/icons/new-payment_icon.png"
                    widthImageButton: 20 * pt
                    heightImageButton: 20 * pt
                    indentImageLeftButton: 20 * pt
                    indentTextRight: 20 * pt
                }
            }
        }

        ListView
        {
            anchors.top: title.bottom
            anchors.topMargin: 20 * pt
            anchors.bottom: parent.bottom
            width: parent.width
            spacing: 5 * pt
            clip: true
            model: 10
            delegate:
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
                            width: 200
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
                            id: networkAddressCopyButton
                            property bool isHovered: false
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20 * pt
                            height: 20 * pt
                            source: isHovered ? "qrc:/res/icons/ic_copy_hover.png" : "qrc:/res/icons/ic_copy.png"
                            sourceSize.width: width
                            sourceSize.height: height

                            MouseArea
                            {
                                id: networkAddressCopyButtonArea
                                anchors.fill: parent
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
