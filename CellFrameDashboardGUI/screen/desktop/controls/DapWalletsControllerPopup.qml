import QtQuick 2.9
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import "qrc:/widgets"

Item{

    Rectangle {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity
        color: currTheme.popup
        opacity: 0.0

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: hide()
        }

        Behavior on opacity {NumberAnimation{duration: 100}}
    }

    Rectangle{
        id: walletsFrame
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}

        width: 328
        height: dapModelWallets.count > 4 ? 401 : 97 + dapModelWallets.count * 61
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea{
            anchors.fill: parent
        }

        HeaderButtonForRightPanels{
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 9
            anchors.rightMargin: 10
            height: 20
            width: 20
            heightImage: 20
            widthImage: 20
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
            onClicked: hide()
        }

        ColumnLayout{
            anchors.fill: parent
            anchors.bottomMargin: 16
            spacing: 0

            Item {
                Layout.fillWidth: true
                height: 66

                Text{
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Wallets list")
                    font: mainFont.dapFont.bold14
                    color: currTheme.white
                }
            }

            Rectangle
            {
                id: section
                color: currTheme.mainBackground
                Layout.fillWidth: true
                height: 29

                Text
                {
                    color: currTheme.white
                    text: qsTr("Wallets")
                    font: mainFont.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                }
            }

            ListView {
                id: walletsList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical: ScrollBar { active: true }
                model: dapModelWallets

                delegate:
                    Item {
                    height: 61
                    width: walletsList.width

                    RowLayout {
                        width: parent.width
                        height: 60

                        Item {
                            width: 224
                            Layout.leftMargin: 24
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignLeft

                            DapBigText {
                                id: walletName
                                fullText: dapModelWallets.get(index) !== undefined ? dapModelWallets.get(index).name : ""
                                textFont: mainFont.dapFont.regular14
                                textColor: "white"
                                anchors.fill: parent
                                verticalAlign: Text.AlignVCenter
                                horizontalAlign: Text.AlignLeft
                            }
                        }

                        Rectangle {
                            id: removeIcon
                            Layout.leftMargin: 24
                            Layout.rightMargin: 24
                            Layout.alignment: Qt.AlignRight
                            width: 32
                            height: 32
                            radius: 4
                            color: area.containsMouse ? currTheme.rowHover : currTheme.mainBackground

                            Image{
                                anchors.centerIn: parent
                                source: "qrc:/Resources/BlackTheme/icons/other/remove_wallet.svg"
                                mipmap: true
                            }

                            MouseArea{
                                id: area
                                hoverEnabled: true
                                anchors.fill: parent

                                onClicked: {
                                    walletsFrame.opacity = 0.0
                                    removeWalletPopup.show(walletName.fullText)
                                }
                            }
                        }  
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: currTheme.mainBackground
                        visible: index !== model.count -1
                    }
                }
            }

            Connections{
                target: dapServiceController
                function onWalletRemoved(rcvData){
                    if(rcvData.success) {
                        dapMainWindow.infoItem.showInfo(
                                                    175, 0,
                                                    dapMainWindow.width * 0.5,
                                                    8,
                                                    qsTr("Removed ") + rcvData.message,
                                                    "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
                    } else {
                        dapMainWindow.infoItem.showInfo(
                                                    200, 0,
                                                    dapMainWindow.width * 0.5,
                                                    8,
                                                    qsTr("Removed ") + rcvData.message,
                                                    "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
                    }
                }
            }

            Connections
            {
                target: dapServiceController
                onWalletsReceived:
                {
                    var jsonDocument = JSON.parse(walletList)
                    if(!jsonDocument.length)
                    {
                        dapModelWallets.clear()
                        hide()
                        return
                    }
                    dapModelWallets.clear()
                    dapModelWallets.append(jsonDocument)
                }
            }
        }
    }

    InnerShadow {
        anchors.fill: walletsFrame
        source: walletsFrame
        color: currTheme.reflection
        horizontalOffset: 1
        verticalOffset: 1
        radius: 0
        samples: 10
        opacity: walletsFrame.opacity
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: walletsFrame
        source: walletsFrame
        color: currTheme.shadowMain
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: walletsFrame.opacity ? 0.42 : 0
        cached: true
    }

    function hide() {
        backgroundFrame.opacity = 0.0
        walletsFrame.opacity = 0.0
        visible = false
    }

    function show() {
        visible = true
        backgroundFrame.opacity = 0.56
        walletsFrame.opacity = 1
    }
}
