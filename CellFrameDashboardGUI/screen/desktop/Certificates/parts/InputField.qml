import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


//NOTE not use inner placeholderText:
//part common module


TextField {
    id: root

    property alias borderLine: borderLine
    property alias borderRadius: borderLine.radius
    property alias placeholderTextView: placeholderTextView

    property string smartPlaceHolderText: ""
    property string placeholderTextColor_: currTheme.textColorGray    //5.10

    property int borderWidth: 1 
    property int borderWidthWhenFocus: 2 
    property int textAndLineSpacing: 0

    property color backgroundColor: "transparent"
    property color backgroundColorWhenDisabled: backgroundColor
    property color borderColor: currTheme.borderColor
    property color borderColorWhenDisabled: borderColor

    color: currTheme.textColor
    verticalAlignment: TextInput.AlignVCenter
    selectByMouse: true

    leftPadding: 12 
    rightPadding: 6 
    topPadding: 3 
    bottomPadding: 6 

    Text {
        id: placeholderTextView
        visible: root.displayText === ""
        color: root.placeholderTextColor_
        text: root.smartPlaceHolderText
        anchors.fill: parent

        verticalAlignment: root.verticalAlignment
        horizontalAlignment: root.horizontalAlignment
        elide: Text.ElideRight

        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
        topPadding: root.topPadding
        bottomPadding: root.bottomPadding

        font: root.font
    }

    Rectangle {
        id: borderLine
        z: -1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -textAndLineSpacing
        width: parent.width
        height: 1 
        color: currTheme.borderColor
        border.color: root.enabled ? borderColor : borderColorWhenDisabled
        border.width: root.activeFocus ? borderWidthWhenFocus : borderWidth
    }

    //empty default background
    background: Item {  }
}   //root
