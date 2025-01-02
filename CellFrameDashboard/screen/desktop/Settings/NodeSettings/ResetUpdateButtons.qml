import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"

RowLayout
{
    property alias resetEnable: resetButton.enabled
    property alias updateEnable: updateButton.enabled

    property bool updateAvailable: false

    signal resetClicked()
    signal updateClicked()

    Layout.fillWidth: true
    Layout.leftMargin: 16
    Layout.rightMargin: 16
    Layout.topMargin: 20
    Layout.bottomMargin: 30
    Layout.alignment: Qt.AlignCenter
    spacing: 20
//    Layout.minimumHeight: resetButton.height + 10 + updateButton.height + 10
//    Layout.minimumHeight: 100

    DapButton
    {
        id: resetButton
//        enabled: false
        implicitHeight: 36
        Layout.fillWidth: true
        textButton: qsTr("Reset to default")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14

        onClicked:
        {
            resetClicked()
        }
    }

    DapButton
    {
        id: updateButton
//        enabled: false
        implicitHeight: 36
        Layout.fillWidth: true
        textButton: qsTr("Update config")
        horizontalAligmentText: Text.AlignHCenter
        indentTextRight: 0
        fontButton: mainFont.dapFont.medium14

        onClicked:
        {
            updateClicked()
        }
    }


/*    DapButton
    {
        id: resetButton
        Layout.topMargin: 10
        Layout.fillWidth: true
        Layout.minimumHeight: 36

        textButton: qsTr("Reset to default")

        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

//        defaultColor: "#262729"
        defaultColorNormal0: "#262729"
        defaultColorNormal1: "#262729"
//        opacityDropShadow: 0
//        opacityInnerShadow: 0
        defaultColorHovered0: "#363739"
        defaultColorHovered1: "#363739"

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

//        defaultColor: "#262729"
        defaultColorNormal0: "#262729"
        defaultColorNormal1: "#262729"
//        opacityDropShadow: 0
//        opacityInnerShadow: 0
        defaultColorHovered0: "#363739"
        defaultColorHovered1: "#363739"

        radius: 10

        onClicked:
        {
            updateClicked()
        }
    }*/
}
