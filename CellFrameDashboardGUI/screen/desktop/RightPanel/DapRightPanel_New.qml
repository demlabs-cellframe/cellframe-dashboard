import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/widgets"

Rectangle {
    id: control

    property alias initialPage: stackView.initialItem

    function push(item)
    {
        stackView.push(item);
    }

    function pop()
    {
        if (stackView.depth > 1) {
            stackView.pop();
        } else if (stackView.depth == 1) {
            stackView.clear();
        }
    }

    function clear()
    {
        stackView.clear();
    }

    visible: stackView.currentItem != null
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: visible ? 24 * pt : 0
    anchors.leftMargin: 0
    width: visible ? 350 * pt : 0;
    border.color: "#E2E1E6"
    border.width: 1 * pt
    radius: 8 * pt

    Item {
        id: headerFrame

        width: parent.width
        height: 40 * pt

        DapButton_New {
            id: backButton

            x: 16 * pt
            height: 20 * pt
            width: height
            anchors.verticalCenter: parent.verticalCenter

            iconSource:      stackView.depth > 1 ? "qrc:/resources/icons/back_icon.png"       : "qrc:/resources/icons/Certificates/close_icon.svg"
            hoverIconSource: stackView.depth > 1 ? "qrc:/resources/icons/back_icon_hover.png" : "qrc:/resources/icons/Certificates/close_icon_hover.svg"

            iconSubcontroll.sourceSize: Qt.size(20 * pt, 20 * pt)
            onClicked: control.pop()
        }

        Item {
            id: headerItemFrame

            anchors {
                left: backButton.right
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                leftMargin: 16 * pt
            }
        }
    }

    Flickable {
        id: flickable

        anchors {
            left: parent.left
            top: headerFrame.bottom
            right: parent.right
            bottom: parent.bottom
        }

        contentWidth: stackView.width
        contentHeight: stackView.height
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: size == 1 ? ScrollBar.AsNeeded : ScrollBar.AlwaysOn
        }

        StackView {
            id: stackView

            width: flickable.width
            height: Math.max(currentItem ? currentItem.implicitHeight : 0, flickable.height)

            onCurrentItemChanged: {
                if (headerItemFrame.children.length)
                    headerItemFrame.children[0].destroy();

                if (!currentItem)
                    return;

                var headerComponent = currentItem.headerComponent ? currentItem.headerComponent : defaultHeaderComponent;
                var headerItem = headerComponent.createObject(headerItemFrame);
                headerItem.width = Qt.binding(function() { return headerItemFrame.width });
                headerItem.height = Qt.binding(function() { return headerItemFrame.height });
            }

            pushEnter: null
            pushExit: null
            popEnter: null
            popExit: null
            replaceEnter: null
            replaceExit: null
        }
    }

    Connections {
        target: stackView.currentItem

        onPushPageRequest: control.push(page)
        onPopPageRequest: control.pop()
        onCloseRightPanelRequest: control.clear()
    }

    Component {
        id: defaultHeaderComponent

        DapRightPanelTextHeader {
            caption: stackView.currentItem ? stackView.currentItem.caption : ""
        }
    }
}
