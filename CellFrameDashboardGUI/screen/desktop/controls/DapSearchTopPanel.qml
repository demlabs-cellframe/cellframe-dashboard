import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
//import "qrc:/widgets"
//import "parts"



DapTopPanel {
    id: root

    signal findHandler(string text)

    // Frame icon search
    Image
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 38 * pt
        y: 21 * pt
        height: 19 * pt
        width: 19 * pt
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter

        source: "qrc:/resources/icons/ic_search.png"
    }

    SearchInputBox {
        id: searchBox
        //x: 38 * pt
//        x: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: frameIconSearch.right
        anchors.leftMargin: 7 * pt

        bottomLineVisible: false
        validator: RegExpValidator { regExp:  /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

        placeholderText: qsTr("Search")
        height: 28 * pt
//        width: Math.max(Math.min(leftPadding + contentWidth, root.width - searchBox.x * 2), 228 * pt)
//        color: currTheme.textColor
        font: mainFont.dapFont.regular14
//        textColor: currTheme.textColorGray


        onEditingFinished: {
            filtering.clear()
            root.findHandler(text)
        }

        filtering.waitInputInterval: 100
        filtering.minimumSymbol: 0
        filtering.onAwaitingFinished: {
            root.findHandler(text)
        }
    }


    Rectangle {
        width: searchBox.width
        height: 1 * pt
        anchors.top: searchBox.bottom
        anchors.topMargin: 3 * pt
        anchors.left: frameIconSearch.left
        color: "#393B41" //currTheme.borderColor
    }


    //right Rectangle
    Rectangle {
//        color: parent.color
        height: parent.height
        width: parent.radius
        x: parent.width - width
    }


}  //root
