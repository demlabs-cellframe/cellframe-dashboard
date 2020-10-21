import QtQml 2.2
import QtQuick 2.7

Item {
    id: control

    property bool hasLeft: listView.leftIndex - 1 >= 0
    property bool hasRight: listView.leftIndex + listView.visibleItems < listView.count

    function scrollToLeft()
    {
        if (hasLeft) {
            listView.positionViewAtIndexAnimation(listView.leftIndex - 1, ListView.Beginning);
            listView.leftIndex--;
        }
    }

    function scrollToRight()
    {
        if (hasRight) {
            listView.positionViewAtIndexAnimation(listView.leftIndex + listView.visibleItems, ListView.End);
            listView.leftIndex++;
        }
    }

    ListView {
        id: listView

        property int visibleItems: 0
        property int delegateWidth: Math.floor(control.width / 4)
        property int leftIndex: 0

        function positionViewAtIndexAnimation(index, mode)
        {
            scrollAnimation.running = false;
            var pos = listView.contentX;
            listView.positionViewAtIndex(index, mode);
            var dest = listView.contentX;

            scrollAnimation.from = pos;
            scrollAnimation.to = dest;
            scrollAnimation.running = true;
        }

        function setNetworks(networks)
        {
            model = networks;

            // for set position of elements if there are less than 4
            // [*][*][*][*] if 4+
            // [ ][*][*][*] if 3
            // [ ][*][*][ ] 2
            // [ ][ ][ ][*] 1
            var visibleItems = networks.length;
            if (visibleItems >= 4) {
                visibleItems = 4;
                listView.width = Qt.binding(function() { return control.width });
            } else if (visibleItems === 1 || visibleItems === 3) {
                listView.width = Qt.binding(function() { return control.width - listView.delegateWidth * (4 - visibleItems) });
            } else if (visibleItems === 2) {
                listView.width = Qt.binding(function() { return control.width - listView.delegateWidth });
            }
            listView.visibleItems = visibleItems;

            listView.leftIndex = 0;
        }

        anchors.right: parent.right
        height: parent.height
        orientation: Qt.Horizontal
        clip: true
        interactive: false

        delegate: Rectangle {
            id: delegateItem

            // properties duplicated for DapNetworkPopup
            property string name: modelData.name
            property string networkState: modelData.state
            property string networkTargetState: modelData.targetState
            property int activeLinksCount: modelData.activeLinksCount
            property int linksCount: modelData.linksCount
            property string nodeAddress: modelData.nodeAddress

            width: listView.delegateWidth
            height: listView.height
            color: "#070023"

            DapNetworkName {
                width: parent.width
                height: parent.height
                textColor: "#FFFFFF"
                name: delegateItem.name
                networkState: delegateItem.networkState
            }

            MouseArea {
                id: delegateMouseArea

                width: parent.width
                height: parent.height

                onClicked: {
                    if (index >= listView.leftIndex && index < listView.leftIndex + listView.visibleItems) {
                        networkPanelPopup.show(delegateItem);
                    }
                }
            }
        }

        onDelegateWidthChanged: {
            if (listView.leftIndex >= 0 && listView.leftIndex < listView.count) {
                listView.positionViewAtIndex(listView.leftIndex, ListView.Beginning);
            }
        }

        NumberAnimation {
            id: scrollAnimation
            target: listView
            property: "contentX"
            duration: 100
        }
    }

    Connections {
        target: networks
        onListCompositionChanged: listView.setNetworks(networks.model())
    }
}
