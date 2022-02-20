import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapRightPanel
{
    id:control

    dapHeaderData:
        Rectangle
    {
        color: "transparent"
        height: 38 * pt
        width: 348*pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 24 * pt
            text: qsTr("Last actions")
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor

        }

    }

    dapContentItemData:
    ListView
    {

        id: lastActionsView
        anchors.fill: parent
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
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        elide: Text.ElideRight
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        text: status
                        color: currTheme.textColor
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
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
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
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
