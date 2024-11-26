Qt.include("qrc:/resources/JS/TimeFunctions.js")

//Fills in the model.
WorkerScript.onMessage = function(msg)
{
    msg.model.clear();
    var count = Object.keys(msg.stringList).length
    console.log(count);
    var thisDay = new Date();
    var privateDate = {'today' : thisDay,
                        'todayDay': thisDay.getDate(),
                        'todayMonth': thisDay.getMonth(),
                        'todayYear': thisDay.getFullYear()};

    for (var ind = count-1; ind >= 0; ind--)
    {
        var arrLogString = parceStringFromLog(msg.stringList[ind]);
        var stringTime = parceTime(arrLogString[1]);

        if(stringTime !== "error")
            msg.model.append({"type": arrLogString[2],
                                 "info": arrLogString[4],
                                 "file": arrLogString[3],
                                 "time": getTime(stringTime),
                                 "date": getDay(stringTime, privateDate),
                                 "momentTime": stringTime});
    }
    msg.model.sync();
    WorkerScript.sendMessage({result: true});
}
