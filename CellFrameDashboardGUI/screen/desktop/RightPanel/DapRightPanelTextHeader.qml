import QtQuick 2.7

Item {
    property alias caption: text.text

    Text {
        id: text

        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(implicitWidth, parent.width)

        elide: Text.ElideRight
        font:  _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
        color: "#3E3853"
    }
}
