import QtQuick 2.4

Item
{
    property alias indicator: indicatorIcon

    property string nameOfNetwork: ""
    property string stateOfNetwork: ""
    property string stateOfTarget: ""
    property string percentOfSync: ""

    anchors.fill: parent

    Item
    {
        width: 24
        height: 24
        anchors.right: nameAndIndicatorItem.left
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        visible: progressItem.visible

        Image
        {
            id: syncIcon
            anchors.fill: parent
            sourceSize: Qt.size(24,24)
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/" + pathTheme + "/icons/other/sync.svg"

            NumberAnimation on rotation {
                from: 0
                to: -360
                duration: 1000
                loops: Animation.Infinite
                running: true
            }
        }
    }

    Item
    {
        id: nameAndIndicatorItem
        width: nameText.contentWidth + nameText.anchors.rightMargin + indicatorIcon.width
        height: 15
        anchors.centerIn: parent
        anchors.leftMargin: 2

        Text
        {
            id: nameText
            height: parent.height
            anchors.right: indicatorIcon.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.white
            text: nameOfNetwork
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignRight
        }

        Image
        {
            id: indicatorIcon
            width: 8
            height: 8
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            sourceSize: Qt.size(8,8)
            antialiasing: true
            fillMode: Image.PreserveAspectFit

            source: stateOfNetwork === "NET_STATE_ONLINE" ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.svg" :
                                                          stateOfNetwork !== stateOfTarget ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png" :
                                                                                         stateOfNetwork === "ERROR" ?  "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.svg":
                                                                                                                    "qrc:/Resources/" + pathTheme + "/icons/other/indicator_offline.svg"
        }
    }

    Item
    {
        id: progressItem
        height: 3
        anchors.left: nameAndIndicatorItem.left
        anchors.right: nameAndIndicatorItem.right
        anchors.top: nameAndIndicatorItem.bottom
        anchors.topMargin: 3

        visible: logicNet.percentToRatio(percentOfSync) < 1.0

        Rectangle
        {
            id: backProgress
            width: parent.width
            height: 2
            anchors.centerIn: parent
            radius: 400
            color: currTheme.clickableObjects
        }

        Rectangle
        {
            id: frontProgress
            implicitWidth: logicNet.percentToRatio(percentOfSync) * parent.width
            height: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            radius: 400
            color: currTheme.progressBarActive
            z: parent.z + 1
        }
    }
}
