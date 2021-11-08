import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "parts"



DapTopPanel {
    id: root

    signal findHandler(string text)
//    anchors.left: parent.left

    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle
//    color: currTheme.backgroundMainScreen
    //color: "#211A3A"    //design color
//    color: "#070023"      //original color
//    radius: 8 * pt


//    implicitWidth: searchBox.x + searchBox.width
//    implicitHeight: searchBox.y + searchBox.height


    // Frame icon search
    Rectangle
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 16 * pt
        anchors.verticalCenter: parent.verticalCenter
        height: 20 * pt
        width: 20 * pt
        color: "transparent"
        Image
        {
            id: iconSearch
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter

            source: "qrc:/resources/icons/ic_search.png"
        }
    }


    SearchInputBox {
        id: searchBox
        x: 38 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: frameIconSearch.right
        anchors.leftMargin: 10 * pt

        placeholderText: qsTr("Search")
        height: 28 * pt
//        width: Math.max(Math.min(leftPadding + contentWidth, root.width - searchBox.x * 2), 228 * pt)
//        color: currTheme.textColor
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

