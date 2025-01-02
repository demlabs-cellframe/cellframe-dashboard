import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Rectangle
{
    property bool isNodeWorking: modulesController.isNodeWorking

    property color mainColor: currTheme.secondaryBackground
    property color secondColor: currTheme.loadingPanel

    property bool spinerEnabled: false
    property bool radiusEnabled: false

    property bool fillEmptyItems: false

    property int radiusPower: 100
    property int emptyItemHeight: 32

    id: mainRect
    anchors.fill: parent
    color: mainColor
    visible: !isNodeWorking
    z: parent.z + 10

    Rectangle
    {
        id: secondRect
        anchors.fill: parent
        radius: radiusPower
        color: secondColor
        visible: radiusEnabled
    }

    Image
    {
        id: spiner
        width: 48
        height: 48
        anchors.centerIn: parent
        sourceSize: Qt.size(48,48)
        smooth: true
        antialiasing: true
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Resources/" + pathTheme + "/icons/other/loader.svg"
        visible: spinerEnabled

        RotationAnimator
        {
            target: spiner
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            running: true
        }
    }

    ListView
    {
        anchors.fill: parent
        spacing: 0
        clip: true
        model: parent.height / emptyItemHeight - 1
        visible: fillEmptyItems

        delegate:
            Item
        {
            width: mainRect.width
            height: emptyItemHeight

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                anchors.topMargin: 6
                anchors.bottomMargin: 6
                color: secondColor
                radius: radiusPower
            }
        }
    }

    MouseArea
    {
        enabled: !isNodeWorking
        anchors.fill: parent
        hoverEnabled: true
        onClicked:
        {
            console.log("Wait loading node.")
        }
        onHoveredChanged: {}
    }
}
