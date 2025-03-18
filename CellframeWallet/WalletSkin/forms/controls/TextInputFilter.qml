import QtQuick 2.0



Item {
    id: root

    signal awaitingFinished(string text)

    property alias blockInputInterval: blockInputTimer.interval
    property alias waitInputInterval: waitInputTimer.interval

    readonly property alias validTextLength: pObj.validTextLength
    readonly property alias awaitingValidText: pObj.awaitingValidText

    property int minimumSymbol: 3


    //for set text in text field without  signal emited
    function blockSignal(){
        blockInputTimer.restart()
    }


    //use this function for filtering text after changed in input field
    function filter(text){
        pObj.validTextLength = text.length >= minimumSymbol
        //console.log("TextInputFiltering.filter:", text, validTextLength)

        if (!blockInputTimer.running){
            if (validTextLength) {            //минимум символов для поиска адресов 3
                pObj.awaitingValidText = text
                waitInputTimer.restart()
            }
        }

    }


    function clear(){
        blockInputTimer.stop()
        waitInputTimer.stop()
        pObj.awaitingValidText = ""
    }


    Timer{
        id: blockInputTimer
        interval: 600
    }

    Timer{
        id: waitInputTimer
        interval: 1000
        onTriggered: {
           awaitingFinished(pObj.awaitingValidText)  //возможно неверный объект
        }
    }


    QtObject{
        id: pObj
        property bool validTextLength: false
        property string awaitingValidText: ""
    }


}   //root


