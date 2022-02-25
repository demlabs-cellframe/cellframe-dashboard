import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4

import "../../"
import "qrc:/widgets"
import "../../controls" as Controls

Controls.DapTopPanel {
    signal currentSearchString(string text)

    // Frame icon search
    Rectangle
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 37 * pt
        anchors.verticalCenter: parent.verticalCenter
        height: 20 * pt
        width: 20 * pt
        color: "transparent"
        Image
        {
            id: iconSearch
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter

            source: "qrc:/resources/icons/ic_search.png"
        }
    }

    Rectangle
    {
        id: frameTextFieldSearch
        anchors.left: frameIconSearch.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10 * pt
        width: 230 * pt
        height: layoutSearch.height
        color: "transparent"
        ColumnLayout
        {
            id: layoutSearch
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0 * pt

            TextField
            {
                id: textFieldSearch
                Layout.minimumHeight: 28 * pt
                placeholderText: qsTr("Search")
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                style:
                    TextFieldStyle
                    {
                        textColor: currTheme.textColor
                        placeholderTextColor: currTheme.textColorGray
                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: currTheme.backgroundPanel
                            }
                    }
                onTextChanged: {
                    currentSearchString(text)
                }

            }
            Rectangle
            {
                width: parent.width
                height: 1 * pt
                color: currTheme.borderColor
            }
        }
    }
}
