import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Component {

    Item{
        width: lastActionsView.width
        height: lastActionsView.heightDelegate

        Item
        {
            anchors.fill: parent
            anchors.rightMargin: 16
            anchors.leftMargin: 16

            RowLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 16
                anchors.leftMargin: 16
                spacing: 12

                ColumnLayout
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 3

                    Text
                    {
                        Layout.fillWidth: true
                        text: network
                        color: currTheme.white
                        font: mainFont.dapFont.regular11
                        elide: Text.ElideRight
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        text: logicExplorer.getStatusName(tx_status, status)
                        color: logicExplorer.getStatusColor(tx_status, status)
                        font: mainFont.dapFont.regular12
                    }
                }

                ColumnLayout
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 0

                    DapBigText
                    {
                        property string sign: direction === "to"? "- " : "+ "
                        Layout.fillWidth: true
                        height: 20
                        horizontalAlign: Qt.AlignRight
                        verticalAlign: Qt.AlignVCenter
                        fullText: sign + value + " " + token
                        textFont: mainFont.dapFont.regular14

                        width: 160
                    }
                    DapBigText
                    {
                        Layout.fillWidth: true
                        height: 15
                        textColor: currTheme.gray
                        horizontalAlign: Qt.AlignRight
                        verticalAlign: Qt.AlignVCenter
                        fullText: qsTr("fee: ") + fee + " " + fee_token
                        textFont: mainFont.dapFont.regular12

                        width: 160
                    }
                }

                DapToolTipInfo{
                    property string normalIcon: "qrc:/walletSkin/Resources/"+ pathTheme +"/icons/other/browser.svg"
                    property string hoverIcon: "qrc:/walletSkin/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"
                    property string disabledIcon: "qrc:/walletSkin/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"
                    id: explorerIcon
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: 18
                    contentText: qsTr("Explorer")

                    toolTip.width: text.implicitWidth + 16
                    toolTip.x: -toolTip.width/2 + 8

                    enabled: tx_status === "DECLINED" || tx_status === "PROCESSING" ? false : true 

                    indicatorSrcNormal: tx_status === "DECLINED"  || tx_status === "PROCESSING" ? disabledIcon : normalIcon

                    indicatorSrcHover: tx_status === "DECLINED"   || tx_status === "PROCESSING" ? disabledIcon : hoverIcon

                    onClicked: Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)

                }
            }

            Rectangle
            {
                width: parent.width
                height: 1
                color: currTheme.secondaryBackground
                anchors.bottom: parent.bottom
            }
        }
    }
}
