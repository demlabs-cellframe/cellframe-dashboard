import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/controls" as Controls

Page {

    background: Rectangle {
        color: "transparent"
    }

    ListView
    {
        id: lastActionsView
        anchors.fill: parent
        anchors.margins: 10
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