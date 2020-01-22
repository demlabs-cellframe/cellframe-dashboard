import QtQuick 2.4

DapDashboardScreenForm
{
    buttonTest.onClicked: textTest.text = "DESKTOP " + textTest.font.pointSize + " " + textTest.font.pixelSize
}
