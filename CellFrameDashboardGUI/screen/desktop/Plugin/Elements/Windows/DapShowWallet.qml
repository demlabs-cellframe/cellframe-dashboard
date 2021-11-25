import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../../"
import "qrc:/widgets"

Rectangle {
    anchors.fill: parent
    color: "#2E3138"


    Rectangle
    {
        id: mainFrameDashboard
        anchors.fill: parent
        color: "#363A42"
        radius: 16*pt

        // Header
        Item
        {
            id: walletShowHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 18 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt

                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Wallets")
                font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: "#ffffff"
            }
        }

        ListView
        {
            id: listViewWallet
            anchors.top: walletShowHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true

            delegate: delegateTokenView
        }

        Component
        {
            id: delegateTokenView
            Column
            {
                width: parent.width

                Rectangle
                {
                    id: stockNameBlock
                    height: 30 * pt
                    width: parent.width
                    color: "#2E3138"

                    Text
                    {
                        id: stockNameText
                        anchors.left: parent.left
                        anchors.leftMargin: 16 * pt
                        anchors.verticalCenter: parent.verticalCenter
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                        color: "#ffffff"
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                    }

                    DapText
                    {
                       id: textMetworkAddress
                       width: 63 * pt
                       anchors.right:  networkAddressCopyButton.left
                       anchors.rightMargin: 4 * pt
                       anchors.verticalCenter: parent.verticalCenter
                       fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                       color: "#ffffff"
                       fullText: address
                       textElide: Text.ElideMiddle
                       horizontalAlignment: Qt.Alignleft
                    }

                    MouseArea
                    {
                        id: networkAddressCopyButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 16 * pt
                        width: 16 * pt
                        height: 16 * pt
                        hoverEnabled: true

                        onClicked: textMetworkAddress.copyFullText()


                        Image
                        {
                            id: networkAddressCopyButtonImage
                            anchors.fill: parent
                            source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                            sourceSize.width: parent.width
                            sourceSize.height: parent.height

                        }
                    }
                }

                Repeater
                {
                    width: parent.width
                    model: tokens

                    Rectangle
                    {
                        anchors.left: parent.left
                        anchors.leftMargin: 13 * pt
                        anchors.right: parent.right
                        anchors.rightMargin: 16 * pt
                        height: 50 * pt
                        color: "#363A42"

                        Rectangle
                        {
                            anchors.top: tokenInfoPlace.bottom
                            width: parent.width
                            height: 1 * pt
                            color: currTheme.lineSeparatorColor
                        }

                        Item
                        {
                            id:tokenInfoPlace
                            anchors.fill: parent
                            anchors.bottomMargin: 1*pt

                            Text
                            {
                                id: currencyName
                                anchors.left: parent.left
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                                color: "#ffffff"
                                text: name + " (" + currencyCode.text + ")"
                                width: 172 * pt
                                horizontalAlignment: Text.AlignLeft
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt

                            }

                            Text
                            {
                                id: currencySum
//                                    Layout.fillWidth: true
                                anchors.right: currencyCode.left
                                anchors.rightMargin: 5 * pt
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                color: "#ffffff"
                                text: balance.toFixed(9)
    //                            text: balance.toPrecision()
                                horizontalAlignment: Text.AlignRight
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt
                            }

                            Text
                            {
                                id: currencyCode
                                anchors.right: parent.right
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                color: "#ffffff"
                                text: name
                                horizontalAlignment: Text.AlignRight
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10*pt
                            }
                        }
                    }
                }
            }
        }
    }


    InnerShadow {
        id: topLeftSadow
        anchors.fill: mainFrameDashboard
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: mainFrameDashboard
        visible: mainFrameDashboard.visible
    }
    InnerShadow {
        anchors.fill: mainFrameDashboard
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: mainFrameDashboard.visible
    }
}
