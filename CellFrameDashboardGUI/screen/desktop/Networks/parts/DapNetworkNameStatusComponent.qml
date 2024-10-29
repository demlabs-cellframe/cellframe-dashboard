import QtQuick 2.4

Item
{
    property alias indicator: indicatorIcon

    property string nameOfNetwork: ""
    property string stateOfNetwork: ""
    property string stateOfTarget: ""
    property string percentOfSync: ""

    anchors.fill: parent

    // spiner
    Item
    {
        width: 15
        height: 15
        anchors.right: nameAndIndicatorItem.left
        anchors.rightMargin: 2
        y: parent.height / 2 - height / 2
        visible: !(stateOfNetwork === "NET_STATE_OFFLINE" || stateOfNetwork === "NET_STATE_ONLINE")

        Image
        {
            id: syncIcon
            anchors.centerIn: parent
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(15,15)
            source: "qrc:/Resources/" + pathTheme + "/icons/other/sync_15x15.svg"

            NumberAnimation on rotation
            {
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
            verticalAlignment: Text.AlignVCenter
        }

        Image
        {
            id: indicatorIcon
            width: 8
            height: 8
            anchors.right: parent.right
            anchors.verticalCenter: nameText.verticalCenter
            sourceSize: Qt.size(8,8)
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            source: stateOfNetwork === "NET_STATE_OFFLINE" ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_offline.svg" :
                                        stateOfNetwork === "ERROR" ?  "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.svg":
                                        "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.svg"                                                                                                                                                                                             
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
        visible: !(stateOfNetwork === "NET_STATE_OFFLINE" || stateOfNetwork === "NET_STATE_ONLINE")

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
