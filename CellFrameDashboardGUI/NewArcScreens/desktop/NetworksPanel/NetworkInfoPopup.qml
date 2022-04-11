import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "qrc:/"
import "../../"

Popup {
    id: networkInfoPupup

    height: 190
    padding: 0
    focus: true
    closePolicy: Popup.NoAutoClose

    property int parentWidth
    property bool isOpen : false
    property int curWidth : 295
    property alias imgStatus:nameStatus

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

    RowLayout {
        id:buttonsLayout
        spacing: 1

        Item {
            Layout.preferredWidth: 147
            Layout.preferredHeight: 24

            DapNetworkButton {
                id: buttonSync
                anchors.fill: parent
                isSynch: true
                hoverEnabled: true

                onClicked: {
                    dapServiceController.requestToService("DapNetworkSingleSyncCommand", name)
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
                fast: true
                cached: true
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
        }
        Item {
            Layout.preferredWidth: 147
            Layout.preferredHeight: 24

            DapNetworkButton {
                id: buttonNetwork
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    if (targetState === "ONLINE") {
                        dapServiceController.requestToService("DapNetworkGoToCommand", name, false)
                    }
                    else {
                        dapServiceController.requestToService("DapNetworkGoToCommand", name, true)
                    }
                }
                Component.onCompleted:
                {
                    setText()
                }

                function setText()
                {
                    if (networkState === "OFFLINE") {
                        buttonNetwork.textBut = qsTr("On network")
                    }

                    else {
                        buttonNetwork.textBut = qsTr("Off network")
                    }
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
                fast: true
                cached: true
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
    }

    ColumnLayout
    {
        anchors.top: buttonsLayout.bottom
        width: parent.width
        spacing: 8 * pt

        //network state
        Item
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 12 * pt
            Layout.preferredWidth: stateNetwork.implicitWidth + textState.implicitWidth
            Layout.preferredHeight: 15 * pt

            Text {
                id: stateNetwork
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold12
                text: "State: "
                color: currTheme.textColor
            }
            Text {
                id:textState
                anchors.left: stateNetwork.right
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.regular12
                text: networkState
                color: currTheme.textColor
                onTextChanged:
                {
                    buttonNetwork.setText()
                }
            }
        }

        //error
        Item
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: errorNetwork.implicitWidth
            Layout.preferredHeight: 15 * pt
            visible: errorNetwork.text === "" ? false : true

            Text {
                id: errorNetwork
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold12
                text: errorMessage
                color: "#FF0000"
            }
        }

        //target state
        Item
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: targetStateCaption.implicitWidth + targetStateText.implicitWidth
            Layout.preferredHeight: 15 * pt

            Text {
                id: targetStateCaption
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold12
                text: "Target state: "
                color: currTheme.textColor
            }
            Text {
                id: targetStateText
                anchors.left: targetStateCaption.right
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.regular12
                text: targetState
                color: currTheme.textColor
            }
        }

        //links
        Item
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: activeLinksCaption.implicitWidth + activeLinksText.implicitWidth
            Layout.preferredHeight: 15 * pt

            Text {
                id: activeLinksCaption
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold12
                text: "Active links: "
                color: currTheme.textColor
            }
            Text {
                id: activeLinksText
                anchors.left: activeLinksCaption.right
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.regular12
                text: activeLinksCount + " from " + linksCount
                color: currTheme.textColor
            }
        }

        //address
        Item
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: addressCaption.implicitWidth + addressText.implicitWidth
            Layout.preferredHeight: 15 * pt

            Text {
                id: addressCaption
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.bold12
                text: "Address: "
                color: currTheme.textColor
            }
            Text {
                id: addressText
                anchors.left: addressCaption.right
                anchors.verticalCenter: parent.verticalCenter
                font: mainFont.dapFont.regular12
                text: nodeAddress + " "
                color: currTheme.textColor
            }
            MouseArea {
                id: networkAddrCopyButton
                anchors.left: addressText.right
                anchors.verticalCenter: parent.verticalCenter
                width: 16 * pt
                height: 16 * pt
                hoverEnabled: true

                onClicked: copyStringToClipboard()

                DapImageLoader {
                    id: networkAddrCopyButtonImage

                    innerWidth: parent.width
                    innerHeight: parent.height
                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                }
            }
            TextEdit {
                id: textEdit
                visible: false
            }
        }
    }

    RowLayout {
        x: (networkInfoPupup.width/2 - (nameText.width + nameStatus.width + spacing) /2)
        y: 162 * pt
        height: 15 * pt
        spacing: 5 * pt

        Text {
            id: nameText
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.maximumWidth: item_width/2
            font: mainFont.dapFont.bold12
            color: currTheme.textColor
            text: name
            elide: Text.ElideMiddle
        }

        DapImageLoader {
            id: nameStatus
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 8 * pt
            Layout.preferredWidth: 8 * pt
            innerWidth: 8 * pt
            innerHeight: 8 * pt

            source: networkState === "OFFLINE" ? "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png" :
                    networkState === "ERROR" ?   "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                 "qrc:/resources/icons/" + pathTheme + "/indicator_online.png"
        }
    }

    function copyStringToClipboard()
    {
        textEdit.text = nodeAddress
        textEdit.selectAll()
        textEdit.copy()
    }
}
