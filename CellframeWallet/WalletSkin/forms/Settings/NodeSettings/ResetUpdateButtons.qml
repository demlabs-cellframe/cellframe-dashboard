import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"

ColumnLayout
{
    property alias resetVisible: resetButton.visible
    property alias updateVisible: updateButton.visible

    property bool updateAvailable: false

    signal resetClicked()
    signal updateClicked()

    Layout.fillWidth: true
//    Layout.minimumHeight: resetButton.height + 10 + updateButton.height + 10
//    Layout.minimumHeight: 100

    DapButton
    {
        id: resetButton
        Layout.topMargin: 10
        Layout.fillWidth: true
        Layout.minimumHeight: 36

        textButton: qsTr("Reset to default")

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        defaultColor: currTheme.secondaryBackground
        defaultColorNormal0: currTheme.secondaryBackground
        defaultColorNormal1: currTheme.secondaryBackground
        opacityDropShadow: 0
        opacityInnerShadow: 0
        defaultColorHovered0: currTheme.lime
        defaultColorHovered1: currTheme.lime
        colorButtonTextHover: currTheme.mainBackground

        radius: 10

        onClicked:
        {
            resetClicked()
        }
    }

    DapButton
    {
        id: updateButton

        Layout.topMargin: 10
        Layout.fillWidth: true
        Layout.minimumHeight: 36

        textButton: qsTr("Update config")

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        defaultColor: currTheme.secondaryBackground
        defaultColorNormal0: currTheme.secondaryBackground
        defaultColorNormal1: currTheme.secondaryBackground
        opacityDropShadow: 0
        opacityInnerShadow: 0
        defaultColorHovered0: currTheme.lime
        defaultColorHovered1: currTheme.lime
        colorButtonTextHover: currTheme.mainBackground
        radius: 10

        onClicked:
        {
            updateClicked()
        }
    }
}
