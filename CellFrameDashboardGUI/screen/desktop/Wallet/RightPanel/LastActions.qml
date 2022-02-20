import QtQuick 2.12

LastActionsForm {

    ListModel
    {
        id: modelLastActions
    }

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 * pt
            width: parent.width

            color: currTheme.backgroundMainScreen

            property date payDate: new Date(Date.parse(section))

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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
            }
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            console.log("onWalletHistoryReceived")

            for (var i = 0; i < walletHistory.length; ++i)
            {
                if (modelLastActions.count === 0)
                    modelLastActions.append({
                                                "network" : walletHistory[i].Network,
                                                "name" : walletHistory[i].Name,
                                                "amount" : walletHistory[i].Amount,
                                                "status" : walletHistory[i].Status,
                                                "date" : walletHistory[i].Date,
                                                "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch})
                else
                {
                    var j = 0;
                    while (modelLastActions.get(j).SecsSinceEpoch > walletHistory[i].SecsSinceEpoch)
                    {
                        ++j;
                        if (j >= modelLastActions.count)
                            break;
                    }
                    modelLastActions.insert(j, {
                                                "network" : walletHistory[i].Network,
                                                "name" : walletHistory[i].Name,
                                                "amount" : walletHistory[i].Amount,
                                                "status" : walletHistory[i].Status,
                                                "date" : walletHistory[i].Date,
                                                "SecsSinceEpoch" : walletHistory[i].SecsSinceEpoch
                                            })
                }
            }
        }
    }
}
