import QtQuick 2.4
import QtQuick.Controls 2.10
import QtGraphicalEffects 1.0
import qmlclipboard 1.0

MouseArea {

    id: area
    property int selectStart
    property int selectEnd
    property int curPos

    property color backgroundColor: currTheme.mainBackground
    property color separatorColor: currTheme.secondaryBackground

    property color backgroundDelegateColorNormal: currTheme.secondaryBackground
    property color backgroundDelegateColorHover: currTheme.lime

    property color contentTextColorNormal: currTheme.white
    property color contentTextColorHover: currTheme.mainBackground
    property color contentTextColorDown: currTheme.gray

    property color indicatorColor: currTheme.border
    property color indicatorBorderColor: currTheme.mainBackground
    property int   indicarotRadius: 3

    property bool isActiveCopy: true

    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    hoverEnabled: true
    onClicked: {
        openMenu(mouse)
    }
    onPressAndHold: {
        if (mouse.source === Qt.MouseEventNotSynthesized) {
        openMenu(mouse)
        }
    }

    QMLClipboard{id: clipboard}

    Menu {
        id: menu

        MenuItem {
            id: cut
            enabled: isActiveCopy
            text: qsTr("Cut")
            onTriggered: {
                area.parent.cut()
            }
            topPadding: 8
            bottomPadding: 8
            leftPadding: 12
            rightPadding: 12

            contentItem:
            Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: cut.hovered ? contentTextColorHover : contentTextColorNormal/*
                           menuItem.down ? contentTextColorDown : */
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            background:
            Item{
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 4
                    opacity: enabled ? 1 : 0.3
                    color: cut.hovered ? backgroundDelegateColorHover : backgroundDelegateColorNormal
                }
            }

        }
        MenuItem {
            id: copy
            text: qsTr("Copy")
            enabled: isActiveCopy
            onTriggered: {
                area.parent.copy()
            }
            topPadding: 8
            bottomPadding: 8
            leftPadding: 12
            rightPadding: 12

            contentItem:
            Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: copy.hovered ? contentTextColorHover : contentTextColorNormal/*
                           menuItem.down ? contentTextColorDown : */
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }


            background:
            Item{
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 4
                    opacity: enabled ? 1 : 0.3
                    color: copy.hovered ? backgroundDelegateColorHover : backgroundDelegateColorNormal
                }
            }
        }
        MenuItem {
            id: paste
            text: qsTr("Paste")
            onTriggered: {
                area.parent.paste()
            }
            topPadding: 8
            bottomPadding: 8
            leftPadding: 12
            rightPadding: 12

            contentItem:
            Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: paste.hovered ? contentTextColorHover : contentTextColorNormal/*
                           menuItem.down ? contentTextColorDown : */
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }


            background:
            Item{
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 4
                    opacity: enabled ? 1 : 0.3
                    color: paste.hovered ? backgroundDelegateColorHover : backgroundDelegateColorNormal
                }
            }
        }

        topPadding: 0
        bottomPadding: 0

        background:
            Item{
            implicitWidth: 90

            Rectangle
            {
                id: background
                anchors.fill: parent
                radius: 4
                color: backgroundColor
            }
            DropShadow {
                id: shadow
                anchors.fill: background
                horizontalOffset: 2
                verticalOffset: 2
                radius: 4
                samples: 10
                cached: true
                color: "#000000"
                opacity: 0.56
                source: background
                }
        }

        font: mainFont.dapFont.medium12
    }

    function openMenu(mouse)
    {
        selectStart = parent.selectionStart;
        selectEnd = parent.selectionEnd;
        curPos = parent.cursorPosition;
        menu.x = mouse.x;
        menu.y = mouse.y;
        menu.open();
        parent.cursorPosition = curPos;
        parent.select(selectStart,selectEnd);
    }
}
