import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../controls"
import "qrc:/widgets"
import "../../"


Page
{
    id: dapDashboardScreen

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
    }

    property string bitCoinImagePath: "qrc:/resources/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/resources/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/resources/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/resources/icons/ic_klvn.png"

    DapRectangleLitAndShaded
    {
        id: mainFrameTokens
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
        {
            anchors.fill: parent

            Item
            {
                id: tokensShowHeader
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
                    text: qsTr("Tokens")
                    font:  mainFont.dapFont.bold14
                    color: currTheme.textColor
                }
            }

            ListView
            {
                id: listViewTokens
                anchors.top: tokensShowHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true
                model: dapModelTokens

                delegate: Column
                {
                    id: delegateTokenView
                    property int idx: index
                    width: listViewTokens.width

                    Rectangle
                    {
                        id: stockNameBlock
                        height: 30 * pt
                        width: parent.width
                        color: currTheme.backgroundMainScreen

                        Text
                        {
                            id: stockNameText
                            anchors.left: parent.left
                            anchors.leftMargin: 16 * pt
                            anchors.verticalCenter: parent.verticalCenter
                            font: mainFont.dapFont.medium11
                            color: currTheme.textColor
                            verticalAlignment: Qt.AlignVCenter
                            text: network
                        }
                    }

                    Repeater
                    {
                        id: tokensRepeater
                        width: parent.width
                        model: tokens

                        Rectangle
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 50 * pt
                            color: currTheme.backgroundElements

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 20 * pt
                                anchors.rightMargin: 20 * pt
                                spacing: 10 * pt

                                Text
                                {
                                    id: currencyName
                                    font: mainFont.dapFont.regular16
                                    color: logicTokens.selectTokenIndex === index && logicTokens.selectNetworkIndex === delegateTokenView.idx ? currTheme.hilightColorComboBox : currTheme.textColor
                                    text: name
                                    width: 172 * pt
                                    horizontalAlignment: Text.AlignLeft
                                }

//                                Text
//                                {
//                                    id: currencySum
//                                    Layout.fillWidth: true
//                                    font: mainFont.dapFont.regular14
//                                    color: logicTokens.selectTokenIndex === index && logicTokens.selectNetworkIndex === delegateTokenView.idx ? currTheme.hilightColorComboBox : currTheme.textColor
//                                    text: modelData.balance
//                                    horizontalAlignment: Text.AlignRight
//                                }

//                                Text
//                                {
//                                    id: currencyCode
//                                    font: mainFont.dapFont.regular14
//                                    color: logicTokens.selectTokenIndex === index && logicTokens.selectNetworkIndex === delegateTokenView.idx ? currTheme.hilightColorComboBox : currTheme.textColor
//                                    text: modelData.name
//                                    horizontalAlignment: Text.AlignRight
//                                }
                            }

                            Rectangle
                            {
                                x: 20 * pt
                                y: parent.height - 1 * pt
                                width: parent.width - 40 * pt
                                height: 1 * pt
                                color: currTheme.lineSeparatorColor
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    logicTokens.selectTokenIndex = index
                                    logicTokens.selectNetworkIndex = delegateTokenView.idx
                                    navigator.tokenInfo()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
