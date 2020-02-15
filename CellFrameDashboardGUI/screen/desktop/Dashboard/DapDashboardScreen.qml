import QtQuick 2.4
import QtQuick.Layouts 1.2
import "qrc:/widgets"

DapDashboardScreenForm
{
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

            Rectangle
            {
                id: networkAddressBlock
                height: 40 * pt
                width: parent.width

                Text
                {
                    id: networkAddressLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    font.pixelSize: 12 * pt
                    font.family: "Roboto"
                    font.styleName: "Normal"
                    font.weight: Font.Normal
                    color: "#908D9D"
                    text: qsTr("Network address")
                    width: 92 * pt
                }

                DapText
                {
                   id: textMetworkAddress
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.left: networkAddressLabel.right
                   anchors.leftMargin: 36 * pt
                   width: 172 * pt
                   font.pixelSize: 10 * pt
                   font.family: "Roboto"
                   font.styleName: "Normal"
                   font.weight: Font.Normal
                   color: "#908D9D"
                   fullText: address
                   textElide: Text.ElideRight
                }



                MouseArea
                {
                    id: networkAddressCopyButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: textMetworkAddress.right
                    anchors.leftMargin: 4 * pt
                    width: 16 * pt
                    height: 16 * pt
                    hoverEnabled: true

                    onClicked: textMetworkAddress.copyFullText()


                    Image
                    {
                        id: networkAddressCopyButtonImage
                        anchors.fill: parent
                        source: parent.containsMouse ? "qrc:/res/icons/ic_copy_hover.png" : "qrc:/res/icons/ic_copy.png"
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
                    anchors.leftMargin: 16 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 16 * pt
                    height: 67 * pt

                    Rectangle
                    {
                        id: lineBalance
                        anchors.top: parent.top
                        width: parent.width
                        height: 1 * pt
                        color: "#908D9D"
                    }

                    Rectangle
                    {
                        anchors.top: lineBalance.bottom
                        anchors.topMargin: 24 * pt
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 12 * pt
                        color: "transparent"

                        Image
                        {
                            id: currencyIcon
                            anchors.left: parent.left
                            height: 30 * pt
                            width: 30 * pt
                            source: "qrc:/res/icons/ic_cellframe.png"
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text
                        {
                            id: currencyName
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: currencyIcon.right
                            anchors.leftMargin: 10 * pt
                            font.pixelSize: 18 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: name
                            width: 172 * pt
                            horizontalAlignment: Text.AlignLeft

                        }

                        Rectangle
                        {
                            id: frameBalance
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"
                            width: 188 * pt
                            anchors.left: currencyName.right
                            anchors.leftMargin: 16 * pt
                            Text
                            {
                                id: currencySum
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                font.pixelSize: 12 * pt
                                font.family: "Roboto"
                                font.styleName: "Normal"
                                font.weight: Font.Normal
                                color: "#070023"
                                text: balance + " "
                                horizontalAlignment: Text.AlignLeft

                            }

                            Text
                            {
                                id: currencyCode
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: currencySum.right
                                anchors.right: parent.right
                                font.pixelSize: 12 * pt
                                font.family: "Roboto"
                                font.styleName: "Normal"
                                font.weight: Font.Normal
                                color: "#070023"
                                text: name
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        Text
                        {
                            id: currencyDollarEqv
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: frameBalance.right
                            anchors.leftMargin: 16 * pt
                            anchors.right: parent.right
                            anchors.rightMargin: 16 * pt
                            font.pixelSize: 12 * pt
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            color: "#070023"
                            text: "$" + emission + " USD"
                            width: 188 * pt
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                }
            }
        }
    }
}
