import QtQuick 2.0
import QtQml 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "parts"
import "logic"

Rectangle {

    property alias dapNetworkList: networkList

    property int cur_index: 0
    property int visible_count: 4
    readonly property int item_width: 295 

    LogicNetworks{id: logicNet}
    Timer{id: timer}

    id: control
    y: parent.height - height
    width: parent.width
//    height: 40
    color: currTheme.mainBackground

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        DapNetworkButton
        {
            id: left_button
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 7
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
            model: networkModel
            highlightMoveDuration : 200

            orientation: ListView.Horizontal
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            delegate: DapNetworkDelegate{}
            interactive: false
            clip: true

            onWidthChanged:
            {
                control.visible_count = logicNet.getCountVisiblePopups()
            }
        }

        DapNetworkButton
        {
            id: right_button
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 7

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
        control.visible_count = logicNet.getCountVisiblePopups()
        networkList.currentIndex = cur_index
        networkList.closePopups()
    }
}
