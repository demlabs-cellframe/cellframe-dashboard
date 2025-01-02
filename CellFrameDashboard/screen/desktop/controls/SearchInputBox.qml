import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"


/*

  need move to common module

*/



DapTextField {
    id: root

    property alias filtering: filtering

    placeholderColor: currTheme.gray

    implicitHeight: 30
    implicitWidth: 230 
    font:mainFont.dapFont.regular14
    validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

    selectByMouse: true
    DapContextMenu{}

    backgroundColor: currTheme.mainBackground

    onTextChanged: {
        filtering.filter(text)
    }

    //for mobile input
    onDisplayTextChanged: {
        filtering.filter(text)
    }

    Keys.onReturnPressed: focus = true


    //optional
//            onAccepted: {
//                console.log("SearchInputBox.onAccepted:", text)
//            }

//            onEditingFinished: {
//                filtering.clear()
//                console.log("SearchInputBox.onEditingFinished:", text)
//            }


//            onTextEdited: {
//                console.log("SearchInputBox.onEdited:", text)
//            }


    TextInputFilter {
        id: filtering
        minimumSymbol: 3
        waitInputInterval: 500
        onAwaitingFinished: {
            //console.log("onAwaitingFinished:", text)
        }
    }
} // root




