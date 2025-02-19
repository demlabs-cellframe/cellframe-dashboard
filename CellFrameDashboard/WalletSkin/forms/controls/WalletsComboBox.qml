import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "qrc:/widgets"

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
    property int count: popupListView.model.count

    property bool popupVisible: false

    property font font: mainFont.dapFont.medium14

    property string mainTextRole: "name"
    property string secondTextRole: "secondname"
    property string imageRole: "status"

    property string defaultText: qsTr("Undefined")

    property string displayText: defaultText

    property color backgroundColor: currTheme.secondaryBackground

    property string enabledIcon:""
    property string disabledIcon:""

    signal itemSelected(var index)

    onModelChanged: updateDisplayText()
    onCountChanged: updateDisplayText()

    function updateDisplayText()
    {
        var currentWallet = walletModule.getCurrentWalletName()
        displayText = currentWallet !== "" ? currentWallet : defaultText;
    }

    Rectangle
    {
        id: background
        anchors.fill: parent

        color: "transparent"

        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: rightMarginIndicator
            spacing: 8

            Item{
                Layout.fillWidth: true
            }

            Text
            {
//                Layout.fillWidth: true
                Layout.maximumWidth: 250
                Layout.leftMargin: 28
                id: mainTextItem
//                Layout.fillWidth: true

                text: mainItem.displayText
                font: mainItem.font
                color: popupVisible ?
                           currTheme.gray : currTheme.white
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            DapImageRender
            {

                id: indicator
                source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                rotation: popupVisible ? 180 : 0

                Behavior on rotation
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
            }
            Item{
                Layout.fillWidth: true
            }
        }
    }

//    DropShadow
//    {
//        visible: popupVisible
//        anchors.fill: background
//        horizontalOffset: currTheme.hOffset
//        verticalOffset: currTheme.vOffset
//        radius: currTheme.radiusShadow
//        color: currTheme.shadowColor
//        source: background
//        samples: 10
//        cached: true
//    }

//    InnerShadow
//    {
//        visible: popupVisible
//        anchors.fill: background
//        horizontalOffset: 1
//        verticalOffset: 1
//        radius: 1
//        samples: 10
//        cached: true
//        color: "#524D64"
//        source: background
//        spread: 0
//    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed:
        {
            popupVisible = !popupVisible

            popup.visible = popupVisible

//            print("DapCustomComboBox", "mouseArea",
//                  "popupVisible", popupVisible)

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

//        visible: popupVisible

//        x: 0
//        y: mainItem.height

        x: 0
        y: mainItem.height

        width: popupBackground.width
        height: popupBackground.height

        padding: 0

        onVisibleChanged:
        {
//            print("DapCustomComboBox", "onVisibleChanged",
//                  "visible", visible,
//                  "popupVisible", popupVisible)

            if (!mouseArea.containsMouse &&
                visible === false && popupVisible === true)
                popupVisible = false
        }

        background: Item{}

        contentData:
        Rectangle
        {
            id: popupBackground

            width: mainItem.width
            height: popupListView.height + border.width*2

            color: currTheme.secondaryBackground
            radius: 4

            border.width: 1
            border.color: currTheme.secondaryBackground

            ListView
            {
                id: popupListView

//                visible: popupVisible

                x: popupBackground.border.width
                y: popupBackground.border.width
                width: mainItem.width - popupBackground.border.width*2
                implicitHeight:
                    contentHeight < maximumPopupHeight ?
                        contentHeight : maximumPopupHeight

                clip: true

                ScrollIndicator.vertical:
                    ScrollIndicator { }

                delegate:
                Rectangle
                {
                    id: menuDelegate
                    width: mainItem.width - 2
                    height: 40

                    color: area.containsMouse ?
                               currTheme.lime :
                               currTheme.secondaryBackground

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
                                       currTheme.mainBackground :
                                       currTheme.white
                            font: mainItem.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text
                        {
                            text: getModelData(index, secondTextRole)
                            color: currTheme.gray
                            font.family: mainItem.font.family
                            font.pointSize: mainItem.font.pointSize - 3
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        DapImageRender{
                            property var data: getModelData(index, imageRole)
                            id: statusIcon
                            visible: statusProtected === "" ? false : true
                            // wallets combobox
                            source: statusProtected === "Active" ? enabledIcon : disabledIcon

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
                            itemSelected(index)
                        }
                    }
                }

                onCurrentIndexChanged: /* no call*/
                {
                    displayText = getModelData(currentIndex, mainTextRole)
                    mainItem.currentIndex = currentIndex
                }

            }

        }

        DropShadow
        {
            visible: popupVisible
            anchors.fill: popupBackground
            horizontalOffset: 0
            verticalOffset: 4
            radius: 5
            color: "#000000"
            source: popupBackground
            samples: 10
            cached: true
            opacity: 0.24
        }
    }

    function getModelData(index, role)
    {
        if(count <= 0)
            return ""

        if (model.get(index) === undefined)
            return ""

        var text = model.get(index)[role]

        if (text === undefined)
            return ""
        else
            return text;
    }

    function setCurrentIndex(index)
    {
        popupListView.currentIndex = index
        mainItem.currentIndex = index
//        currentIndex = index
    }
}
