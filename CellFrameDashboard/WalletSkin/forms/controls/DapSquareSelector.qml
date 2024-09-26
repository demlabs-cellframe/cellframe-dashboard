import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle
{
    id: selectorItem

    property int itemHorisontalBorder: 10
    property int itemVerticalBorder: -2
    property int viewerBorder: 0
    property int currentIndex: viewerItem.currentIndex
    property alias selectorModel: viewerItem.model
    property alias selectorListView: viewerItem

    signal itemSelected()

    color: currTheme.mainBackground

    property int scrollStep: selectorItem.width*0.4
    property int maxX: scroll.contentWidth

    property int nextX: 0

    Rectangle
    {
        x: 0
        y: 0
        z: 2
        height: 1
        width: parent.width
        color: currTheme.secondaryBackground
    }

    Rectangle
    {
        x: 0
        y: parent.height-1
        z: 2
        height: 1
        width: parent.width
        color: currTheme.secondaryBackground
    }

    Rectangle
    {
        x: 0
        y: 0
        z: 1
        width: selectorItem.height
        height: selectorItem.height
        visible: nextX > 0
        color: currTheme.mainBackground

        Image {
            x: (parent.width - width)*0.5
            y: (parent.height - height)*0.5
            source: "qrc:/walletSkin/Resources/BlackTheme/icons/other/left_arrow.png"
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                nextX = scroll.contentX - scrollStep
                if (nextX < 0)
                    nextX = 0
                scroll.contentX = nextX
            }

        }
    }

    Flickable
    {
        id: scroll
        x: 0
        y: 0
        width: selectorItem.width
        height: selectorItem.height
        contentWidth: viewerItem.width
        contentHeight: viewerItem.height
        interactive: false
        clip: true

        Behavior on contentX {
            NumberAnimation {
                duration: 200
            }
        }

        ListView
        {
            id: viewerItem
            x: viewerBorder
            y: viewerBorder
            width: contentItem.width + viewerBorder * 2
            height: selectorItem.height
            clip: true
            orientation: ListView.Horizontal
            interactive: false

            highlight:
                Rectangle
                {
                    id: hl
                    color: currTheme.secondaryBackground
                }

            model: selectorModel

            delegate:
                Rectangle
                {
                    id: frameItem
                    width: textItem.width + itemHorisontalBorder * 2
                    height: selectorItem.height - viewerBorder * 2

                    color: "transparent"

                    Text
                    {
                        id: textItem
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: frameItem.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        bottomPadding: OS_WIN_FLAG && !fullScreen.FULLSCREEN ? 4 : 0
                        color: currTheme.white
                        font: mainFont.dapFont.medium14
                        text: name

                    }

                    MouseArea
                    {
                        anchors.fill: parent

                        onClicked: {
                            viewerItem.currentIndex = index
                            itemSelected()
                        }
                    }
                }

        }

    }

    Rectangle
    {
        x: selectorItem.width - selectorItem.height
        y: 0
        z: 1
        width: selectorItem.height
        height: selectorItem.height
        visible: nextX < scroll.contentWidth-scroll.width-1
        color: currTheme.mainBackground

        Image {
            x: (parent.width - width)*0.5
            y: (parent.height - height)*0.5
            source: "qrc:/walletSkin/Resources/BlackTheme/icons/other/right_arrow.png"
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                nextX = scroll.contentX + scrollStep
                if (nextX >= scroll.contentWidth-scroll.width)
                    nextX = scroll.contentWidth-scroll.width-1
                scroll.contentX = nextX
            }

        }
    }
}
