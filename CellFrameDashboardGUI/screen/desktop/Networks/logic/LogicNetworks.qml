import QtQuick 2.0
import QtQml 2.12

QtObject {

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    function getCountVisiblePopups()
    {
        var count = networkList.width/item_width
        return Math.floor(count)
    }

    function notifyModelUpdate(data)
    {
        if(networksModel.count)
        {
            for(var i = 0; i < networksModel.count; i++)
            {
                if(networksModel.get(i).name === data.name)
                {
                    networksModel.get(i).networkState = data.networkState.substr(10)
                    networksModel.get(i).targetState = data.targetState.substr(10)
                    networksModel.get(i).errorMessage = data.errorMessage
                    networksModel.get(i).linksCount = data.linksCount.toString()
                    networksModel.get(i).activeLinksCount = data.activeLinksCount.toString()
                    networksModel.get(i).nodeAddress = data.nodeAddress
                }
            }
        }
        else
        {
            networksModel.append({ "name" : data.name,
                                   "networkState" : data.networkState,
                                   "targetState" : data.targetState,
                                   "errorMessage" : data.errorMessage,
                                   "linksCount" : data.linksCount.toString(),
                                   "activeLinksCount" : data.activeLinksCount.toString(),
                                   "nodeAddress" : data.nodeAddress})
        }
    }

    function modelUpdate(networksStatesList)
    {
        if (!isNetworkListsEqual(networksModel, networksStatesList)) {

            networksModel.clear()
            for (var i = 0; i < networksStatesList.length; ++i)
            {
                networksModel.append({  "name" : networksStatesList[i].name,
                                        "networkState" : networksStatesList[i].networkState,
                                        "targetState" : networksStatesList[i].targetState,
                                        "errorMessage" : networksStatesList[i].errorMessage,
                                        "linksCount" : networksStatesList[i].linksCount,
                                        "activeLinksCount" : networksStatesList[i].activeLinksCount,
                                        "nodeAddress" : networksStatesList[i].nodeAddress})
            }
        } else {
            updateContentForExistingModel(networksModel, networksStatesList)
        }
    }

    function updateContentForExistingModel(curModel, newData)
    {
        if (isNetworkListsEqual(curModel, newData)) {
            for (var i=0; i<curModel.count; ++i) {
                if (curModel.get(i).name !== newData[i].name)
                    curModel.set(i, {"name": newData[i].name})
                if (curModel.get(i).networkState !== newData[i].networkState)
                    curModel.set(i, {"networkState": newData[i].networkState})
                if (curModel.get(i).targetState !== newData[i].targetState)
                    curModel.set(i, {"targetState": newData[i].targetState})
                if (curModel.get(i).errorMessage !== newData[i].errorMessage)
                    curModel.set(i, {"errorMessage": newData[i].errorMessage})
                if (curModel.get(i).linksCount !== newData[i].linksCount)
                    curModel.set(i, {"linksCount": newData[i].linksCount})
                if (curModel.get(i).activeLinksCount !== newData[i].activeLinksCount)
                    curModel.set(i, {"activeLinksCount": newData[i].activeLinksCount})
                if (curModel.get(i).nodeAddress !== newData[i].nodeAddress)
                    curModel.set(i, {"nodeAddress": newData[i].nodeAddress})
            }
        }
    }

    function updateContentInSpecifiedPopup(popup, curDataFromModel)
    {
        if (popup.name !== curDataFromModel.name)
            popup.name = curDataFromModel.name
        if (popup.networkState !== curDataFromModel.networkState)
            popup.networkState = curDataFromModel.networkState
        if (popup.errorMessage !== curDataFromModel.errorMessage)
            popup.errorMessage = curDataFromModel.errorMessage
        if (popup.targetState !== curDataFromModel.targetState)
            popup.targetState = curDataFromModel.targetState
        if (popup.linksCount !== curDataFromModel.linksCount)
            popup.linksCount = curDataFromModel.linksCount
        if (popup.activeLinksCount !== curDataFromModel.activeLinksCount)
            popup.activeLinksCount = curDataFromModel.activeLinksCount
        if (popup.nodeAddress !== curDataFromModel.nodeAddress)
            popup.nodeAddress = curDataFromModel.nodeAddress
    }

    function updateContentInAllOpenedPopups(curModel)
    {
        for (var i=0; i<curModel.count; ++i) {
            updateContentInSpecifiedPopup(networksModel.get(i), curModel.get(i))
        }
    }

    function isNetworkListsEqual(curModel, newData)
    {
        if (curModel.count === newData.length) {
            for (var i=0; i<curModel.count; ++i) {
                if (curModel.get(i).name !== newData[i].name) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }


}
