import QtQuick 2.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item {

    property alias dapNetworkList: networkList

    property int cur_index: 0
    property int visible_count: 4
    readonly property int item_width: 290 * pt

    ListModel {id: networksModel}

    id: control
    y: parent.height - height
    width: parent.width
    height: 40

    Item
    {
        id: animationController
        visible: false

        SequentialAnimation {
            NumberAnimation {
                target: animationController
                properties: "opacity"
                from: 1.0
                to: 0.1
                duration: 700
            }

            NumberAnimation {
                target: animationController
                properties: "opacity"
                from: 0.1
                to: 1.0
                duration: 700
            }
            loops: Animation.Infinite
            running: true
        }
    }

    RowLayout
    {
        DapNetworksButton
        {
            id: left_button
            anchors.left: parent.left
            anchors.leftMargin: 7 * pt
            anchors.verticalCenter: parent.verticalCenter

            visible: networkList.count > visible_count && networkList.currentIndex != 0 ? true : false

            mirror: true

            onClicked:
            {
                if(networkList.currentIndex === networkList.count -1)
                {
                    networkList.currentIndex = networkList.currentIndex - (visible_count - 1)
                    networkList.isRight = false
                }

                if (networkList.currentIndex > 0) {
                    if(networkList.isRight)
                        networkList.currentIndex = networkList.currentIndex - (visible_count - 1)

                    var zero = 0;

                    for(var i = visible_count-1; i > 0; i--)
                    {
                        if(networkList.currentIndex - i >= zero )
                        {
                            networkList.currentIndex -= i
                            break;
                        }
                    }
                    networkList.closePopups()
                }
                networkList.isRight = false
            }
        }

        ListView {
            signal closePopups()
            property bool isRight:true
            id: networkList
            model: networksModel
            highlightMoveDuration : 200

            orientation: ListView.Horizontal
            anchors.right: right_button.left
            anchors.left: left_button.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            anchors.leftMargin: 10 * pt
            anchors.rightMargin: 10 * pt
            delegate: dapNetworkItem
            interactive: false
            clip: true

            onWidthChanged:
            {
                control.visible_count = getCountVisiblePopups()
            }
        }

        DapNetworksButton
        {
            id: right_button
            anchors.right: parent.right
            anchors.rightMargin: 7 * pt

            anchors.verticalCenter: parent.verticalCenter
            visible: networkList.count > visible_count && networkList.currentIndex != networkList.count -1 ? true : false

            onClicked: {
                if(!networkList.currentIndex)
                {
                    networkList.currentIndex = visible_count - 1
                    networkList.isRight = true
                }

                if (networkList.currentIndex < networkList.count-1) {

                    if(!networkList.isRight)
                        networkList.currentIndex = networkList.currentIndex + (visible_count - 1)


                    for(var i = visible_count-1; i > 0; i--)
                    {
                        if(networkList.currentIndex + i <= networkList.count -1)
                        {
                            networkList.currentIndex += i
                            break;
                        }
                    }
                    networkList.closePopups()
                }
                networkList.isRight = true
            }
        }

    }



    onWidthChanged:
    {
        control.visible_count = getCountVisiblePopups()
        networkList.currentIndex = cur_index
        networkList.closePopups()
    }

}
