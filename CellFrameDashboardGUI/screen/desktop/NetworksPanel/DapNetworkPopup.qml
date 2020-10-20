import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Popup {
    id: control

    property point networkDelegateItemCoords
    property int networkDelegateItemWidth
    property int networkDelegateItemHeight

    property string name
    property string state
    property string targetState
    property int activeLinksCount
    property int linksCount
    property string nodeAddress

    function show(networkDelegateItem)
    {
        networkDelegateItemCoords = Qt.binding(function() { return parent.mapFromItem(networkDelegateItem.parent, networkDelegateItem.x, networkDelegateItem.y) });
        networkDelegateItemWidth = Qt.binding(function() { return networkDelegateItem.width });
        networkDelegateItemHeight = Qt.binding(function() { return networkDelegateItem.height });

        name = Qt.binding(function() { return networkDelegateItem.name });
        state = Qt.binding(function() { return networkDelegateItem.state });
        targetState = Qt.binding(function() { return networkDelegateItem.targetState });
        activeLinksCount = Qt.binding(function() { return networkDelegateItem.activeLinksCount });
        linksCount = Qt.binding(function() { return networkDelegateItem.linksCount });
        nodeAddress = Qt.binding(function() { return networkDelegateItem.nodeAddress });

        open();
    }

    function release()
    {
        networkDelegateItemCoords = Qt.point(0, 0);
        networkDelegateItemWidth = 0;
        networkDelegateItemHeight = 0;

        name = "";
        state = "";
        targetState = "";
        activeLinksCount = 0;
        linksCount = 0;
        nodeAddress = 0;
    }

    x: networkDelegateItemCoords.x
    y: networkDelegateItemCoords.y + networkDelegateItemHeight - height
    width: networkDelegateItemWidth
    height: contentHeight

    margins: 0
    padding: 0

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 100 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }

    contentItem: Item {
        id: contentItem

        function networkStateToString(state)
        {
            switch (state) {
            case "NET_STATE_ONLINE":
                return qsTr("ONLINE");
            case "NET_STATE_OFFLINE":
                return qsTr("OFFLINE");
            default:
                if (state.length > 0)
                    console.warn("Unknown network state: " + state);
                return "";
            }
        }

        implicitWidth: columnItem.width
        implicitHeight: columnItem.height

        Column {
            id: columnItem

            spacing: Math.floor(control.networkDelegateItemHeight / 2)

            Row {
                DapNetworkPopupButton {
                    width: contentItem.width / 2
                    height: 24 * pt
                    enabled: control.state == "NET_STATE_ONLINE" && control.targetState == "NET_STATE_ONLINE"
                    text: qsTr("Sync network")
                }
                DapNetworkPopupButton {
                    width: contentItem.width / 2
                    height: 24 * pt
                    text: control.state == "NET_STATE_OFFLINE" ? qsTr("On network") : qsTr("Off network")
                }
            }

            ColumnLayout {
                width: contentItem.width

                RowLayout {
                    Text {
                        font: quicksandFonts.medium12
                        color: "#070023"
                        text: qsTr("State: ")
                    }
                    Text {
                        font: quicksandFonts.regular12
                        color: "#070023"
                        elide: Text.ElideRight
                        text: contentItem.networkStateToString(control.state)
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }

                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Text {
                        font: quicksandFonts.medium12
                        color: "#070023"
                        text: qsTr("Target state: ")
                    }
                    Text {
                        font: quicksandFonts.regular12
                        color: "#070023"
                        elide: Text.ElideRight
                        text: contentItem.networkStateToString(control.targetState)
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }

                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Text {
                        font: quicksandFonts.medium12
                        color: "#070023"
                        text: qsTr("Active links: ")
                    }
                    Text {
                        font: quicksandFonts.regular12
                        color: "#070023"
                        elide: Text.ElideRight
                        text: control.activeLinksCount + qsTr(" from ") + control.linksCount
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }

                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Text {
                        id: textAddress
                        font: quicksandFonts.medium12
                        color: "#070023"
                        text: qsTr("Address: ")
                    }
                    Text {
                        font: quicksandFonts.regular12
                        color: "#070023"
                        elide: Text.ElideRight
                        text: control.nodeAddress
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }
                    Image {
                        source: btnCopyAddressMouseArea.containsMouse ? "qrc:/resources/icons/ic_copy_hover.png" : "qrc:/resources/icons/ic_copy.png"

                        Layout.maximumWidth: Math.floor(textAddress.height * 1.1)
                        Layout.maximumHeight: Layout.maximumWidth

                        MouseArea {
                            id: btnCopyAddressMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: app.setClipboardText(control.nodeAddress)
                        }
                    }

                    Layout.alignment: Qt.AlignHCenter
                }
            }

            DapNetworkName {
                id: networkName

                y: parent.height - height
                width: control.networkDelegateItemWidth
                height: control.networkDelegateItemHeight
                textColor: "#070023"
                name: control.name
                state: control.state
            }
        }
    }

    background: Item {
        Rectangle {
            id: r1
            width: parent.width
            height: parent.height
            visible: true
            color: "#FFFFFF"
        }

        DropShadow {
            anchors.fill: r1
            opacity: control.opacity === 1.0 ? 1.0 : control.opacity / 4
            source: r1
            radius: 5
            samples: 11
            color: "#80000000"
        }
    }

    onClosed: release()
}
