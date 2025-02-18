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
        color: currTheme.mainBackground
    }

    property string bitCoinImagePath: "qrc:/resources/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/resources/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/resources/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/resources/icons/ic_klvn.png"

    DapRectangleLitAndShaded
    {
        id: mainFrameTokens
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
        {
            anchors.fill: parent

            DapLoadingPanel
            {
                spinerEnabled: nodeConfigToolController.statusProcessNode
                anchors.topMargin: tokensShowHeader.height
            }

            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                Item
                {
                    id: tokensShowHeader
                    Layout.fillWidth: true
                    height: 42
                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        font: mainFont.dapFont.bold14
                        color: currTheme.white
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("List of all available tokens in the networks")
                    }
                    Text
                    {
                        font: mainFont.dapFont.regular14
                        color: currTheme.white
                        text: qsTr("Total Supply")
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                    }
                }

                ListView
                {
                    id: listViewTokens
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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
                            height: 30
                            width: parent.width
                            color: currTheme.mainBackground

                            Text
                            {
                                anchors.left: parent.left
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                font: mainFont.dapFont.medium12
                                color: currTheme.white
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
                                height: 50
                                color: currTheme.secondaryBackground

                                RowLayout
                                {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 10

                                    Text
                                    {
                                        id: currencyName
                                        font: mainFont.dapFont.regular16
                                        color: logicTokens.selectTokenIndex === index && logicTokens.selectNetworkIndex === delegateTokenView.idx || mouseArea.containsMouse ? currTheme.lime : currTheme.white
                                        text: name
                                        width: 172
                                        horizontalAlignment: Text.AlignLeft
                                    }

                                    Item{
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        DapBigText
                                        {
                                            id: currencySum
                                            anchors.fill: parent
                                            textFont: mainFont.dapFont.regular14
                                            textColor: logicTokens.selectTokenIndex === index && logicTokens.selectNetworkIndex === delegateTokenView.idx || mouseArea.containsMouse ? currTheme.lime : currTheme.white
                                            fullText: total_supply === 0.0 || total_supply === "0.0"  || total_supply === "0" || total_supply === 0 ? "Unlimited" : mathWorker.balanceToCoins(total_supply)
                                            horizontalAlign: Text.AlignRight
                                        }
                                    }
                                }

                                //  Underline
                                Rectangle
                                {
                                    x: 16
                                    y: parent.height - 1
                                    width: parent.width - 32
                                    height: 1
                                    color: currTheme.mainBackground
                                }

                                MouseArea
                                {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked:
                                    {
                                        if(logicTokens.selectTokenIndex !== index || logicTokens.selectNetworkIndex !== delegateTokenView.idx)
                                        {
                                            logicTokens.selectTokenIndex = index
                                            logicTokens.selectNetworkIndex = delegateTokenView.idx
                                            logicTokens.initDetailsModel()
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
    }
}
