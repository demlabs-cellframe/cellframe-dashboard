import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item
{
    id: mainItem

    implicitHeight: 45

    property int rightMarginIndicator: 16
    property int maximumPopupHeight: 200
    property int padding: 15
    property int spacing: 15

    property alias model: popupListView.model

    property int currentIndex: -1
    property string currentText: displayText
    property int count: popupListView.model ? popupListView.model.count : 0

    property bool popupVisible: false

    property font font: mainFont.dapFont.medium14

    property string mainTextRole: "name"
    property string secondTextRole: "secondname"
    property string imageRole: "status"

    property string defaultText: qsTr("Undefined")

    property string displayText: defaultText

    property color backgroundColorNormal: currTheme.mainBackground
    property color backgroundColorShow: currTheme.mainBackground
    property alias background: background

    property string enabledIcon:""
    property string disabledIcon:""

    // signal itemSelected(var index)

    onModelChanged:
    {
        print("DapCustomComboBox", "onModelChanged",
              "popupListView.currentIndex", popupListView.currentIndex,
              "name", model.get(walletModule.currentWalletIndex).walletName)

        if (popupListView.currentIndex < 0)
//            displayText = getModelData(0, mainTextRole)
            displayText = defaultText
        else
            displayText = model.get(walletModule.currentWalletIndex).walletName
    }

    onCountChanged:
    {
//        print("DapCustomComboBox", "onCountChanged",
//              "popupListView.currentIndex", popupListView.currentIndex)
        if (popupListView.currentIndex < 0)
            displayText = model.get(0).walletName
        else
            displayText = model.get(walletModule.currentWalletIndex).walletName
    }

    Rectangle
    {
        id: background
        border.width: 0
        anchors.fill: parent

        color: popupVisible ?
                   backgroundColorNormal :
                   backgroundColorShow

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: rightMarginIndicator

            Text
            {
                id: mainTextItem
                Layout.fillWidth: true

                text: mainItem.displayText
                font: mainItem.font
                color: popupVisible ?
                           currTheme.gray : currTheme.white
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            Image
            {
                id: indicator
                source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                rotation: popupVisible ? 180 : 0
                mipmap: true

                Behavior on rotation
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
            }
        }
    }

    DropShadow
    {
        visible: popupVisible
        anchors.fill: background
        horizontalOffset: currTheme.hOffset
        verticalOffset: currTheme.vOffset
        radius: currTheme.radiusShadow
        color: currTheme.shadowColor
        source: background
        samples: 10
        cached: true
    }

    InnerShadow
    {
        visible: popupVisible
        anchors.fill: background
        horizontalOffset: 1
        verticalOffset: 1
        radius: 1
        samples: 10
        cached: true
        color: "#524D64"
        source: background
        spread: 0
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed:
        {
            popupVisible = !popupVisible

            popup.visible = popupVisible

            if (popupVisible)
            {
                popupListView.positionViewAtIndex(
                            currentIndex, ListView.Contain)
            }
        }
    }

    Popup
    {
        id: popup

        scale: mainWindow.scale

        x: -width*(1/scale-1)*0.5
        y: mainItem.height - height*(1/scale-1)*0.5

        width: mainItem.width

        height: popupListView.contentHeight < maximumPopupHeight ?
                    popupListView.contentHeight : maximumPopupHeight

        padding: 0

        onVisibleChanged:
        {
            if (!mouseArea.containsMouse &&
                visible === false && popupVisible === true)
                popupVisible = false
        }

        Rectangle
        {
            id: popupBackground
            width: mainItem.width
            height: parent.height
            color: currTheme.mainBackground
            border.width: 1
            border.color: currTheme.mainBackground

            ScrollView
            {
                id: scrollView
                anchors.fill: parent
                contentHeight: popupListView.height
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: popupListView.contentHeight < maximumPopupHeight + popupBackground.border.width*2 ? ScrollBar.AlwaysOff : ScrollBar.AlwaysOn
                clip: true

                contentData:
                ListView
                {
                    id: popupListView
                    x: popupBackground.border.width
                    y: popupBackground.border.width
                    width: mainItem.width - popupBackground.border.width*2
                    implicitHeight: contentHeight

                    delegate:
                    Rectangle
                    {
                        id: menuDelegate
                        width: mainItem.width
                        height: 40
                        color: area.containsMouse ?
                                   currTheme.lime :
                                   currTheme.mainBackground

                        RowLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16

                            Text
                            {
                                Layout.fillWidth: true
                                text: walletName
                                color: area.containsMouse ?
                                           currTheme.boxes :
                                           currTheme.white
                                font: mainItem.font
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }

                            Image{
                                id: statusIcon
                                visible: statusProtected === "" ? false : true
                                // wallets combobox
                                source: statusProtected === "Active" ? enabledIcon : disabledIcon
                                mipmap: true
                            }
                        }

                        MouseArea
                        {
                            id: area
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:
                            {
                                popupListView.currentIndex = index
                                popup.visible = false
                                walletModule.setCurrentWallet(walletName)
                                displayText = walletName;
                            }
                        }
                    }
                }
            }
        }

        DropShadow
        {
            visible: popupVisible
            anchors.fill: popupBackground
            horizontalOffset: currTheme.hOffset
            verticalOffset: currTheme.vOffset
            radius: currTheme.radiusShadow
            color: currTheme.shadowColor
            source: popupBackground
            samples: 10
            cached: true
        }

        InnerShadow {
            visible: popupVisible
            anchors.fill: popupBackground
            horizontalOffset: 1
            verticalOffset: 0
            radius: 1
            samples: 10
            cached: true
            color: "#524D64"
            source: popupBackground
        }
    }

    function setCurrentIndex(index)
    {
        // Check and fix different between models
        //if(logicWallet.modelSize !== popupListView.count) logicWallet.modelSize = popupListView.count
        if(popupListView.count !== walletModelList.count) {
            console.log("[BrokenWallet]", "setCurrentIndex.", "Different models. Repeat wallets request.", "spinner ON")
            dashboardTab.state = "WALLETDEFAULT"
//            logicWallet.spiner = true
        } else {
            console.log("[BrokenWallet]", "setCurrentIndex.", "Models is equal.", "spinner OFF")
//            logicWallet.spiner = false
        }

        popupListView.currentIndex = index
        mainItem.currentIndex = index
    }
}
