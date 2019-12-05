import QtQuick 2.0

DapUiQmlScreenMainWindowForm {
    id: dapQmlScreenMainWindow

    Component {
        id: componentItemMainMenuTab

        Rectangle {
            id: componentItem
            property bool isPushed: listViewTabs.currentIndex === index
            width: 180 * pt
            height: 60 * pt
            color: "transparent"

            Image
            {
                id: imageItem
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 24 * pt
                source: model.normal
                height: 18 * pt
                width: 18 * pt
            }

            Text {
                id: textItemMenu
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: imageItem.right
                anchors.leftMargin: 18 * pt
                text: name
                font.family: fontRobotoLight.name
                font.pixelSize: 16 * pt
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(!componentItem.isPushed)
                    {
                        imageItem.source = model.hover;
                        textItemMenu.font.family = fontRobotoRegular.name;
                    }
                }

                onExited: {
                    if(!componentItem.isPushed)
                    {
                        imageItem.source = model.normal
                        textItemMenu.font.family = fontRobotoLight.name;
                    }
                }

                onClicked: {
                    listViewTabs.currentIndex = index;
                    rightPanel.header.clear(StackView.Immediate);
                    rightPanel.content.clear(StackView.Immediate);

                    var headerData = panelHeader;
                    var contentData = panelContent;
                    if(panelHeader !== "" || panelContent !== "")
                    {
                        rightPanel.visible = true;
                        if(headerData !== "") rightPanel.header.push(Qt.resolvedUrl(headerData));
                        if(contentData !== "") rightPanel.content.push(Qt.resolvedUrl(contentData));
                    }
                    else rightPanel.visible = false;


                    stackViewScreenDashboard.setSource(Qt.resolvedUrl(page), {"rightPanel": rightPanel});
                }
            }

            onIsPushedChanged: {
                componentItem.color = (isPushed ? "#D51F5D" : "transparent");
                imageItem.source = isPushed ? model.hover : model.normal;
                textItemMenu.font.family = (isPushed ? fontRobotoRegular.name : fontRobotoLight.name);
            }
        }
    }
}
