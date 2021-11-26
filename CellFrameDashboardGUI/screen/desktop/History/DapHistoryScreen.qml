import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

DapHistoryScreenForm
{
    id: historyScreen

    Component
    {
        id: delegateDate
        Rectangle
        {
            height: 30 * pt
            width: parent.width
            color: currTheme.backgroundMainScreen

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.textColor
                text: section
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
            }
        }
    }


    Component
    {
        id: delegateToken
        Rectangle
        {
            width:  parent.width
            height: 50 * pt
            color: currTheme.backgroundElements

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 10 * pt
                spacing: 10 * pt

                // Network name
                Text
                {
                    id: textNetworkName
                    Layout.minimumWidth: 120 * pt
                    text: network
                    color: currTheme.textColor
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    Layout.alignment: Qt.AlignLeft
                }

                // Token name
                Text
                {
                    id: textTokenName
                    Layout.minimumWidth: 100 * pt
                    text: name
                    color: currTheme.textColor
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    Layout.alignment: Qt.AlignLeft
                }

                // Status
                Text
                {
                    id: textSatus
                    Layout.minimumWidth: 100 * pt
                    text: status
                    color: status === "Sent" ? "#4B8BEB" : status === "Error" ? "#EB4D4B" : status === "Received"  ? "#6F9F00" : "#FFBC00"
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                }


                // Balance
                //  Token currency
                Text
                {
                    id: lblAmount
                    Layout.fillWidth: true
                    property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                    text: sign + amount + " " + name
                    color: currTheme.textColor
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                    horizontalAlignment: Text.AlignRight
                }

            }

            //  Underline
            Rectangle
            {
                width: parent.width
                height: 1
                color: currTheme.lineSeparatorColor
            }
        }
    }

}
