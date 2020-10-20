import QtQuick 2.7

Rectangle {
    id: control

    implicitHeight: Math.max(btnPrevious.implicitHeight, networksListView.implicitHeight, btnNext.implicitHeight)
    implicitWidth: btnPrevious.implicitWidth + btnNext.implicitWidth + 180 * pt

    color: "#070023"

    DapNetworkPanelButton {
        id: btnPrevious

        visible: networksListView.hasLeft
        height: parent.height
        normalIcon: "qrc:/resources/icons/networks_previous_icon.png"
        hoverIcon: "qrc:/resources/icons/networks_previous_icon_hover.png"
        onClicked: networksListView.scrollToLeft()
    }

    DapNetworksList {
        id: networksListView

        anchors.left: btnPrevious.right
        anchors.right: btnNext.left
        height: parent.height
    }

    DapNetworkPanelButton {
        id: btnNext

        visible: networksListView.hasRight
        anchors.right: parent.right
        height: parent.height
        normalIcon: "qrc:/resources/icons/networks_next_icon.png"
        hoverIcon: "qrc:/resources/icons/networks_next_icon_hover.png"
        onClicked: networksListView.scrollToRight()
    }
}
