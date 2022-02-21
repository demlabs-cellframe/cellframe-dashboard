import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"

DapTopPanel
{
    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundPanel

    Text {
        anchors
        {
            right: parent.right
            top: parent.top
            rightMargin: 24 * pt
            topMargin: 23 * pt
        }

        text: qsTr( "Vesion " + dapServiceController.Version)
        font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
        color: currTheme.textColor

    }
}
