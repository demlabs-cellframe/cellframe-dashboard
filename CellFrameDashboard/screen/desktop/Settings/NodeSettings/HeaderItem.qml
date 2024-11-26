import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../controls"
import "qrc:/widgets"

Rectangle
{
    property string headerName: ""

    Layout.fillWidth: true
    height: 30
    color: currTheme.mainBackground

    Text
    {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        font: mainFont.dapFont.medium12
        color: currTheme.white
        verticalAlignment: Qt.AlignVCenter
        text: headerName
    }
}
