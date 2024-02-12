import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"
import "../../controls"
import qmlclipboard 1.0

DapRectangleLitAndShaded
{
    id:control

    property alias dapLastActionsView: lastActionsView

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    QMLClipboard{
        id: clipboard
    }

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
            visible: walletModelList.count > 0 ? !txExplorerModule.statusInit : false

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

                height: 67

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16
                    spacing: 12

                    Item
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Text
                        {
                            text: network
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 7
                        }

                        Text
                        {
                            text: tx_status === "ACCEPTED" || tx_status === "PROCESSING" ? status : "Declined"
                            color: text === "Sent" ?      currTheme.orange :
                                   text === "Pending" ?   currTheme.neon :
                                   text === "Error" ||
                                   text === "Declined" ?  currTheme.red :
                                   text === "Received"  ? currTheme.lightGreen :
                                   text === "Unknown"   ? currTheme.mainButtonColorNormal0 :
                                                          currTheme.white

                            font: mainFont.dapFont.regular12
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 24
                        }

                        Text
                        {
                            id: timestamp
                            text: qsTr("Timestamp:")
                            color: currTheme.gray
                            font: mainFont.dapFont.regular11
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 42
                        }

                        Text
                        {
                            text: modelLastActions.get(index).time
                            color: currTheme.white
                            font: mainFont.dapFont.regular11
                            anchors.left: timestamp.right
                            anchors.top: timestamp.top
                            anchors.leftMargin: 4
                        }

                        DapBigText
                        {
                            property string sign: direction === "to"? "- " : "+ "
                            id: val
                            width: 160
                            height: 20
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: sign + value + " " + token
                            textFont: mainFont.dapFont.regular13
                            anchors.right: copyBtn.left
                            anchors.top: parent.top
                            anchors.rightMargin: 3
                            anchors.topMargin: 13
                        }

                        DapCopyButton {
                            id: copyBtn
                            popupText: qsTr("Value copied")
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 15
                            onCopyClicked: {
                                clipboard.setText(value)
                            }
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
                            height: 15
                            textColor: currTheme.lime
                            textHoverColor: currTheme.orange
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("Details")
                            textAndMenuFont: mainFont.dapFont.regular12
                            listView.model: model_tooltip
                            width: 40
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.topMargin: 36
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

                        width: 18
                        height: 18
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

    function getStatusName(tx_status, status)
    {
//        return "TEST"
        var st = "TST"

        if (tx_status !== "ACCEPTED")
            st = qsTr("Declined")
        if (status === "Sent")
            st = qsTr("Sent")
        if (status === "Error")
            st = qsTr("Error")
        if (status === "Declined")
            st = qsTr("Declined")
        if (status === "Received")
            st = qsTr("Received")

        console.log("getStatusName", tx_status, status, st)
        return st
    }
}
