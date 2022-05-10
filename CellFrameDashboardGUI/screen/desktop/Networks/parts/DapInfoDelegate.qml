import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "../../controls"

Popup {
    property alias imgStatus: nameStatus
    property bool isOpen: false
    property real startY: 0
    property real stopY: 0

    id: popupItem

    closePolicy: Popup.NoAutoClose
    padding: 0

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
            fast: true
            cached: true
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
    onOpenedChanged:
    {
        if(opened){
            buttonSync.enabled = true
            buttonNetwork.enabled = true
        }else{
            buttonSync.enabled = false
            buttonNetwork.enabled = false
        }
    }

    enter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
                NumberAnimation { property: "y"; from: startY; to: stopY; duration: 200 }
            }
    exit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
                NumberAnimation { property: "y"; from: stopY; to: startY; duration: 200 }
            }

    contentItem:
        ColumnLayout
        {
            spacing: 0

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        isOpen = false
                        popupItem.close()
                    }
                }

                //Buttons
                RowLayout {
                    id:buttonsLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 24
                    spacing: 1

                    DapInfoButton {
                        id: buttonSync
                        enabled: false
                        Layout.fillWidth: true
                        Layout.fillHeight: true
//                        height: 24
                        isSynch: true
                        onClicked: dapServiceController.requestToService("DapNetworkSingleSyncCommand", name)
                    }

                    DapInfoButton {
                        id: buttonNetwork
                        enabled: false
                        Layout.fillWidth: true
                        Layout.fillHeight: true
//                        height: 24
                        Component.onCompleted: setText()
                        onClicked: {
                            if (targetState !== "ONLINE" && networkState !== "ONLINE" )
                                dapServiceController.requestToService("DapNetworkGoToCommand", name, true)
                            else
                                dapServiceController.requestToService("DapNetworkGoToCommand", name, false)
                        }

                        function setText()
                        {
                            if (targetState !== "ONLINE" && networkState !== "ONLINE" )
                                buttonNetwork.textBut = qsTr("On network")
                            else
                                buttonNetwork.textBut = qsTr("Off network")

//                            console.log(targetState, networkState )
                        }
                    }
                }
                ///-------

                ColumnLayout
                {
                    anchors.top: buttonsLayout.bottom
                    anchors.topMargin: 12
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    spacing: 8 * pt

                    DapRowInfoText
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
                        Layout.preferredHeight: 15 * pt

                        staticText.text: "State: "
                        dynamicText.text: networkState
                        onTextChangedSign: buttonNetwork.setText()
                    }

                    Text {
                        id:errorMsg
                        Layout.alignment: Qt.AlignHCenter
//                        Layout.preferredWidth: item_width/2
                        Layout.fillWidth: true
                        Layout.leftMargin: 40
                        Layout.rightMargin: 40
                        Layout.preferredHeight: 15 * pt
                        visible: errorMessage === "" || errorMessage === " "  ? false : true

                        text: errorMessage
                        font: mainFont.dapFont.medium12
                        color: "#FF0000"
                        elide: Text.ElideMiddle
                        horizontalAlignment: Qt.AlignHCenter
                    }

                    DapRowInfoText
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
                        Layout.preferredHeight: 15 * pt

                        staticText.text: "Target state: "
                        dynamicText.text: targetState
                        onTextChangedSign: buttonNetwork.setText()
                    }

                    DapRowInfoText
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
                        Layout.preferredHeight: 15 * pt

                        staticText.text: "Active links: "
                        dynamicText.text: activeLinksCount + " from " + linksCount
                    }

                    DapRowInfoText
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: staticText.implicitWidth + dynamicText.implicitWidth
                        Layout.preferredHeight: 15 * pt

                        staticText.text: "Address: "
                        dynamicText.text: nodeAddress + " "

                        CopyButton
                        {
                            id: networkAddrCopyButton
                            onCopyClicked: copyStringToClipboard()
                            anchors.left: parent.dynamicText.right
                            anchors.verticalCenter: parent.verticalCenter

                            function copyStringToClipboard()
                            {
                                textEdit.text = nodeAddress
                                textEdit.selectAll()
                                textEdit.copy()
                            }
                        }

                        TextEdit {
                            id: textEdit
                            visible: false
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        Layout.fillWidth: false
                        Layout.alignment: Qt.AlignHCenter

                        height: 15 * pt
                        spacing: 5 * pt
                        width: nameText.width + nameStatus.width + spacing

                        Text {
                            id: nameText
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            Layout.maximumWidth: item_width/2
                            font: mainFont.dapFont.medium12
                            color: currTheme.textColor
                            text: name
                            elide: Text.ElideMiddle
                        }

                        Image {
                            id: nameStatus
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredHeight: 8 * pt
                            Layout.preferredWidth: 8 * pt
                            width: 8 * pt
                            height: 8 * pt
                            mipmap: true

                            source: networkState === "ONLINE" ? "qrc:/resources/icons/" + pathTheme + "/indicator_online.png" :
                                    networkState === "ERROR" ?   "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                                 "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png"

                            opacity: networkState !== targetState? animationController.opacity : 1
                        }
                    }
                    Item {
                        height: 5
                    }
                }
            }
        }
}
