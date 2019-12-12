import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: rightPanel
    property alias header: stackViewHeader
    property alias content: stackViewContent
    property alias background: rightPanelPage.background
    property alias footer: stackViewFooter

    width: visible ? 400 * pt : 0
    color: "#E3E2E6"

    Page {
        id: rightPanelPage
        anchors.fill: parent
        anchors.leftMargin: 1
        background: Rectangle {
            color: "#F8F7FA"
        }

        header: StackView {
            id: stackViewHeader
            width: parent.width
            height: currentItem === null ? 0 : currentItem.height
            clip: true
        }

        StackView {
            id: stackViewContent
            anchors.fill: parent
            clip: true
        }

        footer: StackView {
            id: stackViewFooter
            width: parent.width
            height: currentItem === null ? 0 : currentItem.height
            clip: true
        }
    }
}
