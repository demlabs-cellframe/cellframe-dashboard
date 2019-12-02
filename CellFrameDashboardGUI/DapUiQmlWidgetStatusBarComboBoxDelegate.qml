import QtQuick 2.0
import QtQuick.Controls 2.5

///This file will be deleted in feature 2708
ItemDelegate {
    property string delegateContentText: ""
    width: parent.width
    height:{
        if(index == currentIndex) return 0
            else
                return 42*pt
    }
    contentItem: DapUiQmlWidgetStatusBarContentItem {
        id:textDelegateComboBox
        anchors.fill: parent
        anchors.topMargin: 8 * pt
        anchors.leftMargin: 16 * pt
        verticalAlignment: Qt.AlignTop
        Text{
            font.pixelSize: fontSizeDelegateComboBox//14 *pt
            text: delegateContentText
            color: hovered ? "#FFFFFF" : "#332F49"
        }


    }

    background: Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 10 * pt
        color: hovered ? hilightColor : "#FFFFFF"
    }

    highlighted: parent.highlightedIndex === index

}
