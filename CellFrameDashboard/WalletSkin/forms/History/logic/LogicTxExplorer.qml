import QtQuick 2.12
import QtQml 2.12

QtObject {

    property int selectTxIndex: -1

    property var commandResult

    function initDetailsModel(model)
    {
        selectedTX.clear()
        selectedTX.append(model)
    }

    function updateWalletHistory(isLastActions, update)
    {
        if (logicMainApp.currentWalletIndex >= 0)
        {
            if(isLastActions)
            {
                lastDate = new Date(0)
                prevDate = new Date(0)
            }
            logicMainApp.getAllWalletHistory(
                logicMainApp.currentWalletIndex, update, isLastActions)
        }
    }

    function checkText(item, line)
    {
        var fstr = line.toLocaleLowerCase()

        if(!item.network || !item.token || !item.tx_status || !item.status || !item.value || !item.date)
            return false

        if (item.network.toLowerCase().indexOf(fstr) >= 0)
            return true

        if (item.token.toLowerCase().indexOf(fstr) >= 0)
            return true

        var statusStr = getStatusName(item.tx_status, item.status)
        if (statusStr.toLowerCase().indexOf(fstr) >= 0)
            return true

        if (item.value.toString().toLowerCase().indexOf(fstr) >= 0)
            return true

        return false
    }

    function isSameDay(date1, date2)
    {
//        console.log(date1.getFullYear(),
//                    date1.getMonth(),
//                    date1.getDate(),

//                    date2.getFullYear(),
//                    date2.getMonth(),
//                    date2.getDate(),

//                    (date1.getFullYear() === date2.getFullYear()
//                    && date1.getMonth() === date2.getMonth()
//                    && date1.getDate() === date2.getDate()))

        return (date1.getFullYear() === date2.getFullYear()
                && date1.getMonth() === date2.getMonth()
                && date1.getDate() === date2.getDate()) ? true : false
    }

    function getDate(date)
    {
        var parts = date.split(".");
        return new Date(parseInt(parts[2], 10),
                          parseInt(parts[1], 10) - 1,
                          parseInt(parts[0], 10));
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

    ////@ Checks if dates have same year
    function isSameYear(date1, date2)
    {
        return (date1.getFullYear() === date2.getFullYear()) ? true : false
    }

    function getStatusName(tx_status, status)
    {
        if (tx_status !== "ACCEPTED" &&
            tx_status !== "PROCESSING")
            return qsTr("Declined")
        if (status === "Sent")
            return qsTr("Sent")
        if (status === "Pending")
            return qsTr("Pending")
        if (status === "Error")
            return qsTr("Error")
        if (status === "Declined")
            return qsTr("Declined")
        if (status === "Received")
            return qsTr("Received")
        return status
    }

    function getStatusColor(tx_status, status)
    {
        if (tx_status !== "ACCEPTED" &&
            tx_status !== "PROCESSING")
            return currTheme.red
        if (status === "Error" || status === "Declined")
            return currTheme.red
        if (status === "Sent")
            return currTheme.orange
        if (status === "Pending")
            return currTheme.neon
        if (status === "Received")
            return currTheme.lightGreen
        return currTheme.white
    }

    function getTxStatusName(tx_status)
    {
        if (tx_status === "ACCEPTED")
            return qsTr("ACCEPTED")
        if (tx_status === "PROCESSING")
            return qsTr("PROCESSING")
        if (tx_status === "DECLINED")
            return qsTr("DECLINED")
        return tx_status
    }

    function getTxStatusColor(tx_status)
    {
        if (tx_status === "ACCEPTED")
            return currTheme.lightGreen
        if (tx_status === "PROCESSING")
            return currTheme.neon
        if (tx_status === "DECLINED")
            return currTheme.red
        return currTheme.lightGreen
    }
}
