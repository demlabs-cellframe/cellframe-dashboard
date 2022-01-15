import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Popup {
    id: networkInfoPupup
    y: networksPanel.height+networksPanel.y-height
    width: 295
    height: 190
    padding: 0
    focus: true
    closePolicy: Popup.NoAutoClose
    visible: false

    property variant networkName
    property variant networkState
    property variant stateColor
    property variant error
    property variant targetState
    property variant linksCount
    property variant activeLinksCount
    property variant nodeAddress
    property variant isOpen

    MouseArea {
        width: parent.width
        height: parent.height

        onClicked: {
            isOpen = false
            networkInfoPupup.close()
        }
    }

    background: Item {
        Rectangle {
            id: rPopup
            width: parent.width
            height: parent.height
            visible: true
            color: currTheme.backgroundPanel
        }

        DropShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.reflection
            horizontalOffset: -1
            verticalOffset: -1
            radius: 0
            samples: 0
            opacity: 1
        }
        DropShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.shadowColor
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 1
        }
    }

    RowLayout {
        spacing: 0
        Button {
            id: buttonSync
            anchors.left: parent.left
            Layout.preferredWidth: 147
            Layout.preferredHeight: 24

            Image {
                id: syncImg
                x: buttonSync.width / 2 - (syncImg.width + syncText.width) / 2
                height: parent.height * pt
                width: parent.height * pt
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/resources/icons/Icon_sync_net_hover.svg"
            }

            Text {
                id: syncText
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium15
                color: currTheme.textColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: syncImg.right
                text: "Sync Network"
            }

            background: Rectangle {
                color: buttonSync.hovered ? "#D51F5D" : currTheme.backgroundPanel
            }

            onClicked: {
                dapServiceController.requestToService("DapNetworkSingleSyncCommand", networkName)
                isOpen = false
                networkInfoPupup.close()
            }
        }

        DropShadow {
            anchors.fill: buttonSync
            source: buttonSync
            color: currTheme.reflection
            horizontalOffset: -1
            verticalOffset: -1
            radius: 0
            samples: 0
            opacity: 1
        }
        DropShadow {
            anchors.fill: buttonSync
            source: buttonSync
            color: currTheme.shadowColor
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 1
        }

        Button {
            id: buttonNetwork
            anchors.left: buttonSync.right
            Layout.preferredWidth: 147
            Layout.preferredHeight: 24

            Image  {
                id: networkImg
                x: buttonNetwork.width / 2 - (networkImg.width + networkText.width) / 2
                height: parent.height * pt
                width: parent.height * pt
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/resources/icons/icon_on_off_net_hover.svg"
            }

            Text {
                id: networkText
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium15
                color: currTheme.textColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: networkImg.right
                text: "On network"
            }

            background: Rectangle {
                color: buttonNetwork.hovered ? "#D51F5D" : currTheme.backgroundPanel
            }

            onClicked: {
                if (targetState === "ONLINE")
                    dapServiceController.requestToService("DapNetworkGoToCommand", networkName, false)
                else
                    dapServiceController.requestToService("DapNetworkGoToCommand", networkName, true)
                isOpen = false
                networkInfoPupup.close()
            }
        }

        DropShadow {
            anchors.fill: buttonNetwork
            source: buttonNetwork
            color: currTheme.reflection
            horizontalOffset: -1
            verticalOffset: -1
            radius: 0
            samples: 0
            opacity: 1
        }
        DropShadow {
            anchors.fill: buttonNetwork
            source: buttonNetwork
            color: currTheme.shadowColor
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 1
        }
    }

    Text {
        id: stateCaption
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
        y: 35
        x: networkInfoPupup.width/2 - (stateCaption.width + stateText.width)/2
        height: 15
        text: "State: "
        color: currTheme.textColor
    }
    Text {
        id: stateText
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
        y: 35
        height: 15
        anchors.left: stateCaption.right
        text: networkState
        color: currTheme.textColor
    }

    Text {
        id: targetStateCaption
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
        y: 58
        x: networkInfoPupup.width/2 - (targetStateCaption.width + targetStateText.width)/2
        height: 15
        text: "Target state: "
        color: currTheme.textColor
    }
    Text {
        id: targetStateText
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
        y: 58
        height: 15
        anchors.left: targetStateCaption.right
        text: targetState
        color: currTheme.textColor
    }

    Text {
        id: activeLinksCaption
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
        y: 81
        x: networkInfoPupup.width/2 - (activeLinksCaption.width + activeLinksText.width)/2
        height: 15
        text: "Active links: "
        color: currTheme.textColor
    }
    Text {
        id: activeLinksText
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
        y: 81
        height: 15
        anchors.left: activeLinksCaption.right
        text: activeLinksCount + " from " + linksCount
        color: currTheme.textColor
    }

    Text {
        id: addressCaption
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
        y: 104
        x: networkInfoPupup.width/2 - (addressCaption.width + addressText.width + networkAddrCopyButton.width)/2
        height: 15
        text: "Address: "
        color: currTheme.textColor
    }
    Text {
        id: addressText
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
        y: 104
        height: 15
        anchors.left: addressCaption.right
        text: nodeAddress + " "
        color: currTheme.textColor
    }
    MouseArea {
        id: networkAddrCopyButton
        anchors.verticalCenter: addressText.verticalCenter
        anchors.left: addressText.right
        width: 16 * pt
        height: 16 * pt
        hoverEnabled: true

        onClicked: copyStringToClipboard()

        Image {
            id: networkAddrCopyButtonImage
            anchors.fill: parent
            source: parent.containsMouse ? "qrc:/resources/icons/ic_copy_hover.png" : "qrc:/resources/icons/ic_copy.png"

            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
    }
    TextEdit {
        id: textEdit
        visible: false
    }
    Shortcut {
        sequence: StandardKey.Copy
        onActivated: {
            textEdit.text = nodeAddress
            textEdit.selectAll()
            textEdit.copy()
        }
    }

    Text {
        id: nameText
        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
        y: 162
        x: networkInfoPupup.width/2 - (nameText.width + nameStatus.width)/2
        height: 15
        text: networkName + "  "
        color: currTheme.textColor
    }

    Rectangle {
        id: nameStatus
        width: 8
        height: 8
        y: 162
        anchors.verticalCenter: nameText.verticalCenter
        anchors.left: nameText.right
        radius: width/2
        color: stateColor
    }

    function copyStringToClipboard()
    {
        textEdit.text = nodeAddress
        textEdit.selectAll()
        textEdit.copy()
    }
}
