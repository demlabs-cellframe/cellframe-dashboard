import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

Page
{
    id:control

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 14 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
                verticalAlignment: Qt.AlignVCenter
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

            delegate: Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * pt
                anchors.rightMargin: 5 * pt
    //            width: control.width
                color: currTheme.backgroundElements
                height: 50 * pt

                RowLayout
                {
                    anchors.fill: parent
                    anchors.rightMargin: 20 * pt
                    anchors.leftMargin: 16 * pt

                    ColumnLayout
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 2 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            text: network
                            color: currTheme.textColor
                            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular11
                            elide: Text.ElideRight
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            text: status
                            color: currTheme.textColorGrayTwo
                            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
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
                        font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    }
                    Image
                    {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
    //                    innerWidth: 20
    //                    innerHeight: 20

                        visible: network === "subzero" ? true : false

                        source: mouseArea.containsMouse? "qrc:/resources/icons/icon_export_hover.png" : "qrc:/resources/icons/icon_export.png"

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
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
}
