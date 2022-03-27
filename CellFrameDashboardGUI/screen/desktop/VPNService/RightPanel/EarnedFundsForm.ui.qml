import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/widgets"
import "../Parts"

Page {
    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors.fill: parent
        Text
        {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.leftMargin: 10
            text: qsTr("Earned funds")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
        }

        ListView
        {
            id: lastActionsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: modelLastActions
            delegate:
                Rectangle
                {
                    id: dapContentDelegate
                    width: parent.width
                    height: 50 * pt
                    color: "transparent"

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
                                text: name
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

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection
        }
    }
}
