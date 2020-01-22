import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapLastActionsRightPanelForm
{
    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    ListModel
    {
        id: modelActions
        ListElement
        {
            name: "Token 2"
            status: "Received"
            amount: 892.145
            currency: "TKN2"
            date: "2020-01-15"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2020-01-14"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2020-01-13"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2020-01-13"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-12-30"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-12-30"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-12-28"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-12-15"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-11-12"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-11-12"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-10-05"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-10-04"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-10-04"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-10-02"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-10-01"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-08-20"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-08-20"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-08-16"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-07-25"
        }
        ListElement
        {
            name: "Token 2"
            status: "Received"
            amount: 892.145
            currency: "TKN2"
            date: "2020-01-15"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2020-01-14"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2020-01-13"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2020-01-13"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-12-30"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-12-30"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-12-28"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-12-15"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-11-12"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-11-12"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-10-05"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-10-04"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-10-04"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-10-02"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-10-01"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-08-20"
        }
        ListElement
        {
            name: "Kelvin"
            status: "Received"
            amount: 753.987
            currency: "KLVN"
            date: "2019-08-20"
        }
        ListElement
        {
            name: "NewGold"
            status: "Sent"
            amount: 300.986
            currency: "NGD"
            date: "2019-08-16"
        }
        ListElement
        {
            name: "Token 2"
            status: "Sent"
            amount: 500.986
            currency: "TKN2"
            date: "2019-07-25"
        }
    }

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 * pt
            width: parent.width
            color: "#757184"

            Text
            {
                property date payDate: new Date(Date.parse(section))
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: "#FFFFFF"
                text: getDateString(payDate)
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pixelSize: 12 * pt
            }
        }
    }

    ////@ Functions for "Today" or "Yesterday" or "Month, Day" or "Month, Day, Year" output
    function getDateString(date)
    {
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
