import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"
import "../../controls"

DapRectangleLitAndShaded
{
    id:control

    property alias dapLastActionsView: lastActionsView

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 
            visible: txExplorerModule.statusInit

            Text
            {
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                font: mainFont.dapFont.bold14
                color: currTheme.white
                text: qsTr("Last actions")
            }
        }

        ColumnLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            visible: !txExplorerModule.statusInit

            Item{Layout.fillHeight: true}

            DapLoadIndicator {
                Layout.alignment: Qt.AlignHCenter

                indicatorSize: 64
                countElements: 8
                elementSize: 10

                running: !txExplorerModule.statusInit
            }


            Text
            {
                Layout.alignment: Qt.AlignHCenter

                font: mainFont.dapFont.medium16
                color: currTheme.white
                text: qsTr("Last Actions data loading...")
            }
            Item{Layout.fillHeight: true}
        }

        ListView
        {
            id: lastActionsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: modelLastActions
            ScrollBar.vertical: ScrollBar {
                active: true
            }
            visible: txExplorerModule.statusInit

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            delegate: Item {
                width: lastActionsView.width

                height: 50 

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
                            text: tx_status === "ACCEPTED" || tx_status === "PROCESSING" ? status : "Declined"
                            color: text === "Sent" ?      currTheme.orange :
                                   text === "Pending" ?   currTheme.neon :
                                   text === "Error" ||
                                   text === "Declined" ?  currTheme.red :
                                   text === "Received"  ? currTheme.lightGreen :
                                   text === "Unknown"   ? currTheme.mainButtonColorNormal0 :
                                                          currTheme.white

                            font: mainFont.dapFont.regular12
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        spacing: 0

                        DapBigText
                        {
                            property string sign: direction === "to"? "- " : "+ "
//                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            height: 20
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + value + " " + token
                            textFont: mainFont.dapFont.regular14

                            width: 160
                        }

                        DapTextWithList
                        {
                            ListModel{
                                id: model_tooltip
                                Component.onCompleted:
                                {
                                    append ({
                                                name: qsTr("Fee: "),
                                                number: fee_net ,
                                                token_name: fee_token
                                            })
                                    append ({
                                                name: qsTr("Validator fee: "),
                                                number: fee,
                                                token_name: fee_token
                                            })
                                    if(m_value !== "0.0" && m_value !== "")
                                    {
                                        var str = m_direction === "from" ? "+" : "-"
                                        str += " "+ m_value
                                        append ({
                                                    name: m_direction === "from" ? qsTr("Deposited: ") : qsTr("Burning: "),
                                                    number: str,
                                                    token_name: m_token
                                                })
                                    }
                                }
                            }

                            alwaysHoverShow: true
                            Layout.fillWidth: false
                            Layout.alignment: Qt.AlignRight
                            height: 15
                            textColor: currTheme.lime
                            textHoverColor: currTheme.orange
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("Details")
                            textAndMenuFont: mainFont.dapFont.regular12
                            listView.model: model_tooltip
                            width: 40
                        }
                    }

                    DapToolTipInfo{
                        property string normalIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser.svg"
                        property string hoverIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_hover.svg"
                        property string disabledIcon: "qrc:/Resources/"+ pathTheme +"/icons/other/browser_disabled.svg"
                        id: explorerIcon
                        Layout.preferredHeight: 18
                        Layout.preferredWidth: 18
                        contentText: qsTr("Explorer")

                        toolTip.width: text.implicitWidth + 16
                        toolTip.x: -toolTip.width/2 + 8

                        enabled: tx_status === "DECLINED" || tx_status === "PROCESSING" ? false :
                                  network !== "private"?
                                  true : false

                        indicatorSrcNormal: tx_status === "DECLINED"  || tx_status === "PROCESSING" ? disabledIcon :
                                                network !== "private"?
                                                normalIcon : disabledIcon

                        indicatorSrcHover: tx_status === "DECLINED"   || tx_status === "PROCESSING" ? disabledIcon :
                                                network !== "private"?
                                                hoverIcon : disabledIcon

                        onClicked: Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)

                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1 
                    color: currTheme.mainBackground
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}


