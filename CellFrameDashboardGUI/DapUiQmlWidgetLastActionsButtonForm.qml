import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: buttonScroll

    property ListView viewData: ListView{}
    property bool isHovered: false

    width: 36 * pt
    height: width
    anchors.right: viewData.right
    anchors.bottom: viewData.bottom
    anchors.bottomMargin: 10 * pt
    anchors.topMargin: 10 * pt
    anchors.rightMargin: 10 * pt
    visible: false

    Image {
        id: imageButton
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Resources/Icons/ic_scroll-down.png"
    }

    states: [
        State {
            name: "goDown"
            PropertyChanges {
                target: buttonScroll
                onStateChanged: {
                    buttonScroll.anchors.top = undefined;
                    buttonScroll.anchors.bottom = dapListView.bottom;
                    buttonMouseArea.exited();
                }
            }
        },

        State {
            name: "goUp"
            PropertyChanges {
                target: buttonScroll
                onStateChanged: {
                    buttonScroll.anchors.bottom = undefined;
                    buttonScroll.anchors.top = viewData.top;
                    buttonMouseArea.exited();
                }
            }
        }
    ]

    state: "goUp"

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            isHovered = true;
            if(buttonScroll.state === "goUp")
                imageButton.source = "qrc:/Resources/Icons/ic_scroll-down_hover.png";
            else if(buttonScroll.state === "goDown")
                imageButton.source = "qrc:/Resources/Icons/ic_scroll-up_hover.png";

        }

        onExited: {
            isHovered = false;
            if(buttonScroll.state === "goUp")
                imageButton.source = "qrc:/Resources/Icons/ic_scroll-down.png";
            else if(buttonScroll.state === "goDown")
                imageButton.source = "qrc:/Resources/Icons/ic_scroll-up.png";
        }

        onClicked: {
            if(buttonScroll.state === "goUp")
            {
                viewData.positionViewAtEnd();
                buttonScroll.state = "goDown";
            }
            else if(buttonScroll.state === "goDown")
            {
                viewData.positionViewAtBeginning();
                buttonScroll.state = "goUp";
            }
        }
    }
}
