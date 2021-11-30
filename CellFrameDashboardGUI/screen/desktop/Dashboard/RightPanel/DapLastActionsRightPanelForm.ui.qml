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
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor

        }

    }

    dapContentItemData:
    ListView
    {
        id: lastActionsView
        anchors.fill: parent
        clip: true
//        required modelLastActions
        model: modelLastActions
        ScrollBar.vertical: ScrollBar {
            active: true
        }

//        section.property: "date"
        section.property: "modelData.date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateSection

        delegate: Rectangle {

            width: control.width
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
                        text: modelData.network
                        color: currTheme.textColor
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                        elide: Text.ElideRight
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        text: modelData.txStatus
                        color: currTheme.textColor
                        font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    }
                }

//                Text
//                {
//                    Layout.fillWidth: true
//                    text: modelData.date
//                    color: currTheme.textColor
//                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
//                }

                Text
                {
                    property string sign: (modelData.txStatus === "Sent") ? "- " : "+ "
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    color: currTheme.textColor
                    text: sign + modelData.txAmount + " " + modelData.token
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


