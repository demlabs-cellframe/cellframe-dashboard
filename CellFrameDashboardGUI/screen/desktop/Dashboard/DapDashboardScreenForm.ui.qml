import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    id: dapdashboard
    dapFrame.color: "#FFFFFF"
    textTest.text: "Here text" // Delete it?
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

    // Paths to currency emblems
    property string bitCoinImagePath: "qrc:/res/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/res/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/res/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/res/icons/ic_klvn.png"

    Rectangle
    {
        id: titleBlock
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

            MouseArea
            {
                id: walletNameEditButton
                width: 20 * pt
                height: 20 * pt
                hoverEnabled: true

                Image
                {
                    id: walletNameEditButtonImage
                    anchors.fill: parent
                    source: parent.containsMouse ? "qrc:/res/icons/ic_edit_hover.png" : "qrc:/res/icons/ic_edit.png"
                    sourceSize.width: width
                    sourceSize.height: height

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
        anchors.top: titleBlock.bottom
        anchors.topMargin: 20 * pt
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: 5 * pt
        clip: true
        model:
            ListModel
            {
                ListElement
                {
                    name: "Kelvin Testnet"
                    address: "KLJHuhlkjshfausdh7865lksfahHKLUIHKJFHKLUESAHFILKUHEWKUAFHjkhfdkslusfkhgs"
                    money: [
                        ListElement
                        {
                            type: "bitCoin"
                            sum: 3487256
                            eq: "$ 3498750"
                        },
                        ListElement
                        {
                            type: "ether"
                            sum: 67896
                            eq: "$ 78687"
                        },
                        ListElement
                        {
                            type: "newGold"
                            sum: 675573
                            eq: "$ 987978"
                        }
                    ]
                }

                ListElement
                {
                    name: "Marketnet"
                    address: "lkajdsfeislsaIJEUfesIJEFHJISEFIsdfLIJFEISHFUSKEIEWEQLIJSlijfsfjlijeIEJJE"
                    money: [
                        ListElement
                        {
                            type: "bitCoin"
                            sum: 3487256
                            eq: "$ 3498750"
                        },
                        ListElement
                        {
                            type: "ether"
                            sum: 67896
                            eq: "$ 78687"
                        },
                        ListElement
                        {
                            type: "newGold"
                            sum: 675573
                            eq: "$ 987978"
                        },
                        ListElement
                        {
                            type: "ether"
                            sum: 6743896
                            eq: "$ 7843687"
                        }
                    ]
                }
            }

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
                        text: address
                        elide: Text.ElideRight
                    }

                    MouseArea
                    {
                        id: networkAddressCopyButton
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20 * pt
                        height: 20 * pt
                        hoverEnabled: true

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
