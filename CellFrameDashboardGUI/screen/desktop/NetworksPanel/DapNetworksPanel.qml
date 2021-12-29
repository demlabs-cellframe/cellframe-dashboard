import QtQuick 2.7

Rectangle {
    id: control

//    implicitHeight: Math.max(btnPrevious.implicitHeight, networksListView.implicitHeight, btnNext.implicitHeight)
    height: 43 * pt
    implicitWidth: btnPrevious.implicitWidth + btnNext.implicitWidth + 180 * pt

    color: currTheme.backgroundPanel

    DapNetworkPanelButton {
        id: btnPrevious

        visible: networksListView.hasLeft
        height: parent.height
        mirror: true
        normalIcon: "qrc:/resources/icons/next-page.svg"
        hoverIcon: "qrc:/resources/icons/next-page_hover.svg"
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
        normalIcon: "qrc:/resources/icons/next-page.svg"
        hoverIcon: "qrc:/resources/icons/next-page_hover.svg"
        onClicked: networksListView.scrollToRight()
    }
}
