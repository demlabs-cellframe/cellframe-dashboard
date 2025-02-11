import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

Rectangle {
    anchors.fill: parent
    color: "transparent"
    id:controlLastActions

    property var dapWallets: []
    property string currWallet

    ListModel{
        id: dapModelWallets
    }

    ListModel
    {
        id: modelLastActions
    }
    ListModel
    {
        id: temporaryModel
    }

    Rectangle
    {
        id: viewLastActions
        anchors.fill: parent
        color: "#363A42"
        radius: 16 

        Rectangle
        {
            anchors.fill: parent
            color: viewLastActions.color
            radius: viewLastActions.radius
            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: Rectangle
                {
                    width: viewLastActions.width
                    height: viewLastActions.height
                    radius: viewLastActions.radius
                }
            }

            // Header
            Item
            {
                id: lastActionsHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 38 

                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 
                    anchors.topMargin: 10 
                    anchors.bottomMargin: 10 
                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Last Actions")
                    font.family: "Quicksand"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#ffffff"
                }
            }

            ListView
            {

                id: lastActionsView
                anchors.top: lastActionsHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true
                model: modelLastActions
                delegate: DapDelegateLastActions{}

                section.property: "date"
                section.criteria: ViewSection.FullString
                section.delegate: delegateDate

                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                Component
                {
                    id: delegateDate
                    Rectangle
                    {
                        height: 30 
                        width: parent.width
                        color: "#2E3138"

                        Text
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16 
                            anchors.rightMargin: 16 
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            color: "#ffffff"
                            font.family: "Quicksand"
                            font.pixelSize: 12
                            text: section

                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        modelLastActions.clear()
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: viewLastActions
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 10
        cached: true
        color: "#2A2C33"
        source: viewLastActions
        visible: viewLastActions.visible
    }
    InnerShadow {
        anchors.fill: viewLastActions
        horizontalOffset: -1
        verticalOffset: -1
        radius: 0
        samples: 10
        cached: true
        color: "#4C4B5A"
        source: topLeftSadow
        visible: viewLastActions.visible
    }

    Connections
    {
        target: dapServiceController
        onWalletsReceived:
        {
            var jsonDocument = JSON.parse(walletList)

            if(!jsonDocument.length)
            {
                dapModelWallets.clear()
                return
            }

            dapModelWallets.clear()
            dapModelWallets.append(jsonDocument)

            for (var i = 0; i < walletModelList.count; ++i)
            {
                getWalletHistory(i, true)
            }
        }
        onAllWalletHistoryReceived:
        {
            if(walletHistory !== "isEqual")
            {
                var jsonDocument = JSON.parse(walletHistory)

                if (jsonDocument.length !== temporaryModel.count)
                {

                    temporaryModel.clear()

                    for (var q = 0; q < jsonDocument.length; ++q)
                    {
                        if (temporaryModel.count === 0)
                            temporaryModel.append(jsonDocument[q])
                        else
                        {

                            var j = 0;
                            while (temporaryModel.get(j).date_to_secs > jsonDocument[q].date_to_secs)
                            {
                                ++j;
                                if (j >= temporaryModel.count)
                                    break;
                            }
                            temporaryModel.insert(j, jsonDocument[q])
                        }
                    }

                    for (var q = 0; q < temporaryModel.count; ++q)
                    {
                        modelLastActions.append(temporaryModel.get(q))
                    }
                }
            }
        }
    }

    function getWalletHistory(index, update)
    {

        if (index < 0 || index >= walletModelList.count)
            return

        var network_array = ""

        var name = dapModelWallets.get(index).name

        var model = dapModelWallets.get(index).networks

        for (var i = 0; i < model.count; ++i)
        {
            network_array += model.get(i).name + ":"
            network_array += name + "/"
        }
        // logicMainApp.requestToService("DapGetWalletHistoryCommand", network_array, update ? "true": "false", "false");
    }
}
