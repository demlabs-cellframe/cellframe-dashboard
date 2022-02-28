import QtQuick 2.7

Rectangle {
    id: control

    height: 40 * pt

    color: currTheme.backgroundPanel

/*    DapNetworkPanelButton {
        id: btnPrevious

        visible: networksListView.hasLeft
        height: parent.height
        mirror: true
        normalIcon: "qrc:/resources/icons/next-page.svg"
        hoverIcon: "qrc:/resources/icons/next-page_hover.svg"
        onClicked: networksListView.scrollToLeft()
    }*/

/*    DapNetworksList {
        id: networksListView

        width: parent.width
//        anchors.left: btnPrevious.right
//        anchors.right: btnNext.left
        height: parent.height
    }*/

/*    DapNetworkPanelButton {
        id: btnNext

        visible: networksListView.hasRight
        anchors.right: parent.right
        height: parent.height
        normalIcon: "qrc:/resources/icons/next-page.svg"
        hoverIcon: "qrc:/resources/icons/next-page_hover.svg"
        onClicked: networksListView.scrollToRight()
    }*/
}
