import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"
import "../controls"

Item {
    id: deleagte
    width: ListView.view.width
    height: 117

    QMLClipboard{
        id: clipboard
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 13

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            DapImageRender {
                source: networkState === "NET_STATE_ONLINE"  ?  "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/indicator_online.png" :
                        networkState === "NET_STATE_OFFLINE" ?  "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/indicator_error.png":
                                                      "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/indicator_offline.png"
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                Layout.leftMargin: 12
                Layout.fillWidth: true
                text: networkName
                font: mainFont.dapFont.regular16
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }

            DapButton
            {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignHCenter
                defaultColor: currTheme.secondaryBackground
                defaultColorNormal0: currTheme.secondaryBackground
                defaultColorNormal1: currTheme.secondaryBackground
                shadowColor: currTheme.shadowMain
                innerShadowColor : currTheme.reflection
                opacityDropShadow: 0.44
                opacityInnerShadow: 0.3

                DapImageRender{
                    anchors.centerIn: parent
                    source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/sync.svg"
                }

                onClicked: logicMainApp.requestToService("DapNetworkSingleSyncCommand", networkName)

                DapCustomToolTip{
                    contentText: qsTr("Click to synchronize the network")
                    visible: parent.hovered
                    backgroundToolTip.color: currTheme.lime
                    textColor: currTheme.mainBackground
                    bottomRect.visible: false
                }
            }

            DapButton
            {
                Layout.leftMargin: 16
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignHCenter
                defaultColor: currTheme.secondaryBackground
                defaultColorNormal0: currTheme.secondaryBackground
                defaultColorNormal1: currTheme.secondaryBackground
                shadowColor: currTheme.shadowMain
                innerShadowColor : currTheme.reflection
                opacityDropShadow: 0.44
                opacityInnerShadow: 0.3
                DapImageRender{
                    anchors.centerIn: parent
                    source: networkState === "NET_STATE_OFFLINE" ? "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_on.svg"
                                                       : "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_off.svg"
                }

                onClicked: {
                    if (targetState !== "NET_STATE_ONLINE" && networkState !== "NET_STATE_ONLINE" && targetState === "NET_STATE_OFFLINE" )
                        logicMainApp.requestToService("DapNetworkGoToCommand", networkName, true)
                    else
                        logicMainApp.requestToService("DapNetworkGoToCommand", networkName, false)
                }

                DapCustomToolTip{
                    contentText: networkState === "NET_STATE_OFFLINE" ? qsTr("Click to turn on the network")
                                                            : qsTr("Click to turn off the network")
                    visible: parent.hovered
                    backgroundToolTip.color: currTheme.lime
                    textColor: currTheme.mainBackground
                    bottomRect.visible: false
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: qsTr("State:")
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }

            Text {
                Layout.fillWidth: true
                font: mainFont.dapFont.regular12
                text: networkState
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: qsTr("Target state:")
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }

            Text {
                Layout.fillWidth: true
                text: targetState
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: qsTr("Active links:")
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }

            Text {
                Layout.fillWidth: true
                text: activeLinksCount + qsTr(" from ") + linksCount
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20

            Text {
                text: qsTr("Address:")
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
            }

            Text {
                text: address
                Layout.fillWidth: true
                font: mainFont.dapFont.regular12
                Layout.alignment: Qt.AlignHCenter
                color: currTheme.white
                elide: Text.ElideMiddle
            }

            CopyButton
            {
                id: networkAddressCopyButton
                Layout.alignment: Qt.AlignRight
                popupText: qsTr("Address copied")
                onCopyClicked:
                    clipboard.setText(address)
            }
        }
    }
}
