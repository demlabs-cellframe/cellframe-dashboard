import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "parts"



Rectangle {
    id: root

    signal findHandler(string text)
    anchors.left: parent.left

    color: currTheme.backgroundPanel
    //color: "#211A3A"    //design color
//    color: "#070023"      //original color
//    radius: 8 * pt


    implicitWidth: searchBox.x + searchBox.width
    implicitHeight: searchBox.y + searchBox.height



    SearchInputBox {
        id: searchBox
        x: 38 * pt
        anchors.verticalCenter: parent.verticalCenter

        placeholderText: qsTr("Search")
        height: 28 * pt
        width: Math.max(Math.min(leftPadding + contentWidth, root.width - searchBox.x * 2), 228 * pt)
        color: "#B0AEB9"
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14

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


    //right Rectangle
    Rectangle {
        color: parent.color
        height: parent.height
        width: parent.radius
        x: parent.width - width
    }


}  //root

