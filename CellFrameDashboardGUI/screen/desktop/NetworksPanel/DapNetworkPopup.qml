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
    property string networkState
    property string networkTargetState
    property int activeLinksCount
    property int linksCount
    property string nodeAddress

    function show(networkDelegateItem)
    {
        networkDelegateItemCoords = Qt.binding(function() { return parent.mapFromItem(networkDelegateItem.parent, networkDelegateItem.x, networkDelegateItem.y) });
        networkDelegateItemWidth = Qt.binding(function() { return networkDelegateItem.width });
        networkDelegateItemHeight = Qt.binding(function() { return networkDelegateItem.height });

        name = Qt.binding(function() { return networkDelegateItem.name });
        networkState = Qt.binding(function() { return networkDelegateItem.networkState });
        networkTargetState = Qt.binding(function() { return networkDelegateItem.networkTargetState });
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
        networkState = "";
        networkTargetState = "";
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

        function networkStateToString(networkState)
        {
            switch (networkState) {
            case "NET_STATE_ONLINE":
                return qsTr("ONLINE");
            case "NET_STATE_OFFLINE":
                return qsTr("OFFLINE");
            default:
                if (state.length > 0)
                    console.warn("Unknown network state: " + networkState);
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
                    text: qsTr("Sync network")
                    iconNormal: "qrc:/resources/icons/Icon_sync_net.svg"
                    iconHover: "qrc:/resources/icons/Icon_sync_net_hover.svg"

                    onClicked: console.log("SYNC NETWORK CLICKED", control.name)
                }
                DapNetworkPopupButton {
                    width: contentItem.width / 2
                    height: 24 * pt
                    text: control.networkState == "NET_STATE_ONLINE" ? qsTr("Off network") : qsTr("On network")
                    iconNormal: "qrc:/resources/icons/icon_on_off_net.svg"
                    iconHover: "qrc:/resources/icons/icon_on_off_net_hover.svg"

                    onClicked: {
                        if (control.networkState == "NET_STATE_ONLINE") {
                            dapServiceController.changeNetworkStateToOffline(control.name);
                        } else if (control.networkState == "NET_STATE_OFFLINE") {
                            dapServiceController.changeNetworkStateToOnline(control.name);
                        } else {
                            console.warn("Unknown network state: " + control.networkState);
                        }
                    }
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
                        text: contentItem.networkStateToString(control.networkState)
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
                        text: contentItem.networkStateToString(control.networkTargetState)
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
                        source: btnCopyAddressMouseArea.containsMouse ? "qrc:/resources/icons/ic_copy_hover.svg" : "qrc:/resources/icons/ic_copy.svg"

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
                networkState: control.networkState
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
            opacity: control.opacity === 1.0 ? 1.0 : control.opacity / 5
            source: r1
            radius: 5
            samples: 11
            color: "#80000000"
        }
    }

    onClosed: release()
}
