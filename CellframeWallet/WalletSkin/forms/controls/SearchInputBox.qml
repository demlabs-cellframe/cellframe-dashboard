import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"


/*

  need move to common module

*/



DapWalletTextField {
    id: root

    property alias filtering: filtering

    placeholderColor: currTheme.textColorGray

    implicitHeight: 30
    implicitWidth: 230 
    font:mainFont.dapFont.regular14
    validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

    backgroundColor: currTheme.backgroundPanel

    onTextChanged: {
        filtering.filter(text)
    }

    //for mobile input
    onDisplayTextChanged: {
        filtering.filter(text)
    }


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
    selectByMouse: true

} // root




