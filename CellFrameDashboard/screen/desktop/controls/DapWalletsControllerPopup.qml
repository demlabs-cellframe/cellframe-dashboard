import QtQuick 2.9
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import "qrc:/widgets"

Item{
    property var walletListBuff
    property bool isBackSide: visible ? (walletActivatePopup.visible || walletDeactivatePopup.visible || removeWalletPopup.visible) : false
    property int minAnimDuration: 100

    onIsBackSideChanged:
    {
        if(isBackSide)
        {
            minAnimDuration = 100
            backgroundFrame.opacity = 0.0
            walletsFrame.opacity = 0.0
        }
        else
        {
            minAnimDuration = 0
            show()
        }
    }

    Rectangle
    {
        id: backgroundFrame
        anchors.fill: parent
        visible: opacity
        color: currTheme.popup
        opacity: 0.0

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onWheel: {}
            onClicked: hide()
        }

        Behavior on opacity {NumberAnimation{duration: minAnimDuration}}
    }

    Rectangle
    {
        id: walletsFrame
        anchors.centerIn: parent
        visible: opacity
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: minAnimDuration*2}}

        width: 328
        height: walletModelList.count > 4 ? 401 : 97 + walletModelList.count * 61
        color: currTheme.popup
        radius: currTheme.popupRadius

        MouseArea
        {
            anchors.fill: parent
        }

        HeaderButtonForRightPanels
        {
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

        ColumnLayout
        {
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
                id: walletsListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical: ScrollBar { active: true }
                model: walletModelList

                delegate:
                Item
                {
                    height: 61
                    width: walletsListView.width

                    Item
                    {
                        width: parent.width
                        height: 60

                        Item
                        {
                            height: parent.height
                            anchors.left: parent.left
                            anchors.right: statusProtected !== "" ? protectIcon.left : removeIcon.left
                            anchors.leftMargin: 24

                            DapBigText
                            {
                                fullText: walletName
                                textFont: mainFont.dapFont.regular14
                                textColor: "white"
                                anchors.fill: parent
                                verticalAlign: Text.AlignVCenter
                                horizontalAlign: Text.AlignLeft
                            }
                        }

                        Rectangle
                        {
                            id: protectIcon
                            width: 32
                            height: 32
                            radius: 4
                            color: protectArea.containsMouse ? currTheme.rowHover : currTheme.mainBackground
                            visible: statusProtected !== ""
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 64

                            Image
                            {
                                anchors.centerIn: parent
                                source: statusProtected === "non-Active" ? "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                                                                        : "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
                                mipmap: true
                            }

                            DapCustomToolTip
                            {
                                contentText: statusProtected === "non-Active" ? qsTr("Unlock wallet") : qsTr("Deactivate wallet")
                            }

                            MouseArea
                            {
                                id: protectArea
                                hoverEnabled: true
                                anchors.fill: parent

                                onClicked:
                                {
                                    if(statusProtected === "non-Active")
                                    {
                                        walletActivatePopup.show(walletName, false)
                                    }
                                    else
                                    {
                                        walletDeactivatePopup.show(walletName)
                                    }
                                }
                            }
                        }

                        Rectangle
                        {
                            id: removeIcon
                            width: 32
                            height: 32
                            radius: 4
                            color: area.containsMouse ? currTheme.rowHover : currTheme.mainBackground
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 24

                            Image
                            {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/BlackTheme/icons/other/remove_wallet.svg"
                                mipmap: true
                            }

                            MouseArea
                            {
                                id: area
                                hoverEnabled: true
                                anchors.fill: parent

                                onClicked:
                                {
                                    walletsFrame.opacity = 0.0
                                    removeWalletPopup.show(walletName)
                                }
                            }
                        }  
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: 1
                        color: currTheme.mainBackground
                        visible: index !== model.count -1
                    }
                }
            }

            Connections
            {
                target: dapServiceController
                function onWalletRemoved(rcvData)
                {
                    var jsonDocument = JSON.parse(rcvData)
                    var result = jsonDocument.result
                    if(result.success)
                    {
                        dapMainWindow.infoItem.showInfo(
                                                    175, 0,
                                                    dapMainWindow.width * 0.5,
                                                    8,
                                                    qsTr("Removed ") + result.message,
                                                    "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
                    }
                    else
                    {
                        dapMainWindow.infoItem.showInfo(
                                                    200, 0,
                                                    dapMainWindow.width * 0.5,
                                                    8,
                                                    qsTr("Removed ") + result.message,
                                                    "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
                    }
                }
            }
        }
    }

    Connections
    {
        target: walletModelList
        function onCountChanged()
        {
            if(walletModelList.count === 0)
            {
                hide()
            }
        }
    }

    InnerShadow
    {
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
    DropShadow
    {
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

    function hide()
    {
        backgroundFrame.opacity = 0.0
        walletsFrame.opacity = 0.0
        visible = false
    }

    function show()
    {
        walletModule.updateWalletList()
        visible = true
        backgroundFrame.opacity = 0.56
        walletsFrame.opacity = 1
    }
}
