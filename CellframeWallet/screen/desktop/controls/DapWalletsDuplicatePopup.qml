import QtQuick 2.9
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import "qrc:/widgets"

Item
{
    property alias duplicateModel: duplicateModel

    property bool isBackSide: visible ? (walletActivatePopup.visible || walletDeactivatePopup.visible || removeWalletPopup.visible) : false
    property int minAnimDuration: 100

    ListModel{id: duplicateModel}

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
                    text: qsTr("Duplicate wallets that\nare not included in the list of wallets.")
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

                // Text
                // {
                //     color: currTheme.white
                //     text: qsTr("Wallets")
                //     font: mainFont.dapFont.medium12
                //     horizontalAlignment: Text.AlignHCenter
                //     anchors.verticalCenter: parent.verticalCenter
                //     anchors.left: parent.left
                //     anchors.leftMargin: 24
                // }
            }

            ListView {
                id: walletsListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical: ScrollBar { active: true }
                model: duplicateModel

                delegate:
                Item
                {
                    height: 60
                    width: walletsListView.width

                    Item
                    {
                        width: parent.width
                        height: 59

                        Item
                        {
                            height: 28
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 2
                            anchors.leftMargin: 24
                            anchors.rightMargin: 24
                            Text
                            {
                                id: walletText
                                font: mainFont.dapFont.regular14
                                color: currTheme.white
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                text: "Wallet: "
                                verticalAlignment: Text.AlignVCenter
                            }

                            DapBigText
                            {
                                id: walletNameText
                                fullText: walletName
                                textFont: mainFont.dapFont.regular14
                                textColor: currTheme.white
                                anchors.left: walletText.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                verticalAlign: Text.AlignVCenter
                                horizontalAlign: Text.AlignLeft
                            }
                        }
                        Item
                        {
                            height: 28
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 24
                            anchors.leftMargin: 24

                            Text
                            {
                                id: pathText
                                font: mainFont.dapFont.regular14
                                color: currTheme.white
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                text: "Path: "
                                verticalAlignment: Text.AlignVCenter
                            }

                            DapBigText
                            {
                                fullText: walletPath
                                textFont: mainFont.dapFont.regular14
                                textColor: currTheme.white
                                anchors.left: pathText.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                verticalAlign: Text.AlignVCenter
                                horizontalAlign: Text.AlignLeft
                            }
                        }
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: 1
                        color: currTheme.mainBackground
                        anchors.bottom: parent.bottom
                    }
                }
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
