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
                            text: status
                            color: currTheme.textColorGrayTwo
                            font: mainFont.dapFont.regular12
                        }
                    }

                    Text
                    {
                        property string sign: (status === "Sent") ? "- " : "+ "
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignRight
                        verticalAlignment: Qt.AlignVCenter
                        color: currTheme.textColor
                        text: sign + amount + " " + name
                        font: mainFont.dapFont.regular14

                        elide: Text.ElideMiddle

                        ToolTip
                        {
                            id:toolTip
                            visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
                            text: parent.text
                            scale: mainWindow.scale

                            contentItem: Text {
                                    text: toolTip.text
                                    font: mainFont.dapFont.regular14
                                    color: currTheme.textColor
                                }
                            background: Rectangle{color:currTheme.backgroundPanel}
                        }
                        MouseArea
                        {
                            id:area
                            anchors.fill: parent
                            hoverEnabled: true
                        }


                    }
                    Image
                    {
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
    //                    innerWidth: 20
    //                    innerHeight: 20

                        visible: network === "subzero" || network === "Backbone" || network === "mileena"  ? true : false

                        source: mouseArea.containsMouse? "qrc:/Resources/BlackTheme/icons/other/browser_hover.svg" : "qrc:/Resources/BlackTheme/icons/other/browser.svg"

                        MouseArea
                        {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Qt.openUrlExternally("https://test-explorer.cellframe.net/transaction/" + hash)
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


