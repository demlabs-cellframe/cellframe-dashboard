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
    model: ListModel { }
    Component.onCompleted: {
        for (var i = 0; i < 5; ++i) {
            model.append({
                             name: "Network #" + i,
                             state: i % 2 === 0 ? "Online" : "Offline",
                             targetState: "targetState",
                             activeLinksCount: i,
                             linksCount: i * 2,
                             nodeAddress: "nodeAddress_" + (i + 1)
                         });
        }
    }

    delegate: Rectangle {
        id: delegateItem

        // properties duplicated for DapNetworkPopup
        property string name: model.name
        property string state: model.state
        property string targetState: model.targetState
        property int activeLinksCount: model.activeLinksCount
        property int linksCount: model.linksCount
        property string nodeAddress: model.nodeAddress

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

    DapNetworkPopup {
        id: networkPopup
    }

    Item {
        id: d

        property int delegateWidth: {
            var w = Math.max(control.width / control.count, 295 * pt);
            var visibleItems = Math.max(Math.floor(control.width / w), 1);
            d.visibleItems = visibleItems;
            return Math.floor((control.width - w * visibleItems) / visibleItems + w);
        }

        property int visibleItems: 0
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

        onDelegateWidthChanged: {
            if (d.leftIndex > control.count - d.visibleItems)
                d.leftIndex = control.count - d.visibleItems;
            if (d.leftIndex < 0)
                d.leftIndex = 0;
            if (d.leftIndex < control.count)
                control.positionViewAtIndex(d.leftIndex, ListView.Beginning);
        }
    }

    NumberAnimation {
        id: scrollAnimation
        target: control
        property: "contentX"
        duration: 100
    }
}
