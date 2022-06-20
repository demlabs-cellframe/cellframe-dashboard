import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQml 2.12
import "logic"

ComboBox {
    id: control

    implicitHeight: 45

    leftPadding: 15
    rightPadding: 15

    property alias logic: logic
    property int maximumPopupHeight: 230
    property int widthPopup: 350
    property string mainTextRole: "pair"
    property string defaultText: qsTr("Undefined")
    property var displayElement
    spacing: 0

    LogicComboBox{id: logic}
    ListModel{id: temporaryModel}
    ListModel{id: mainModel}

    displayText: displayElement ?
                     displayElement.pair :
                     defaultText

    delegate:
        ItemDelegate
        {
            id: menuDelegate
            width: widthPopup
            height: 40

            contentItem:
            Item
            {
                anchors.fill: parent
                Text
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    text: logic.getModelData(index, mainTextRole)
                    color: menuDelegate.highlighted ?
                               currTheme.hilightTextColorComboBox :
                               currTheme.textColor
                    font: mainFont.dapFont.regular13
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 138
                    anchors.verticalCenter: parent.verticalCenter
                    text: logic.getModelData(index, "price")
                    color: menuDelegate.highlighted ?
                               currTheme.hilightTextColorComboBox :
                               currTheme.textColor
                    font: mainFont.dapFont.regular13
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text
                {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 16
                    text: logic.getModelData(index, "change")
                    color: menuDelegate.highlighted ?
                               currTheme.hilightTextColorComboBox :
                               text[0] === "+" ? currTheme.textColorGreen:currTheme.textColorRed
                    font: mainFont.dapFont.regular13
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.lineSeparatorColor
                }

                MouseArea
                {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
                        displayElement = mainModel.get(index)
                        control.currentIndex = index
                        control.popup.close()
                    }

                }
            }

            background:
            Rectangle
            {
                anchors.fill: parent
                color: menuDelegate.highlighted ?
                           currTheme.hilightColorComboBox :
                           currTheme.backgroundElements
            }

            hoverEnabled: true
            highlighted: control.highlightedIndex === index
        }

    indicator:
        Image
        {
            id: canvas
            width: 24
            height: 24
            x: control.width - width - control.rightPadding
            y: control.topPadding + (control.availableHeight - height) / 2

            fillMode: Image.PreserveAspectFit
            source: "icons/icon_arrow_down.png"
            sourceSize.width: 24
            rotation: control.popup.opened ? 180 : 0

            Behavior on rotation { NumberAnimation { duration: 200 } }
        }

    contentItem:
        RowLayout
        {
            anchors.fill: parent
            spacing: 4

            Image{
                id: coin1
                mipmap: true
                source: logic.getIcon(displayElement.pair.split("/")[0])
                sourceSize.height: 32
                sourceSize.width: 32
            }
            Image{
                id: coin2
                mipmap: true
                source: logic.getIcon(displayElement.pair.split("/")[1])
                sourceSize.height: 32
                sourceSize.width: 32
            }
            Text
            {
                Layout.leftMargin: 4
                leftPadding: 0
                text: displayElement.pair
                font: mainFont.dapFont.medium14
                color: currTheme.textColor
                elide: Text.ElideLeft
            }

            Item{Layout.fillWidth: true}
        }

    background: Item{}

    popup:
    Popup
    {
        id: popup
        y: control.height //11 - maket spacing
        width: widthPopup
        implicitHeight: contentItem.implicitHeight/* + 3*/
            //+3 is needed to make ListView less moovable

        topPadding: 0
        bottomPadding: 0
        leftPadding: 1
        rightPadding: 1

        contentItem:

        ColumnLayout
        {
            anchors.fill: parent
            spacing: 0
            Rectangle
            {
                width: popup.width
                height: 71
                z:2
                color: currTheme.backgroundElements

                ColumnLayout{
                    anchors.fill: parent

                    spacing: 8
                    SearchElement{
                        id: search
                        Layout.fillWidth: true
                        onFindHandler: {
                            logic.searchElement(text)

                        }
                    }

                    Rectangle
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: currTheme.backgroundPanel

                        Item
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16

                            Text{
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text:"Pair"
                                font: mainFont.dapFont.medium12
                                color: currTheme.textColor

                            }
                            Text{
                                anchors.left: parent.left
                                anchors.leftMargin: 122
                                anchors.verticalCenter: parent.verticalCenter
                                text:"Price"
                                font: mainFont.dapFont.medium12
                                color: currTheme.textColor

                            }
                            Text{
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text:"Change"
                                font: mainFont.dapFont.medium12
                                color: currTheme.textColor

                            }
                        }

                    }
                }
            }

            ListView
            {
                id: listView
                Layout.fillWidth: true
                implicitHeight:
                    contentHeight < maximumPopupHeight ?
                    contentHeight : maximumPopupHeight

                clip: true
                model: control.popup.visible ?
                       control.delegateModel : null
                currentIndex: control.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }

        background:
            Item{
                anchors.fill: parent

                Rectangle
                {
                    id: popupBackGrnd
                    border.width: 0
                    anchors.fill: parent

                    color: currTheme.backgroundElements
                }

                DropShadow
                {
                    anchors.fill: popupBackGrnd
                    horizontalOffset: currTheme.hOffset
                    verticalOffset: currTheme.vOffset
                    radius: currTheme.radiusShadow
                    color: currTheme.shadowColor
                    source: popupBackGrnd
                    samples: 10
                    cached: true
                }
                DropShadow
                {
                    anchors.fill: popupBackGrnd
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 7
                    color: currTheme.shadowColor
                    source: popupBackGrnd
                    samples: 10
                    cached: true
                }

//                InnerShadow {
//                    anchors.fill: popupBackGrnd
//                    horizontalOffset: 1
//                    verticalOffset: 0
//                    radius: 1
//                    samples: 10
//                    cached: true
//                    color: "#524D64"
//                    source: popupBackGrnd
//                }
            }
    }
}
