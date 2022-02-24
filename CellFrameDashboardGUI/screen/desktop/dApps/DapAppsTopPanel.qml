import QtQuick 2.4
import QtQuick.Controls 2.0
import Demlabs 1.0
import "../../"
//import "qrc:/widgets"
import "../../controls"
import "../Certificates/parts"

DapTopPanel
{
    id: control
//    anchors.leftMargin: 4*pt
//    radius: currTheme.radiusRectangle

    signal findHandler(string text)

    Image
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 34 * pt
        anchors.verticalCenter: parent.verticalCenter
        height: 20 * pt
        width: 20 * pt
        //color: "transparent"
        //id: iconSearch
        //anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter

        source: "qrc:/resources/icons/ic_search.png"
    }

    SearchInputBox {
        id: searchBox

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: frameIconSearch.right
        anchors.leftMargin: 7 * pt

        bottomLineVisible: false

        placeholderText: qsTr("Search")
        height: 28 * pt
        font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14

        onEditingFinished: {
            filtering.clear()
            control.findHandler(text)
        }

        filtering.waitInputInterval: 100
        filtering.minimumSymbol: 0
        filtering.onAwaitingFinished: {
            control.findHandler(text)
        }
    }

    Rectangle {
        width: 227 * pt
        height: 1 * pt
        anchors.top: searchBox.bottom
        anchors.left: frameIconSearch.left
        anchors.topMargin: 4 * pt
        color: "#393B41" //currTheme.borderColor
    }


    //right Rectangle
    Rectangle {
        color: parent.color
        height: parent.height
        width: parent.radius
        x: parent.width - width
    }

}
