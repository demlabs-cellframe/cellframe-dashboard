import QtQuick 2.9
import QtQuick.Controls 1.4

DapUiQmlScreenMainWindowForm {
    id: dapQmlScreenMainWindow

    Component{
        id: componentItemMainMenuTab
            Column {
            id: columnTab
            height: 148
            Rectangle {
                id: componentItem
                property bool isPushed: listViewTabs.currentIndex === index

                width: listViewTabs.width
                height: 150
                color: "transparent"
                Rectangle
                {
                    id: spacerItem1
                    height: 25
                    anchors.top: parent.top
                }
                Image
                {
                    id: imageItem
                    anchors.top: spacerItem1.bottom
                    source: model.source
                    height: 60
                    width: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle
                {
                    id: spacerItem2
                    anchors.top: imageItem.bottom
                    height: 16
                }
                Text
                {
                    id: textItemMenu
                    anchors.top: spacerItem2.bottom
                    text: qsTr(name)
                    color: "#505559"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Roboto"
                    font.weight: componentItem.isPushed ? Font.Normal : Font.Light
                    font.pointSize: 16
                }
                Rectangle
                {
                    id: spacerItem3
                    anchors.top: textItemMenu.bottom
                    height: 30
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered:
                    {
                        textItemMenu.font.weight = Font.Normal
                        if(!componentItem.isPushed) componentItem.color ="#B0B0B5"
                    }
                    onExited:
                    {
                        textItemMenu.font.weight = Font.Light
                        if(!componentItem.isPushed) componentItem.color = "transparent"
                    }

                    onClicked:
                    {
                        listViewTabs.currentIndex = index
                        stackViewScreenDashboard.setSource(Qt.resolvedUrl(page))
                    }
                }

                onIsPushedChanged: {
                    componentItem.color = (isPushed ? "#D0D3D6" : "transparent");
                }
            }
            Rectangle
            {
                id: borderItem
                height: 1
                color: "#B5B5B5"
                width: parent.width
            }
        }
    }
}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
