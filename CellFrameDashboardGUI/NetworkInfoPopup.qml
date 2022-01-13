import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0

Popup {
    id: networkInfoPupup
    y: networksPanel.y-height
    width: 300
    height: 150
    padding: 1
    focus: true
    closePolicy: Popup.NoAutoClose
    visible: false

    property variant networkName
    property variant networkState
    property variant error
    property variant targetState
    property variant linksCount
    property variant activeLinksCount
    property variant nodeAddress
    property variant isOpen

    background: Rectangle {
        color: currTheme.shadowColor
        border.color: "grey"
    }

    RowLayout {
        spacing: 0
        Button {
            id: buttonSync
            Layout.preferredWidth: parent.parent.width / 2

            Image {
                fillMode: Image.PreserveAspectFit
                anchors.left: parent.left
                sourceSize.width: parent.height * pt
                sourceSize.height: parent.height * pt
                source: "qrc:/resources/icons/Icon_sync_net_hover.svg"
            }

            contentItem: Text {
                text: "Sync Network"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: buttonSync.hovered ? "#D51F5D" : currTheme.shadowColor
                border.width: 1
                border.color: "grey"
            }

            onClicked:
            {
                dapServiceController.requestToService("DapNetworkSingleSyncCommand", networkName)
                isOpen = false
                networkInfoPupup.close()
            }
        }

        Button {
            id: buttonOn
            Layout.preferredWidth: parent.parent.width / 2

            Image
            {
                fillMode: Image.PreserveAspectFit
                anchors.left: parent.left
                sourceSize.width: parent.height * pt
                sourceSize.height: parent.height * pt
                source: "qrc:/resources/icons/icon_on_off_net_hover.svg"
            }

            contentItem: Text {
                text: "On network"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: buttonOn.hovered ? "#D51F5D" : currTheme.shadowColor
                border.width: 1
                border.color: "grey"
            }

            onClicked:
            {
                if (targetState === "ONLINE")
                    dapServiceController.requestToService("DapNetworkGoToCommand", networkName, false)
                else
                    dapServiceController.requestToService("DapNetworkGoToCommand", networkName, true)
                isOpen = false
                networkInfoPupup.close()
            }
        }
    }

    Text {
        id: popupContent
        anchors.centerIn: parent

        text:   '<font color="white"><b>State: </b>' + networkState + '<br />' +
                '<font color="red">' + error + '</font><br />' +
                '<b>Target state: </b>' + targetState + '<br />' +
                '<b>Active links: </b>' + linksCount + ' from ' + activeLinksCount + '<br />' +
                '<b>Address: </b>' + nodeAddress + '</font>'
    }

    MouseArea
    {
        id: networkAddrCopyButton
        anchors.verticalCenter: popupContent.verticalCenter
        anchors.verticalCenterOffset: 30
        anchors.right: parent.right
        anchors.rightMargin: 16 * pt
        width: 16 * pt
        height: 16 * pt
        hoverEnabled: true

        onClicked: copyStringToClipboard()

        Image
        {
            id: networkAddrCopyButtonImage
            anchors.fill: parent
            source: parent.containsMouse ? "qrc:/resources/icons/ic_copy_hover.png" : "qrc:/resources/icons/ic_copy.png"

            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
    }
    TextEdit{
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

    function copyStringToClipboard()
    {
        textEdit.text = nodeAddress
        textEdit.selectAll()
        textEdit.copy()
    }
}
