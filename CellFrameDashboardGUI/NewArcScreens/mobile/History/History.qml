import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets/"

Page {
    id: hisoryPage
    title: qsTr("TX Explorer")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    property alias mainHisoryPage: hisoryPage

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    ListModel
    {
        id: modelHistory
    }

    Component.onCompleted: {
        today = new Date()
        yesterday = new Date(new Date().setDate(new Date().getDate()-1))

        dapServiceController.requestToService("DapGetWalletHistoryCommand");
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            print("onWalletHistoryReceived")
            updateModel()
        }
    }

    property int outerMargin: 20 * pt
    property int innerMargin: 15 * pt

    ListView {
        id: historyView
        anchors.fill: parent
        anchors.topMargin: 10 * pt
        anchors.bottomMargin: 10 * pt
//        spacing: 5 * pt

        clip: true

        model: modelHistory

        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateSection

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        delegate:
        Item {
            id: delegateItem
            width: historyView.width - outerMargin*2
            height: last_in_day ? 35 * pt : 50 * pt
            anchors.margins: 0
            x: outerMargin

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: innerMargin
                anchors.rightMargin: innerMargin

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            Layout.fillHeight: true

                            verticalAlignment: Qt.AlignVCenter

                            text: network
                            font: _dapQuicksandFonts.dapFont.medium11
                            color: currTheme.textColor
                        }

                        Text {
                            Layout.fillHeight: true

                            verticalAlignment: Qt.AlignVCenter

                            text: status
                            font: _dapQuicksandFonts.dapFont.medium12
                            color: currTheme.textColorGray
                        }

                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        horizontalAlignment: Qt.AlignRight
                        verticalAlignment: Qt.AlignVCenter

                        property string sign: (status === "Sent" || status === "Pending") ? "- " : "+ "
                        text: sign + amount + " " + token_name
                        font: _dapQuicksandFonts.dapFont.medium14
                        color: currTheme.textColor
                    }

                }

                Rectangle
                {
                    visible: !last_in_day
                    Layout.fillWidth: true
                    Layout.topMargin: 5 * pt
                    Layout.bottomMargin: 10 * pt
                    height: 1
                    color: "#6B6979"
                }
            }


        }
    }

    Component
    {
        id: delegateSection

        Item {
            id: header

            width: parent.width - outerMargin*2
            height: 60 * pt
            x: outerMargin

            property date payDate: new Date(Date.parse(section))

            Rectangle {
                id: itemRect

                anchors.fill: parent
                anchors.topMargin: 15 * pt
                anchors.bottomMargin: 15 * pt

                color: "#2D3037"
                radius: 10

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: innerMargin

                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter

//                    text: section
                    text: getDateString(payDate)
                    font: _dapQuicksandFonts.dapFont.medium12
                    color: currTheme.textColor
                }
            }
            InnerShadow {
                id: light
                anchors.fill: itemRect
                radius: 1.0
                samples: 5
                cached: true
                horizontalOffset: -1
                verticalOffset: -1
                color: "#505050"
                source: itemRect
            }
            InnerShadow {
                anchors.fill: itemRect
                radius: 2.0
                samples: 5
                cached: true
                horizontalOffset: 2
                verticalOffset: 2
                color: "#202020"
                source: light
            }
        }
    }

    function updateModel()
    {
        modelHistory.clear()

        print("updateModel", "mainHistoryModel.length", mainHistoryModel.count)

        for (var q = 0; q < mainHistoryModel.count; ++q)
        {
            if (modelHistory.count === 0)
                modelHistory.append({ "network" : mainHistoryModel.get(q).Network,
                                      "token_name" : mainHistoryModel.get(q).Name,
                                      "status" : mainHistoryModel.get(q).Status,
                                      "amount" : mainHistoryModel.get(q).AmountWithoutZeros,
                                      "date" : mainHistoryModel.get(q).Date,
                                      "SecsSinceEpoch" : mainHistoryModel.get(q).SecsSinceEpoch,
                                      "last_in_day" : false})
//            modelHistory.append({ "network" : mainHistoryModel[q].Network,
//                                  "token_name" : mainHistoryModel[q].Name,
//                                  "status" : mainHistoryModel[q].Status,
//                                  "amount" : mainHistoryModel[q].AmountWithoutZeros,
//                                  "date" : mainHistoryModel[q].Date,
//                                  "SecsSinceEpoch" : mainHistoryModel[q].SecsSinceEpoch})
            else
            {
                var j = 0;
                while (modelHistory.get(j).SecsSinceEpoch > mainHistoryModel.get(q).SecsSinceEpoch)
//                    while (modelHistory.get(j).SecsSinceEpoch > mainHistoryModel[q].SecsSinceEpoch)
                {
                    ++j;
                    if (j >= modelHistory.count)
                        break;
                }
                modelHistory.insert(j, {"network" : mainHistoryModel.get(q).Network,
                                      "token_name" : mainHistoryModel.get(q).Name,
                                      "status" : mainHistoryModel.get(q).Status,
                                      "amount" : mainHistoryModel.get(q).AmountWithoutZeros,
                                      "date" : mainHistoryModel.get(q).Date,
                                      "SecsSinceEpoch" : mainHistoryModel.get(q).SecsSinceEpoch,
                                      "last_in_day" : false})
//                modelHistory.insert(j, {"network" : mainHistoryModel[q].Network,
//                                      "token_name" : mainHistoryModel[q].Name,
//                                      "status" : mainHistoryModel[q].Status,
//                                      "amount" : mainHistoryModel[q].AmountWithoutZeros,
//                                      "date" : mainHistoryModel[q].Date,
//                                      "SecsSinceEpoch" : mainHistoryModel[q].SecsSinceEpoch})
            }
        }

        for (var k = 1; k < modelHistory.count; ++k)
        {
            if (modelHistory.get(k-1).date !== modelHistory.get(k).date)
                modelHistory.get(k-1).last_in_day = true
            if (k === modelHistory.count-1)
                modelHistory.get(k).last_in_day = true
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
