import QtQuick 2.9
import QtQuick.Controls 2.9
import QtQuick.Layouts 1.9
import QtGraphicalEffects 1.9

Popup {
    id: control

    property QtObject networkDelegateItem

    property point networkDelegateItemCoords: networkDelegateItem ? parent.mapFromItem(networkDelegateItem.parent, networkDelegateItem.x, networkDelegateItem.y) : Qt.point(0, 0)
    property int networkDelegateItemWidth: networkDelegateItem ? networkDelegateItem.width : 0
    property int networkDelegateItemHeight: networkDelegateItem ? networkDelegateItem.height : 0

    property string name: networkDelegateItem ? networkDelegateItem.name : ""
    property string state: networkDelegateItem ? networkDelegateItem.state : ""
    property string targetState: networkDelegateItem ? networkDelegateItem.targetState : ""
    property int activeLinksCount: networkDelegateItem ? networkDelegateItem.activeLinksCount : 0
    property int linksCount: networkDelegateItem ? networkDelegateItem.linksCount : 0
    property string nodeAddress: networkDelegateItem ? networkDelegateItem.nodeAddress : ""

    x: networkDelegateItemCoords.x
    y: networkDelegateItemCoords.y + networkDelegateItemHeight - height
    width: networkDelegateItemWidth
    height: contentHeight

    parent: Overlay.overlay
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

        property font font1: Qt.font({
                                         family: quicksandFonts.medium12,
                                         pixelSize: 12 * quicksandFonts.dapFactor,
                                         bold: true
                                     })
        property font font2: Qt.font({
                                         family: quicksandFonts.medium12,
                                         pixelSize: 12 * quicksandFonts.dapFactor
                                     })

        implicitWidth: columnItem.width
        implicitHeight: columnItem.height

        MouseArea {
            id: contentItemMouseArea

            width: parent.width
            height: parent.height
            hoverEnabled: true
        }

        Column {
            id: columnItem

            topPadding: 20 * pt
            spacing: Math.floor(control.networkDelegateItemHeight / 2)

            ColumnLayout {
                width: contentItem.width

                RowLayout {
                    Text {
                        font: contentItem.font1
                        color: "#070023"
                        text: qsTr("State: ")
                    }
                    Text {
                        font: contentItem.font2
                        color: "#070023"
                        elide: Text.ElideRight
                        text: control.state
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }

                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Text {
                        font: contentItem.font1
                        color: "#070023"
                        text: qsTr("Target state: ")
                    }
                    Text {
                        font: contentItem.font2
                        color: "#070023"
                        elide: Text.ElideRight
                        text: control.targetState
                        Layout.fillWidth: true
                        Layout.maximumWidth: Math.ceil(implicitWidth)
                    }

                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Text {
                        font: contentItem.font1
                        color: "#070023"
                        text: qsTr("Active links: ")
                    }
                    Text {
                        font: contentItem.font2
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
                        font: contentItem.font1
                        color: "#070023"
                        text: qsTr("Address: ")
                    }
                    Text {
                        font: contentItem.font2
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

    Timer {
        running: !contentItemMouseArea.containsMouse && !btnCopyAddressMouseArea.containsMouse && control.visible
        interval: 100
        repeat: false
        onTriggered: control.close()
    }
}
