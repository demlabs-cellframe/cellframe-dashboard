import QtQuick 2.9
import QtQuick.Controls 2.5

ItemDelegate {
    property string delegateContentText: ""

    width: parent.width
    height: 42 * pt
    contentItem: DapUiQmlWidgetStatusBarContentItem {
        anchors.fill: parent
        anchors.topMargin: 8 * pt
        anchors.leftMargin: 12 * pt
        anchors.rightMargin: 16 * pt
        verticalAlignment: Qt.AlignTop
        text: delegateContentText
        color: hovered ? "#FFFFFF" : "#332F49"
    }

    background: Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 10 * pt
        color: hovered ? "#332F49" : "#FFFFFF"
    }

    highlighted: parent.highlightedIndex === index

}
