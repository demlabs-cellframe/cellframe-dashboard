import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


/*

  need move to common module


*/



TextField {
    id: root

    property alias filtering: filtering
    property alias searchImage: searchImage
    property int spacing: 10 * pt


    implicitHeight: 50 * pt
    implicitWidth: 100 * pt
    leftPadding: searchImage.width + spacing
    font.pixelSize: 14 * pt
    topPadding: 0
    bottomPadding: 8 * pt


    Image{
        id: searchImage
        width: 20 * pt
        height: 20 * pt
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter

        source: "qrc:/resources/icons/ic_search.png"
    }

    background: Item {  }


    //bottom line
    Rectangle {
        width: parent.width
        height: 1 * pt
        y: parent.height
        color: "#453F5A"

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




