import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

DapTopPanel {

    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundPanel

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 30*pt
        anchors.rightMargin: 30*pt

        Text
        {
//            Layout.fillWidth: true
            Layout.minimumHeight: 30
            color: currTheme.textColorGray
            font: mainFont.dapFont.medium16
            text: qsTr("Time Connected:")
        }

        Text
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 30
            color: currTheme.textColor
            font: mainFont.dapFont.medium16
            text: "1d 16h 34m 18s"
        }

        Image
        {
            width: 21 * pt
            height: 26 * pt
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/page.png"
        }
    }

}
