import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"

DapRightPanel
{
    dapHeaderData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 24 * pt
                text: qsTr("Earned funds")
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
            anchors.bottomMargin: 10
            anchors.leftMargin: 5
            anchors.rightMargin: 5
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


