import QtQuick 2.9

ListView {
    id: control

    property bool hasLeft: d.leftIndex - 1 >= 0
    property bool hasRight: d.leftIndex + d.visibleItems < control.count

    function scrollToLeft()
    {
        if (hasLeft) {
            d.positionViewAtIndexAnimation(d.leftIndex - 1, ListView.Beginning);
            d.leftIndex--;
        }
    }

    function scrollToRight()
    {
        if (hasRight) {
            d.positionViewAtIndexAnimation(d.leftIndex + d.visibleItems, ListView.End);
            d.leftIndex++;
        }
    }

    orientation: Qt.Horizontal
    clip: true
    interactive: false

    // TODO код только для теста, удалить потом
    Component {
        id: component

        Item {
            property var i
            property var name: "Network #" + i
            property var state: i % 2 === 0 ? "Online" : "Offline"
            property var targetState: "targetState"
            property var activeLinksCount: i
            property var linksCount: i * 2
            property var nodeAddress: "nodeAddress_" + (i + 1)

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: {
                    parent.state = parent.state === "Online" ? "Offline" : "Online";
                    ++parent.activeLinksCount;
                    ++parent.linksCount;
                    if (parent.linksCount > 10) {
                        parent.linksCount = 2;
                        parent.activeLinksCount = 1;
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        var array = [];
        for (var i = 0; i < 5; ++i) {
            var obj = component.createObject();
            obj.i = i;
            array.push(obj);
        }
        model = array;
    }

    delegate: Rectangle {
        id: delegateItem

        // properties duplicated for DapNetworkPopup
        property string name: modelData.name
        property string state: modelData.state
        property string targetState: modelData.targetState
        property int activeLinksCount: modelData.activeLinksCount
        property int linksCount: modelData.linksCount
        property string nodeAddress: modelData.nodeAddress

        width: d.delegateWidth
        height: control.height
        color: "#070023"

        DapNetworkName {
            width: parent.width
            height: parent.height
            textColor: "#FFFFFF"
            name: delegateItem.name
            state: delegateItem.state
        }

        MouseArea {
            id: delegateMouseArea

            width: parent.width
            height: parent.height
            hoverEnabled: true

            onEntered: {
                if (index >= d.leftIndex && index < d.leftIndex + d.visibleItems) {
                    networkPopup.networkDelegateItem = delegateItem;
                    networkPopup.open();
                }
            }
        }
    }

    onCountChanged: timerUpdateDelegateWidth.start()
    onWidthChanged: timerUpdateDelegateWidth.start()

    DapNetworkPopup {
        id: networkPopup
    }

    Item {
        id: d

        property int delegateWidth: 100
        property int visibleItems: 1
        property int leftIndex: 0

        function positionViewAtIndexAnimation(index, mode)
        {
            scrollAnimation.running = false;
            var pos = control.contentX;
            control.positionViewAtIndex(index, mode);
            var dest = control.contentX;

            scrollAnimation.from = pos;
            scrollAnimation.to = dest;
            scrollAnimation.running = true;
        }

        Timer {
            id: timerUpdateDelegateWidth

            repeat: false
            interval: 0

            onTriggered: {
                var w = Math.max(control.width / control.count, 295 * pt);
                var visibleItems = Math.max(Math.floor(control.width / w), 1);
                var delegateWidth = Math.floor((control.width - w * visibleItems) / visibleItems + w);
                d.visibleItems = visibleItems;

                if (d.delegateWidth !== delegateWidth) {
                    d.delegateWidth = delegateWidth;

                    if (d.leftIndex > control.count - d.visibleItems)
                        d.leftIndex = control.count - d.visibleItems;
                    if (d.leftIndex < 0)
                        d.leftIndex = 0;
                    if (d.leftIndex < control.count)
                        control.positionViewAtIndex(d.leftIndex, ListView.Beginning);
                }
            }
        }
    }

    NumberAnimation {
        id: scrollAnimation
        target: control
        property: "contentX"
        duration: 100
    }
}
