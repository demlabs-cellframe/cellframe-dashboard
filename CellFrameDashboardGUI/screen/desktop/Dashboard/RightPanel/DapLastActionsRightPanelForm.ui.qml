import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapRectangleLitAndShaded
{
    id:control

    property alias dapLastActionsView: lastActionsView

    color: currTheme.backgroundElements
    radius: currTheme.radiusRectangle
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

            Text
            {
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16
                font: mainFont.dapFont.bold14
                color: currTheme.textColor
                text: qsTr("Last actions")
            }
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

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            delegate: Item {
                anchors.left: parent.left
                anchors.right: parent.right

                height: 50 

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 16
                    anchors.leftMargin: 16

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 3

                        Text
                        {
                            Layout.fillWidth: true
                            text: network
                            color: currTheme.textColor
                            font: mainFont.dapFont.regular11
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            text: tx_status === "ACCEPTED" ? status : "Declined"
                            color: currTheme.textColorGrayTwo
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
                            property string sign: (status === "Sent") ? "- " : "+ "
//                            Layout.fillHeight: true
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
//                            visible: fee !== "0.0"
//                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            height: 15
                            textColor: currTheme.textColorGrayTwo
                            horizontalAlign: Qt.AlignRight
                            verticalAlign: Qt.AlignVCenter
                            fullText: qsTr("fee: ") + fee + " " + token
                            textFont: mainFont.dapFont.regular12

                            width: 160
                        }
                    }

                    Image
                    {
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
    //                    innerWidth: 20
    //                    innerHeight: 20

                        visible: network === "subzero" || network === "Backbone" || network === "mileena" || network === "kelvpn-minkowski"  ? true : false

                        source: mouseArea.containsMouse? "qrc:/Resources/BlackTheme/icons/other/browser_hover.svg" : "qrc:/Resources/BlackTheme/icons/other/browser.svg"

                        MouseArea
                        {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Qt.openUrlExternally("https://explorer.cellframe.net/transaction/" + network + "/" + tx_hash)
                        }
                    }
                }

                Rectangle
                {
                    width: parent.width
                    height: 1 
                    color: currTheme.lineSeparatorColor
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}


