.pragma library

function rcvPluginList(buffer, parent) {

    var dapData = []
    var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
            ListModel {}',parent);


    for(var i = 0; i < buffer.length ; i++)
    {
        dapData.push(buffer[i])
    }
    for(var q = 0; q < dapData.length; q++)
    {
        console.log("Plugin name: "+ dapData[q][0] + " - Loaded")
        dapModel.append({"name" : dapData[q][0],
                         "path" : dapData[q][1],
                         "status" : dapData[q][2],
                         "verifed" : dapData[q][3]})
    }
    return dapModel
}
