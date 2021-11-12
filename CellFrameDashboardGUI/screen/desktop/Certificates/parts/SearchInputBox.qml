import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4


/*

  need move to common module


*/



TextField {
    id: root

    property alias filtering: filtering
    property int spacing: 10 * pt


    implicitHeight: 27 * pt
    implicitWidth: 230 * pt
    font:dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14

    style:
        TextFieldStyle
        {
            textColor: currTheme.textColor
            placeholderTextColor: currTheme.textColorGray
            background:
                Rectangle
                {
                    border.width: 0
                    color: currTheme.backgroundPanel
                }
        }


    //bottom line
    Rectangle {
        width: parent.width
        height: 1 * pt
        y: parent.height
        color: currTheme.borderColor

        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }


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




} // root




