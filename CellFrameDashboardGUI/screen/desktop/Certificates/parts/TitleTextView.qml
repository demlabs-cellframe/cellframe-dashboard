import QtQuick 2.9
import QtQuick.Layouts 1.3



Item {
    id: root

    property alias title: title
    property alias content: content

    property int verticalSpacing: 10 * pt


    implicitWidth: Math.max(title.width, content.width)
    implicitHeight: title.height + verticalSpacing + content.height


    Text {
        id: title
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
        color: "#B4B1BD"
        elide: Text.ElideRight
        maximumLineCount: 1
    }



    Text {
        id: content
        y: title.height + verticalSpacing
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
        color: "#070023"
        elide: Text.ElideRight
        maximumLineCount: 1
    }


}   //
