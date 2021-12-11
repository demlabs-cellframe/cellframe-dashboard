import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

DapHistoryScreenForm
{
    id: historyScreen

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    Component.onCompleted:
    {
        today = new Date()
        yesterday = new Date(new Date().setDate(new Date().getDate()-1))
    }

    Component
    {
        id: delegateDate
        Rectangle
        {
            height: 30 * pt
            width: parent.width
            color: currTheme.backgroundMainScreen

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.textColor
                text: getDateString(payDate)
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
                anchors.leftMargin: 20 * pt
                anchors.rightMargin: 20 * pt
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
                x: 20 * pt
                y: parent.height - 1 * pt
                width: parent.width - 40 * pt
                height: 1 * pt
                color: currTheme.lineSeparatorColor
            }
        }
    }

    ////@ Functions for "Today" or "Yesterday" or "Month, Day" or "Month, Day, Year" output
    function getDateString(date)
    {
//        console.log("getDateString", date.toLocaleString(Qt.locale("en_EN"), "MMMM, d, yyyy"))

        if (isSameDay(today, date))
        {
            return qsTr("Today")
        }
        else if (isSameDay(yesterday, date))
        {
            return qsTr("Yesterday")
        }
        else if (!isSameYear(today, date))
        {
            return date.toLocaleString(Qt.locale("en_EN"), "MMMM, d, yyyy")
        }
        else
        {
            return date.toLocaleString(Qt.locale("en_EN"), "MMMM, d") // Does locale should be changed?
        }
    }

    ////@ Checks if dates are same
    function isSameDay(date1, date2)
    {
        return (isSameYear(date1, date2) && date1.getMonth() === date2.getMonth() && date1.getDate() === date2.getDate()) ? true : false
    }

    ////@ Checks if dates have same year
    function isSameYear(date1, date2)
    {
        return (date1.getFullYear() === date2.getFullYear()) ? true : false
    }


}
